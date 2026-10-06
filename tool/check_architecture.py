#!/usr/bin/env python3
"""Validate Mahafez package layer dependencies and public import boundaries."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


LAYERS = {
    "mahafez_core": 1,
    "mahafez_design_system": 1,
    "sms_engine": 2,
    "identity_service": 2,
    "wallet_product": 3,
    "identity_product": 3,
    "workspace_product": 3,
    "mahafez_app": 4,
}
PRODUCTS = {name for name, layer in LAYERS.items() if layer == 3}
APP_PRODUCT_PINS = {
    "wallet_product": "v2.1.0",
    "identity_product": "v1.0.2",
    "workspace_product": "v1.0.0",
}
PACKAGE_GIT_PINS = {
    "identity_product": {"identity_service": "v1.1.0"},
    "workspace_product": {"identity_service": "v1.1.0"},
}


def package_dependencies(pubspec: str) -> set[str]:
    in_dependencies = False
    found: set[str] = set()
    for line in pubspec.splitlines():
        if re.match(r"^dependencies:\s*$", line):
            in_dependencies = True
            continue
        if in_dependencies and re.match(r"^(dev_dependencies|dependency_overrides):", line):
            break
        if in_dependencies:
            match = re.match(r"^  ([A-Za-z0-9_]+):", line)
            if match:
                found.add(match.group(1))
    return found


def lock_entry(lock: str, package: str) -> str | None:
    match = re.search(
        rf"^  {re.escape(package)}:\n(.*?)(?=^  [A-Za-z0-9_]+:|\Z)",
        lock,
        re.MULTILINE | re.DOTALL,
    )
    return match.group(1) if match else None


def check_lockfile(app_root: Path, roots: dict[str, Path]) -> list[str]:
    errors: list[str] = []
    pubspec = (app_root / "pubspec.yaml").read_text()
    lock_path = app_root / "pubspec.lock"
    if not lock_path.is_file():
        return ["mahafez_app: pubspec.lock is missing"]
    lock = lock_path.read_text()
    for package, expected_ref in APP_PRODUCT_PINS.items():
        if package not in package_dependencies(pubspec):
            errors.append(f"mahafez_app: {package} is not a direct dependency")
            continue
        entry = lock_entry(lock, package)
        if entry is None:
            errors.append(f"mahafez_app: pubspec.lock has no entry for {package}")
            continue
        if 'source: git' not in entry:
            errors.append(f"mahafez_app: {package} is not resolved from Git")
        ref = re.search(r'^      ref: "?([^"\n]+)"?$', entry, re.MULTILINE)
        resolved = re.search(
            r'^      resolved-ref: "?([0-9a-f]{40})"?$', entry, re.MULTILINE
        )
        if not ref or ref.group(1).strip('"') != expected_ref:
            errors.append(f"mahafez_app: {package} lock ref must be {expected_ref}")
        if not resolved:
            errors.append(f"mahafez_app: {package} has no resolved Git commit in pubspec.lock")
    for owner, pins in PACKAGE_GIT_PINS.items():
        package_root = roots[owner]
        owner_lock_path = package_root / "pubspec.lock"
        if not owner_lock_path.is_file():
            errors.append(f"{owner}: pubspec.lock is missing")
            continue
        owner_lock = owner_lock_path.read_text()
        for package, expected_ref in pins.items():
            entry = lock_entry(owner_lock, package)
            if entry is None or "source: git" not in entry:
                errors.append(f"{owner}: {package} is not locked as a Git dependency")
                continue
            ref = re.search(r'^      ref: "?([^"\n]+)"?$', entry, re.MULTILINE)
            resolved = re.search(
                r'^      resolved-ref: "?([0-9a-f]{40})"?$', entry, re.MULTILINE
            )
            if not ref or ref.group(1) != expected_ref:
                errors.append(f"{owner}: {package} lock ref must be {expected_ref}")
            if not resolved:
                errors.append(f"{owner}: {package} has no resolved Git commit in pubspec.lock")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=None)
    parser.add_argument("--target-package", choices=LAYERS, default="mahafez_app")
    parser.add_argument("--repos-dir", type=Path, required=True)
    args = parser.parse_args()
    repos_dir = args.repos_dir.resolve()
    roots = {name: repos_dir / name for name in LAYERS}
    target_root = (args.root or repos_dir / args.target_package).resolve()
    roots[args.target_package] = target_root
    app_root = roots["mahafez_app"]

    errors: list[str] = []
    dependencies: dict[str, set[str]] = {}
    for package, package_root in roots.items():
        pubspec_path = package_root / "pubspec.yaml"
        if not pubspec_path.is_file():
            errors.append(f"{package}: missing {pubspec_path}")
            continue
        dependencies[package] = package_dependencies(pubspec_path.read_text())
        for dependency in dependencies[package] & LAYERS.keys():
            source_layer = LAYERS[package]
            dependency_layer = LAYERS[dependency]
            if dependency_layer > source_layer:
                errors.append(
                    f"{package} (Layer {source_layer}) depends upward on "
                    f"{dependency} (Layer {dependency_layer})"
                )
            if source_layer == 3 and dependency in PRODUCTS and dependency != package:
                errors.append(f"{package} has a forbidden peer product dependency on {dependency}")
            if package == "mahafez_app" and dependency_layer == 2:
                errors.append(f"mahafez_app must not directly depend on Layer 2 package {dependency}")

        lib_dir = package_root / "lib"
        if not lib_dir.is_dir():
            continue
        for source in lib_dir.rglob("*.dart"):
            text = source.read_text(errors="replace")
            for imported in re.findall(r"package:([a-zA-Z0-9_]+)/([^'\"]+)", text):
                dependency, path = imported
                if dependency in LAYERS and dependency != package:
                    if dependency not in dependencies.get(package, set()):
                        errors.append(f"{package}: imports {dependency} without declaring it ({source})")
                    if "/src/" in f"/{path}":
                        errors.append(f"{package}: imports private {dependency} implementation ({source})")
                    source_layer = LAYERS[package]
                    dependency_layer = LAYERS[dependency]
                    if dependency_layer > source_layer:
                        errors.append(f"{package}: imports upward from {dependency} ({source})")
                    if source_layer == 3 and dependency in PRODUCTS:
                        errors.append(f"{package}: imports peer product {dependency} ({source})")
                    if package == "mahafez_app" and dependency_layer == 2:
                        errors.append(f"mahafez_app: imports Layer 2 package {dependency} ({source})")

    errors.extend(check_lockfile(app_root, roots))
    if errors:
        print("Architecture check failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print("Architecture check passed for all Mahafez layers and app release pins.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

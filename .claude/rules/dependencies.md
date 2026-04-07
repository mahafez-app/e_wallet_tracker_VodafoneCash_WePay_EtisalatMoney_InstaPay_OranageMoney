# Dependency Management

---

## Core Policy

- **Minimal by default.** Prefer native Flutter / Dart solutions. A package
  is justified only when the problem is genuinely complex or a manual
  implementation would be fragile to maintain long-term.
- **50-line gate.** Before adding any package, ask: can this be implemented
  cleanly in under 50 lines of Dart? If yes, implement it manually.
- **No unnecessary code generation.** The only accepted code generators are
  `json_serializable` (for REST DTOs) and `build_runner` to support it.
  `freezed`, `injectable`, `auto_route`, `riverpod_generator`, `hive_generator`
  are forbidden.
- **Latest stable versions.** Always use the latest stable release. Never use
  `any` as a version constraint. Flag packages with known breaking changes
  before upgrading.
- **Transitive dependency awareness.** Before adding a package, inspect its
  dependency tree. If it pulls heavy transitive dependencies for a minor
  feature, implement it manually instead.
- **Prefer verified publishers.** Prefer `dart.dev`, `flutter.dev`, `google.dev`
  and other high-trust verified publishers for core infrastructure packages.

---

## Forbidden Packages (no exceptions, no justification accepted)

| Package | Reason |
|---------|--------|
| `get` / GetX | Global state, implicit routing, violates Clean Architecture |
| `provider` | Use Riverpod instead |
| `mobx` | Reactive magic, mutable observable state, incompatible with sealed state |
| `injectable` | Code-gen DI, replaced by manual Riverpod composition |
| `get_it` | Service locator anti-pattern |
| `freezed` | Unnecessary code gen; manual immutable classes are preferred |
| `auto_route` | Use `go_router` |
| `riverpod_generator` | Use manual provider declarations |
| `hive_generator` | Use manual or `shared_preferences` / `flutter_secure_storage` |

---

## Approved Core Packages

Pre-approved. Do not re-evaluate or suggest alternatives unless explicitly
deprecated. Versions are minimum baselines — always use latest stable.

### State & DI

| Purpose | Package |
|---------|---------|
| State management & DI | `flutter_riverpod` |

### Navigation

| Purpose | Package |
|---------|---------|
| Routing | `go_router` |

### Firebase

| Purpose | Package |
|---------|---------|
| Firebase init | `firebase_core` |
| Authentication | `firebase_auth` |
| Cloud Firestore | `cloud_firestore` |
| Cloud Storage | `firebase_storage` |
| Push Notifications | `firebase_messaging` |
| Remote Config | `firebase_remote_config` |
| Analytics | `firebase_analytics` |
| Crashlytics | `firebase_crashlytics` |
| Performance | `firebase_performance` |
| App Check | `firebase_app_check` |

Add only the Firebase packages the project actively uses. Do not add the
entire Firebase suite by default.

### Networking

| Purpose | Package |
|---------|---------|
| HTTP client | `dio` |
| WebSockets (if needed) | `web_socket_channel` |

### Serialization

| Purpose | Package |
|---------|---------|
| JSON codegen | `json_serializable`, `json_annotation` |

### Storage

| Purpose | Package |
|---------|---------|
| Key-value storage | `shared_preferences` |
| Secure storage | `flutter_secure_storage` |

### UI

| Purpose | Package |
|---------|---------|
| Network images | `cached_network_image` |
| SVG rendering | `flutter_svg` |

### Utilities

| Purpose | Package |
|---------|---------|
| Value equality | `equatable` |
| Environment config | `flutter_dotenv` or compile-time `--dart-define` |

---

## Dev / Test Dependencies

| Purpose | Package |
|---------|---------|
| Build runner | `build_runner` |
| Mocking | `mocktail` |
| Riverpod testing | `riverpod_test` |
| Widget testing | `flutter_test` (SDK) |
| Integration testing | `integration_test` (SDK) |

---

## Package Commands

```shell
# Add a regular dependency
flutter pub add <package_name>

# Add a dev dependency
flutter pub add dev:<package_name>

# Remove a dependency
dart pub remove <package_name>

# Upgrade to latest compatible versions
flutter pub upgrade

# Upgrade a single package to latest
flutter pub upgrade <package_name>

# Check for outdated packages
flutter pub outdated

# After adding or changing any json_serializable model
dart run build_runner build --delete-conflicting-outputs
```

---

## Adding a New Package — Checklist

Before adding any package not in the approved list:

1. Can this be done in < 50 lines of clean Dart? If yes → implement manually.
2. Is there an approved package that already covers this? If yes → use it.
3. Is the package actively maintained (recent commits, open issue responses)?
4. Does the pub.dev score meet: >120 points, health >90%?
5. Does the package have a verified publisher?
6. Does the transitive dependency tree add significant weight?
7. Are there any known breaking changes in the current version?

Only after passing all 7 checks: add the package and document the justification
in a comment in `pubspec.yaml`.

```yaml
dependencies:
  # Approved: official Google package, required for deep link handling on Android.
  app_links: ^6.3.4
```

---
name: pr-prep
description: Prepare the current working branch for a pull request. Runs automated fixes, static analysis, tests, cleans up debug code and unused imports, hardens test coverage, and produces a conventional commit message. Does not commit or push. Use when you are ready to submit your work: `pr-prep`.
---

Before executing any step, re-read `CLAUDE.md` to ensure the persona,
production standards, and interaction rules are active for this task.

Bring the current working branch to a shippable state. Clean the code,
verify analysis and tests pass, harden coverage, and produce a commit
message. Do not commit or push.

## Instructions

### Step 1 — Automated fixes

- Run `dart fix --apply`.
- Run `dart format .`.

### Step 2 — Static analysis

- Run `flutter analyze`.
- If there are any issues: fix them. Do not suppress warnings with `// ignore`
  unless the suppression was already present before this session. Every
  suppression requires an explanation comment.

### Step 3 — Test suite

- Run `flutter test`.
- If any tests fail: investigate and fix the **code**, not the test. Only
  modify a test if the test itself was wrong.
- Run `flutter test integration_test/app_test.dart` if the file exists.

### Step 4 — Code cleanup

Scan every modified file (`git diff --name-only`) and:

- Remove all `print()` and `debugPrint()` statements.
- Remove all unused imports.
- Remove all commented-out code blocks.
- Remove all `// TODO` and `// FIXME` introduced in this session that are
  not tracked issues.
- Replace any temporary workarounds with proper implementations, or leave
  a tracked `// TODO(username): #issue` comment.

### Step 5 — Coverage check

- For every modified file, verify its corresponding test file exists under
  `test/` mirroring the `lib/` structure.
- For any modified Notifier: confirm both success and failure paths are tested.
- For any modified repository: confirm exception-to-failure mapping is tested.
- Add missing tests. Do not inflate coverage with trivial assertions.

### Step 6 — Final verification

- Run `flutter analyze` again — must return zero issues.
- Run `flutter test` again — must return zero failures.

### Step 7 — Report

- Summarize what was cleaned (e.g., "Removed 2 print statements, fixed 1
  unused import, added 3 test cases").

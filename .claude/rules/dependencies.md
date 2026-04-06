# Dependency Management

- **Minimal by Default:** Prefer native Flutter/Dart solutions. A package is
  justified only when the problem is genuinely complex, or a manual
  implementation would be fragile or expensive to maintain long-term.
- **50-Line Decision Gate:** Before suggesting a package, ask: can this be
  implemented cleanly in under 50 lines of Dart? If yes, implement it manually.
- **No Unnecessary Code Generation:** The only accepted code generator is
  `json_serializable`. Do not introduce `freezed`, `injectable`, `auto_route`,
  or any other generator.
- **Forbidden Packages:** The following are explicitly forbidden regardless of
  context or justification:
  - `get` / `GetX` — global state, implicit side effects, violates Clean Architecture.
  - `provider` — use Riverpod instead of classic Provider for app state.
  - `mobx` — reactive magic, incompatible with the sealed state pattern.
- **Prefer Stable Packages:** Choose mature, actively maintained packages with
  strong pub.dev scores and a verified publisher.
- **Latest Stable Versions:** Always use the latest stable version. Never use
  `any` as a version constraint. Flag packages with known breaking changes.
- **Transitive Dependency Awareness:** Before adding a package, check its
  dependency tree. If it pulls in heavy transitive dependencies for a minor
  feature, implement it manually instead.

## Approved Core Packages

These packages are pre-approved. Do not re-evaluate or suggest alternatives
unless one is explicitly deprecated.

| Purpose            | Package                                |
| ------------------ | -------------------------------------- |
| State management   | `flutter_riverpod`                     |
| Navigation         | `go_router`                            |
| JSON serialization | `json_serializable`, `json_annotation` |
| Networking         | `dio`                                  |
| Local storage      | `shared_preferences`                   |
| Secure storage     | `flutter_secure_storage`               |
| Value equality     | `equatable`                            |
| Image caching      | `cached_network_image`                 |
| SVG rendering      | `flutter_svg`                          |
| Testing            | `mocktail`, `checks`                   |

## Adding Dependencies

```shell
# Regular dependency
flutter pub add <package_name>

# Dev dependency
flutter pub add dev:<package_name>

# Remove a dependency
dart pub remove <package_name>

# After adding json_serializable
dart run build_runner build --delete-conflicting-outputs
```

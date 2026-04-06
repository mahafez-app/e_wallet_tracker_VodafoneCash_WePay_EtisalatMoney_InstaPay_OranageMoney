# Data Handling & Serialization

* **Models are DTOs:** Data layer models are pure Data Transfer Objects. They
  handle serialization only. Domain entities are separate pure Dart classes.
  The two must never be merged.
* **Immutable Models:** All model and entity classes must be immutable —
  `final` fields and `const` constructors on both.
* **`json_serializable` for All JSON:** Use `json_serializable` and
  `json_annotation` for all JSON parsing. Never write `fromJson` / `toJson`
  manually.
* **Match the API Contract:** Apply `fieldRename` to match the API's naming
  convention. Use `@JsonKey(name: '...')` for individual field overrides.

```dart
// snake_case API — apply globally
@JsonSerializable(fieldRename: FieldRename.snake)

// camelCase API — no rename needed (Dart default matches)
@JsonSerializable()

// Single field override
@JsonKey(name: 'user_id')
final String id;
```

* **`toEntity()` for Simple Mappings:** Every DTO must implement `toEntity()`
  for straightforward one-to-one mappings. For complex transformations that
  combine data from multiple models, create a dedicated mapper class in
  `data/mappers/` instead.

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
final class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final String id;
  final String firstName;
  final String lastName;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() => User(id: id, firstName: firstName, lastName: lastName);
}
```

* **Nested Models:** Nested JSON objects must be their own `@JsonSerializable`
  model class. Never deserialize nested objects inline with manual casting.

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
final class OrderModel {
  const OrderModel({required this.id, required this.user});

  final String id;
  final UserModel user; // nested model — not Map<String, dynamic>

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Order toEntity() => Order(id: id, user: user.toEntity());
}
```

* **After Any Model Change:** Regenerate the generated files:

```shell
dart run build_runner build --delete-conflicting-outputs
```

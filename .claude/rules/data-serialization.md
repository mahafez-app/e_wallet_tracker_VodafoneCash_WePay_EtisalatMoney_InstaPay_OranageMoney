# Data Handling & Serialization

---

## Core Rule: Two Worlds, Zero Overlap

| Layer | Type | Purpose |
|-------|------|---------|
| Data | DTO / Model | Serialization, deserialization, `toEntity()` |
| Domain | Entity | Business logic, value equality, use cases |

DTOs and entities must **never** be merged. Entities contain zero serialization
logic. DTOs contain zero business logic.

All model and entity classes are immutable: `final` fields, `const`
constructors.

---

## REST / JSON DTOs (`json_serializable`)

Use `json_serializable` and `json_annotation` for all REST JSON parsing.
Never write `fromJson` / `toJson` manually.

```dart
// features/posts/data/models/post_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/post_entity.dart';
import 'author_model.dart';

part 'post_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
final class PostModel {
  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.publishedAt,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String body;
  final AuthorModel author;         // Nested models are their own @JsonSerializable
  final DateTime publishedAt;
  @JsonKey(name: 'cover_image')
  final String? imageUrl;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostEntity toEntity() => PostEntity(
    id: id,
    title: title,
    body: body,
    author: author.toEntity(),
    publishedAt: publishedAt,
    imageUrl: imageUrl,
  );
}
```

### API Naming Convention

```dart
// snake_case API — apply rename globally
@JsonSerializable(fieldRename: FieldRename.snake)

// camelCase API — Dart default, no rename needed
@JsonSerializable()

// Single field override (always explicit, even when rule already covers it)
@JsonKey(name: 'user_id')
final String id;
```

### Nested Models

Nested JSON objects must be their own `@JsonSerializable` class.
Never deserialize nested objects inline with `Map<String, dynamic>` casting.

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
final class AuthorModel {
  const AuthorModel({required this.id, required this.displayName});

  final String id;
  final String displayName;

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);

  AuthorEntity toEntity() => AuthorEntity(id: id, displayName: displayName);
}
```

### Build Runner

Run after any model change:

```shell
dart run build_runner build --delete-conflicting-outputs
```

---

## Firestore DTOs (manual — not `json_serializable`)

Firestore documents use `DocumentSnapshot`, not raw JSON. They contain Firestore
native types (`Timestamp`, `GeoPoint`, `DocumentReference`) that
`json_serializable` cannot handle.

**Rules for Firestore DTOs:**
- Do not use `json_serializable`. Write `fromFirestore` and `toFirestore`
  manually.
- The document `id` always comes from `DocumentSnapshot.id`, never from the
  document fields. Never store `id` as a Firestore field.
- Always convert `Timestamp` → `DateTime` via `.toDate()` in `fromFirestore`.
  Never let `Timestamp` leak into the domain layer.
- Always convert `DateTime` → `Timestamp` via `Timestamp.fromDate()` in
  `toFirestore`.
- `DocumentReference` fields must be resolved (fetched) in the data source,
  not the repository or use case.
- Always cast `doc.data()` explicitly to `Map<String, dynamic>`.
  Never leave it untyped.

```dart
// features/posts/data/models/post_firestore_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';

final class PostFirestoreModel {
  const PostFirestoreModel({
    required this.id,
    required this.title,
    required this.body,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.likesCount = 0,
  });

  final String id;
  final String title;
  final String body;
  final String authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final int likesCount;

  factory PostFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostFirestoreModel(
      id: doc.id,                                          // id from doc, not data
      title: data['title'] as String,
      body: data['body'] as String,
      authorId: data['author_id'] as String,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      imageUrl: data['image_url'] as String?,
      likesCount: (data['likes_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'body': body,
    'author_id': authorId,
    'created_at': Timestamp.fromDate(createdAt),
    'updated_at': Timestamp.fromDate(updatedAt),
    if (imageUrl != null) 'image_url': imageUrl,
    'likes_count': likesCount,
    // 'id' is intentionally excluded — stored as document ID only
  };

  PostEntity toEntity() => PostEntity(
    id: id,
    title: title,
    body: body,
    authorId: authorId,
    createdAt: createdAt,
    updatedAt: updatedAt,
    imageUrl: imageUrl,
    likesCount: likesCount,
  );
}
```

### Firestore QuerySnapshot to List

```dart
// In data source
Future<List<PostFirestoreModel>> getPosts() async {
  final snapshot = await _firestore.collection('posts').get();
  return snapshot.docs
      .map(PostFirestoreModel.fromFirestore)
      .toList();
}

Stream<List<PostFirestoreModel>> watchPosts() =>
    _firestore.collection('posts').snapshots().map(
      (snapshot) => snapshot.docs
          .map(PostFirestoreModel.fromFirestore)
          .toList(),
    );
```

---

## Firebase Auth User Model

`firebase_auth`'s `User` class is a Firebase type — it must not cross into
the domain. Wrap it in a model immediately after receipt.

```dart
// features/auth/data/models/user_model.dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_entity.dart';

final class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;

  factory UserModel.fromFirebaseUser(fb.User user) => UserModel(
    uid: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
    isEmailVerified: user.emailVerified,
  );

  UserEntity toEntity() => UserEntity(
    id: uid,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
    isEmailVerified: isEmailVerified,
  );
}
```

---

## Domain Entity (zero serialization)

```dart
// features/posts/domain/entities/post_entity.dart
import 'package:equatable/equatable.dart';

final class PostEntity extends Equatable {
  const PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.likesCount = 0,
  });

  final String id;
  final String title;
  final String body;
  final String authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final int likesCount;

  // Business-level helpers are allowed on entities
  bool get isRecent =>
      DateTime.now().difference(createdAt).inDays < 7;

  @override
  List<Object?> get props => [
    id, title, body, authorId, createdAt, updatedAt, imageUrl, likesCount,
  ];
}
```

---

## Mapper Classes (multi-model transforms)

Use a dedicated mapper class in `data/mappers/` when `toEntity()` is not
sufficient — i.e. when the entity requires data from multiple DTOs.

```dart
// features/posts/data/mappers/post_detail_mapper.dart
import '../models/post_firestore_model.dart';
import '../models/author_model.dart';
import '../../domain/entities/post_detail_entity.dart';

final class PostDetailMapper {
  const PostDetailMapper();

  PostDetailEntity map(PostFirestoreModel post, AuthorModel author) =>
      PostDetailEntity(
        id: post.id,
        title: post.title,
        body: post.body,
        author: author.toEntity(),
        createdAt: post.createdAt,
        imageUrl: post.imageUrl,
      );
}
```

---

## Type Safety Rules

```dart
// ❌ Untyped map access
final name = response['user']['name'];

// ✅ Explicit casts
final user = response['user'] as Map<String, dynamic>;
final name = user['name'] as String;

// ❌ Timestamp leaking into domain
final entity = PostEntity(createdAt: firestoreTimestamp); // forbidden

// ✅ Convert at DTO boundary
final entity = PostEntity(createdAt: (data['created_at'] as Timestamp).toDate());

// ❌ Firestore User in domain
UserEntity fromFirebaseUser(firebase_auth.User user) { ... } // in domain — forbidden

// ✅ Firebase User converted in data layer model only
factory UserModel.fromFirebaseUser(fb.User user) { ... }
```

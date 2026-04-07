# Dart Best Practices

Follow https://dart.dev/effective-dart in full. The rules below extend and
specialise it for this project.

---

## Null Safety & Type System

- **No `!` operator** unless the non-null value is structurally guaranteed by
  the type system at that exact point. Prefer `?`, `??`, early returns,
  `if`-null checks, or pattern matching. Every `!` in the codebase is a
  potential runtime crash.

  ```dart
  // ❌
  final name = user!.displayName!;

  // ✅
  final name = user?.displayName ?? 'Anonymous';
  ```

- **No `late`** unless the field is provably initialized before first read
  and cannot be assigned in the constructor or made nullable. `late` trades
  compile-time null safety for runtime `LateInitializationError`.

- **No `dynamic`.** Use generics, `Object?`, sealed types, or explicit casts.
  `dynamic` silently disables type checking on the entire expression tree.

- **No implicit `dynamic` in `Map` access.** Always cast explicitly.

  ```dart
  // ❌
  final name = response['user']['name'];

  // ✅
  final userData = response['user'] as Map<String, dynamic>;
  final name = userData['name'] as String;
  ```

- **Prefer `final class` and `interface class`** for types that must not be
  extended or implemented arbitrarily. Declare the intent explicitly.

  ```dart
  // Entity — value object, no extension
  final class UserEntity extends Equatable { ... }

  // Repository interface — implemented by data layer, not extended
  abstract interface class AuthRepository { ... }
  ```

- **Use `sealed class`** for exhaustive domain hierarchies (Result, Failure,
  state variants). The compiler enforces exhaustive `switch` over sealed types.

---

## Async

- **`async`/`await` only.** Never mix `.then()` chains with `await` in the
  same function. `.then()` is acceptable only in fire-and-forget callbacks
  where `async` context is unavailable.

  ```dart
  // ❌
  Future<User> getUser() {
    return _api.fetchUser().then((dto) => dto.toEntity());
  }

  // ✅
  Future<UserEntity> getUser() async {
    final dto = await _api.fetchUser();
    return dto.toEntity();
  }
  ```

- **No unawaited futures.** Never call an `async` function without `await`
  unless fire-and-forget is intentional and documented. Mark intentional
  cases with `unawaited()` from `dart:async`.

  ```dart
  // ❌ Silent unawaited Future
  _analytics.logEvent('login');

  // ✅ Explicit fire-and-forget
  unawaited(_analytics.logEvent('login'));
  ```

- **Streams for ongoing sequences only.** A value that completes once is
  always `Future`. A sequence of values over time is `Stream`. Never use
  `StreamController` to emit a single value.

- **Always cancel `StreamSubscription`.** Any `StreamSubscription` created
  outside of `StreamProvider` must be cancelled in `dispose` or `ref.onDispose`.

  ```dart
  // In a Notifier
  @override
  FutureOr<List<Message>> build() {
    final subscription = _stream.listen((event) { ... });
    ref.onDispose(subscription.cancel);
    return [];
  }
  ```

- **No `async` in `initState` directly.** Schedule async work with
  `Future.microtask` or call a separate method, and guard with `mounted`.

  ```dart
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      await _load();
    });
  }
  ```

---

## Patterns & Syntax

- **Exhaustive `switch` over sealed classes and enums.** Never use a
  `default` or wildcard `_` branch that silently swallows unhandled cases.
  Exhaustiveness is the entire value of sealed types.

  ```dart
  // ❌ Wildcard hides new Result subtypes at compile time
  return switch (result) {
    Success(:final data) => process(data),
    _ => handleFailure(),
  };

  // ✅ Exhaustive — compile error if new subtype added
  return switch (result) {
    Success(:final data)         => process(data),
    FailureResult(:final failure) => handleFailure(failure),
  };
  ```

- **Pattern matching and destructuring** to eliminate null checks and `is`
  cast chains.

  ```dart
  // ❌
  if (state is AsyncData && (state as AsyncData).value != null) {
    final user = (state as AsyncData<UserEntity?>).value!;
  }

  // ✅
  if (state case AsyncData(:final value?) when value != null) {
    // value is non-null UserEntity here
  }
  ```

- **Arrow `=>` for single expressions only.** Never use `=>` with multi-line
  ternaries, `switch` blocks, or chained calls that wrap across lines.

- **Records for lightweight multi-value returns.** Use when returning 2–3
  related values and a named class would be disproportionate. If the record
  shape is used in more than one place, define a named class.

  ```dart
  // Record — single local callsite
  (String token, DateTime expiry) _parseToken(String raw) { ... }

  // Named class — reused across features
  final class AuthToken {
    const AuthToken({required this.value, required this.expiry});
    final String value;
    final DateTime expiry;
  }
  ```

- **`extension` for cohesive type helpers.** Add behaviour to existing types
  when the helper is cohesive with that type and used in multiple places.
  One extension = one clear purpose.

  ```dart
  extension DateTimeFormatting on DateTime {
    String toDisplayDate() => '$day/$month/$year';
    bool get isToday {
      final now = DateTime.now();
      return year == now.year && month == now.month && day == now.day;
    }
  }
  ```

- **`typedef` for complex function signatures and callback types.**

  ```dart
  typedef OnRetry = void Function();
  typedef JsonMap = Map<String, dynamic>;
  ```

---

## Collections

- Prefer collection literals over constructors: `[]` over `List()`,
  `{}` over `Map()`, `{}` over `Set()`.
- Use spread operators `...` and collection `if`/`for` in literals to
  avoid intermediate list construction.

  ```dart
  // ❌
  final items = <Widget>[];
  items.add(const _Header());
  if (showBanner) items.add(const _Banner());
  items.addAll(list.map((e) => _Item(e)));

  // ✅
  final items = <Widget>[
    const _Header(),
    if (showBanner) const _Banner(),
    ...list.map(_Item.new),
  ];
  ```

- Never mutate a collection that was passed in as a parameter unless
  the caller explicitly documents mutation as part of the contract.

---

## Classes & Constructors

- Use `const` constructors on all immutable classes.
- Use named parameters (`{}`) over positional when a function or constructor
  has more than one parameter, or when parameter meaning is not obvious from
  context.
- Mark required named parameters with `required`. Never use a nullable
  default `= null` to avoid `required` on a parameter that always needs a
  value.
- Use `factory` constructors for named construction patterns, deserialization,
  and caching. Use `const` constructors for value types.

  ```dart
  // ❌ Nullable default masking a required param
  const UserEntity({String? id}) : id = id ?? '';

  // ✅ Required is clear at the callsite
  const UserEntity({required this.id});
  ```

---

## Equatable

- All immutable entities, state objects, params, and value types that need
  value equality must extend `Equatable`.
- Never hand-write `operator ==` or `hashCode` when `Equatable` fits.
- `props` must list every field that participates in equality. Omitting a
  field is a silent equality bug.

  ```dart
  final class LoginParams extends Equatable {
    const LoginParams({required this.email, required this.password});

    final String email;
    final String password;

    @override
    List<Object?> get props => [email, password];
  }
  ```

---

## Logging

- Use `dart:developer`'s `log()` for all debug and error output.
- Always provide a `name` argument for easy filtering.
- Never use `print`, `debugPrint`, or `developer.log` without `name`.

  ```dart
  import 'dart:developer';

  log(
    'Login failed: ${failure.technicalMessage}',
    name: 'AuthRepository.login',
    error: e,
    stackTrace: st,
  );
  ```

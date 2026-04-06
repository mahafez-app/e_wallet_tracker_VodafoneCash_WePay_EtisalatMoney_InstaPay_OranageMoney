# Dart Best Practices

Follow https://dart.dev/effective-dart in full. The rules below extend and
specialise it for this project.

## Null Safety & Type System

* **No `!` Operator:** Never use the null assertion operator unless the
  non-null value is structurally guaranteed by the type system at that exact
  point. Prefer `?`, `??`, early returns, or pattern matching.
* **No `late` Keyword:** Avoid `late` unless the field is genuinely initialized
  before first use and cannot be made nullable or assigned in the constructor.
  Overuse trades compile-time safety for runtime crashes.
* **No `dynamic`:** Never use `dynamic`. Use generics, `Object?`, or sealed
  types. `dynamic` silently disables type checking.
* **No Implicit `dynamic` in Maps:** Always cast explicitly when accessing
  values from `Map<String, dynamic>`. Never leave an access untyped.

```dart
// Wrong
final name = response['user']['name'];

// Correct
final name = (response['user'] as Map<String, dynamic>)['name'] as String;
```

## Async

* **`async`/`await` Only:** Never mix `.then()` chains with `await` in the
  same function. `await` is always preferred.
* **No Unawaited Futures:** Never call an `async` function without `await`
  unless fire-and-forget is intentional. Mark intentional cases with
  `unawaited()` from `dart:async`.
* **Streams for Sequences Only:** Use `Stream` for sequences of ongoing
  asynchronous events. A single value that completes once is always a `Future`.

## Patterns & Syntax

* **Exhaustive `switch` Expressions:** Use exhaustive `switch` over sealed
  classes and enums. Never use a `default` or wildcard `_` branch that
  silently swallows unhandled cases. Exhaustiveness is the entire value of
  sealed types.
* **Pattern Matching:** Use pattern matching and destructuring to eliminate
  null checks and `is` cast chains.
* **Arrow `=>` for Single Expressions Only:** Use `=>` only when the entire
  function body is a single expression. Never use with multi-line ternaries
  or `switch` expressions.
* **Records for Lightweight Multi-Value Returns:** Use records when a function
  returns 2–3 related values and a named class would be disproportionate.
  If the structure is used in more than one place, define a named class.

```dart
// Record — appropriate for a single local callsite
(String name, int age) _parseHeader(String raw) { ... }

// Named class — required when used across multiple callsites
class UserSummary { ... }
```

* **`extension` Methods for Cohesive Helpers:** Add behaviour to existing
  types when the helper is cohesive with that type and used in multiple places.
  Do not use extensions as a dumping ground — each extension has one purpose.

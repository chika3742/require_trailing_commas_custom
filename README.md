# require_trailing_commas_custom

A lint rule for [custom_lint](https://pub.dev/packages/custom_lint)

**The rule is simple.** If you opened parentheses intending to write multiline contents, it requires trailing commas. It's like `always-multiline`setting of `comma-dangle` rule in ESLint.

### ✅ Good
```dart
Foo(
  a: 1,
  b: 2,
);

Foo(Bar(
  a: 1,
  b: 2,
));

useEffect(() {
  // ...
}, []);
```

### ❌️ Bad
```dart
Foo(
  a: 1,
  b: 2 // <-
);

Foo(Bar(
  a: 1,
  b: 2 // <-
));

useEffect(
  () {
    // ...
  },
  [] // <-
);
```
Records are supported
```dart
final (String, String) foo = (
  "bar",
  "baz" // <-
);
```
Switch expressions are supported
```dart
final foo = switch (state) {
  State.success => 0,
  State.failure => 1 // <-
}
```

Enums are supported
```dart
enum FooState {
  bar,
  baz // <-
}

enum BarState {
  taro("taro"),
  hanako("hanako") // <-
  ;
  
  const BarState(this.name);

  final String name;
}
```

Of course, also have quick fixes.

## Installation

Add this package to the dependency. [custom_lint](https://pub.dev/packages/custom_lint) package is required to
use this lint rule.

```sh
dart pub add dev:require_trailing_commas_custom dev:custom_lint
# or
flutter pub add dev:require_trailing_commas_custom dev:custom_lint
```

`analysis_options.yaml`
```yaml
# ...
analyzer:
  plugins:
    - custom_lint
# ...
```

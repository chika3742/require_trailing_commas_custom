# require_trailing_commas_custom

lint rule for custom_lint

**The rule is simple.** If you opened parentheses intending to write multiline contents, it requires trailing commas.

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
Records supported
```dart
final (String, String) foo = (
  "bar",
  "baz" // <-
);
```
Switch expressions supported
```dart
final foo = switch (state) {
  State.success => 0,
  State.failure => 1 // <-
}
```

Enums supported
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

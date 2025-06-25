// ignore_for_file: unused_local_variable

void fn({String? arg1}) {}

// argument list
void main() {
  fn(
    arg1: "value"
    // expect_lint: require_trailing_commas_custom
  );
}

// assert initializer
class Test {
  const Test(String foo)
      : assert(
          foo == "bar",
          "foo must be 'bar'"
          // expect_lint: require_trailing_commas_custom
        );
}

// assert statement
void fn2() {
  final foo = "bar";
  assert(
    foo == "bar",
    "foo must be 'bar'"
    // expect_lint: require_trailing_commas_custom
  );
}

// formal parameter list
void fn3({
  String? foo,
  String? bar
  // expect_lint: require_trailing_commas_custom
}) {}
void fn4([
  String? foo,
  String? bar
  // expect_lint: require_trailing_commas_custom
]) {}
void fn5(
  String? foo,
  String? bar
  // expect_lint: require_trailing_commas_custom
) {}
void fn12(
  String? foo,
  String? bar, {
  String? baz
  // expect_lint: require_trailing_commas_custom
}) {}

// list literal
final list = [
  1,
  2
  // expect_lint: require_trailing_commas_custom
];

// set or map literal
final set = {
  1,
  2
  // expect_lint: require_trailing_commas_custom
};
final map = {
  1: "one",
  2: "two"
  // expect_lint: require_trailing_commas_custom
};

// record literal
final record1 = (
  1,
  2
  // expect_lint: require_trailing_commas_custom
);
final record2 = (
  one: 1,
  two: 2
  // expect_lint: require_trailing_commas_custom
);

// record pattern
void fn6 () {
  final (
    :name,
    :age
    // expect_lint: require_trailing_commas_custom
  ) = (name: "foo", age: 20);

  final (
    one,
    two
    // expect_lint: require_trailing_commas_custom
  ) = (1, 2);
}

// record type annotation
typedef recordType1 = (
  int,
  int
  // expect_lint: require_trailing_commas_custom
);
typedef recordType2 = ({
  String name,
  int age
  // expect_lint: require_trailing_commas_custom
});

// switch expression
enum State {
  success,
  failure,
}
void fn7() {
  final state = State.success;
  final foo = switch (state) {
    State.success => "success",
    State.failure => "failure"
    // expect_lint: require_trailing_commas_custom
  };
}

// flutter hooks exception
void fn8() {
  useEffect(
    () {},
    []);
  useEffect2(
    cb: () {},
    dependencies: [
      []
      // expect_lint: require_trailing_commas_custom
    ]
    // expect_lint: require_trailing_commas_custom
  );
}
void useEffect(void Function() cb, List<Object> dependencies) {}
void useEffect2({void Function()? cb, List<Object>? dependencies}) {}

// multiline exception
class Foo {
  final Object foo;
  Foo(this.foo);
}
class Bar {
  final String baz;
  Bar({required this.baz});
}
void fn9() {
  Foo(Bar(
    baz: "baz",
    // no errors are expected
  ));
  Foo(
    fn10()
    // expect_lint: require_trailing_commas_custom
  );
}
int fn10() => 10;

// enum
enum FooState {
  bar,
  baz
  // expect_lint: require_trailing_commas_custom
}
enum FooState2 {
  bar,
  baz
  // expect_lint: require_trailing_commas_custom
  ;
}

enum BarState {
  taro("taro"),
  hanako("hanako")
  // expect_lint: require_trailing_commas_custom
  ;

  const BarState(this.name);

  final String name;
}

import 'package:test/test.dart';

import 'package:dart_boilerplate/hello.dart';

void main() {
  test('hello', () {
    const name = 'bob';
    expect(hello(name), 'hello bob');
  });
}

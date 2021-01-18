import 'package:test/test.dart';

import 'package:libedax4dart/hello.dart';

void main() {
  test('hello', () {
    const name = 'bob';
    expect(hello(name), 'hello bob');
  });
}

import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  test('experimental test', () {
    LibEdax()
      ..initialize()
      ..terminate();
  });
}

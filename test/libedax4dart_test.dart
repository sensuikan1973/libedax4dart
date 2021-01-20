import 'package:libedax4dart/libedax.dart';
import 'package:test/test.dart';

void main() {
  test('initialize', () {
    final edax = LibEdax();
    print('ffi ok');
  });
}

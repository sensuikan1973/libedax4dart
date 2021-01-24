import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  test('popCount', () {
    const edax = LibEdax();
    expect(edax.popCount(7), 3); // 0000 0111
    expect(edax.popCount(14), 3); // 0000 1110
    expect(edax.popCount(15), 4); // 0000 1111
    expect(edax.popCount(17), 2); // 0001 0001
  });
}

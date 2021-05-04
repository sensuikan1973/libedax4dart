import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  group('symetryMove', () {
    test('0: same place', () {
      const moveC2 = 10;
      expect(symetryMove(moveC2, 0), moveC2);
    });

    test('1: horizontal flip', () {
      const moveC2 = 10;
      const moveF2 = 13;
      expect(symetryMove(moveC2, 1), moveF2);
    });

    test('2: vertical flip', () {
      const moveC2 = 10;
      const moveC7 = 50;
      expect(symetryMove(moveC2, 2), moveC7);
    });
  });
}

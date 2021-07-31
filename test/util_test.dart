import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  test('move2String', () {
    expect(move2String(0), 'a1');
    expect(move2String(25), 'b4');
    expect(move2String(63), 'h8');
  });

  test('score2String', () {
    expect(score2String(0), '0');
    expect(score2String(10), '+10');
    expect(score2String(-7), '-7');
  });

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

import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  group('symetryMoves', () {
    test('c2', () {
      const moveC2 = 10;
      final moveList = symetryMoves(moveC2);
      expect(moveList.map(move2String).toList(), containsAll(<String>['f2', 'c7', 'f7']));
    });

    test('f7', () {
      const moveF7 = 53;
      final moveList = symetryMoves(moveF7);
      expect(moveList.map(move2String).toList(), containsAll(<String>['c2', 'f2', 'c7']));
    });

    test('d3', () {
      const moveD3 = 19;
      final moveList = symetryMoves(moveD3);
      expect(moveList.map(move2String).toList(), containsAll(<String>['e3', 'd6', 'e6']));
    });

    test('h8', () {
      const moveH8 = 63;
      final moveList = symetryMoves(moveH8);
      expect(moveList.map(move2String).toList(), containsAll(<String>['a1', 'h1', 'a8']));
    });
  });
}

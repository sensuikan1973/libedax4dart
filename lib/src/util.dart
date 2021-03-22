import '../libedax4dart.dart';

/// Convert playerd square to human readable String.
///
///  e.g. `f5`
String move2String(int x) {
  if (x < 64) return _moveStringTable[x];
  if (x == 64) return MoveMark.passString;
  if (x == 65) return 'no move';
  return '';
}

const _moveStringTable = [
  'a1', 'b1', 'c1', 'd1', 'e1', 'f1', 'g1', 'h1', // 1
  'a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2', // 2
  'a3', 'b3', 'c3', 'd3', 'e3', 'f3', 'g3', 'h3', // 3
  'a4', 'b4', 'c4', 'd4', 'e4', 'f4', 'g4', 'h4', // 4
  'a5', 'b5', 'c5', 'd5', 'e5', 'f5', 'g5', 'h5', // 5
  'a6', 'b6', 'c6', 'd6', 'e6', 'f6', 'g6', 'h6', // 6
  'a7', 'b7', 'c7', 'd7', 'e7', 'f7', 'g7', 'h7', // 7
  'a8', 'b8', 'c8', 'd8', 'e8', 'f8', 'g8', 'h8', // 8
];

/// Convert score to String.
///
/// e.g. `+10`, `-7`, `0`
String score2String(int score) {
  if (score <= 0) return score.toString();
  return '+${score.toString()}';
}

/// Radix 16 String.
///
/// e.g. `0010387c38100000`.
String radix16Board(int bit) => bit.toRadixString(16).padLeft(16, '0');

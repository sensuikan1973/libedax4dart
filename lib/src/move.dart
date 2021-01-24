import 'package:meta/meta.dart';
import 'bindings/constants.dart';

@immutable
class Move {
  const Move(this.flipped, this.x, this.score, this.cost);

  /// player's bitboard.
  final int flipped;

  /// played square.
  final int x;

  final int score;

  final int cost;

  bool get isNoMove => x == MoveMark.noMove;

  bool get isPass => x == MoveMark.pass;
}

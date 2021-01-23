import 'package:meta/meta.dart';

@immutable
class Move {
  const Move(this.flipped, this.x, this.score, this.cost);

  /// player's bitboard.
  final int flipped;

  /// played square.
  final int x;

  final int score;

  final int cost;
}

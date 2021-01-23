import 'package:meta/meta.dart';

@immutable
class Move {
  const Move(this.flipped, this.x, this.score, this.cost);

  /// player's bitboard.
  final int flipped;

  /// opponent's bitboard.
  final int x;

  /// opponent's bitboard.
  final int score;

  /// opponent's bitboard.
  final int cost;
}

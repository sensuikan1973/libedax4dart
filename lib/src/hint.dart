import 'package:meta/meta.dart';
import 'util.dart';

@immutable
class Hint {
  const Hint(
    this.depth,
    this.selectivity,
    this.move,
    this.score,
    this.upper,
    this.lower,
    this.bookMove,
  );

  /// searched depth(except book moves).
  final int depth;

  /// searched selectivity(except book moves).
  final int selectivity;

  /// best move found.
  final int move;

  /// best score.
  final int score;

  /// upper score(except book moves).
  final int upper;

  /// lower score(except book moves).
  final int lower;

  /// book move origin.
  final int bookMove;

  bool get isBookMove => bookMove == 1;

  /// e.g. f5
  String get moveString => move2String(move);

  /// e.g. +10
  String get scoreString => score2String(move);
}

import 'package:meta/meta.dart';

import 'bindings/structs/hint.dart' as c_hint;

import 'constants.dart';
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

  /// initialize from C struct
  Hint.fromCStruct(final c_hint.Hint cHint)
      : depth = cHint.depth,
        selectivity = cHint.selectivity,
        move = cHint.move,
        score = cHint.score,
        upper = cHint.upper,
        lower = cHint.lower,
        bookMove = cHint.book_move;

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

  bool get isNoMove => move == MoveMark.noMove;

  bool get isPass => move == MoveMark.pass;

  /// e.g. `f5`
  String get moveString => move2String(move);

  /// e.g. `+10`
  String get scoreString => score2String(score);
}

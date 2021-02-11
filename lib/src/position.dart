import 'package:meta/meta.dart';

import 'board.dart';
import 'link.dart';
import 'score.dart';

@immutable
class Position {
  const Position(
    this.board,
    this.leaf,
    this.link,
    this.nWins,
    this.nDraws,
    this.nLosses,
    this.nLines,
    this.score,
    this.nLink,
    this.level,
    this.done,
    this.todo,
  );

  final Board board;

  /// best remaining move
  final Link leaf;

  /// linking moves
  final Link? link;

  /// game win count
  final int nWins;

  /// game draw count
  final int nDraws;

  /// game loss count
  final int nLosses;

  /// unterminated line count
  final int nLines;

  /// Position value & bounds
  final Score score;

  /// linking moves number
  final int nLink;

  /// search level
  final int level;

  /// done/undone flag
  final int done;

  /// todo flag
  final int todo;
}
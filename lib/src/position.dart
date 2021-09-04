import 'dart:ffi';

import 'package:meta/meta.dart';

import 'bindings/structs/position.dart' as c_position;
import 'board.dart';
import 'link.dart';
import 'score.dart';

@immutable
class Position {
  const Position(
    this.board,
    this.leaf,
    this.links,
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

  /// initialize from C struct
  Position.fromCStruct(final c_position.Position cPosition)
      : board = Board(cPosition.board[0].player, cPosition.board[0].opponent),
        leaf = Link(cPosition.leaf.score, cPosition.leaf.move),
        links = _linkesFromCStruct(cPosition),
        nWins = cPosition.n_wins,
        nDraws = cPosition.n_draws,
        nLosses = cPosition.n_losses,
        nLines = cPosition.n_lines,
        score = Score(cPosition.score.value, cPosition.score.lower, cPosition.score.upper),
        nLink = cPosition.n_link,
        level = cPosition.level,
        done = cPosition.done,
        todo = cPosition.todo;

  static List<Link> _linkesFromCStruct(final c_position.Position cPosition) {
    final links = <Link>[];
    for (var k = 0; k < cPosition.n_link; k++) {
      links.add(Link(cPosition.link.elementAt(k).ref.score, cPosition.link.elementAt(k).ref.move));
    }
    return links;
  }

  final Board board;

  /// best remaining move
  final Link leaf;

  /// linking moves
  final List<Link> links;

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

  /// best score links
  List<Link> get bestScoreLinks {
    if (links.isEmpty) return [];
    final linksSortedByScore = links..sort((final a, final b) => b.score.compareTo(a.score));
    final bestScore = linksSortedByScore.first.score;
    return linksSortedByScore.where((final element) => element.score == bestScore).toList();
  }
}

import 'dart:ffi';

import 'package:meta/meta.dart';

import 'board.dart';
import 'ffi/bindings.dart' as bindings;
import 'link.dart';
import 'score.dart';

/// dart representation of Position in libedax world.
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
    this.flag,
    this.nPlayerBestpaths,
    this.nOpponentBestpaths,
  );

  /// initialize from C struct
  Position.fromCStruct(final bindings.Position cPosition)
      : board = Board(cPosition.board[0].player, cPosition.board[0].opponent),
        leaf = Link(cPosition.leaf.score, cPosition.leaf.move),
        links = _linksFromCStruct(cPosition),
        nWins = cPosition.n_wins,
        nDraws = cPosition.n_draws,
        nLosses = cPosition.n_losses,
        nLines = cPosition.n_lines,
        score = Score(
          cPosition.score.value,
          cPosition.score.lower,
          cPosition.score.upper,
        ),
        nLink = cPosition.n_link,
        level = cPosition.level,
        flag = cPosition.flag,
        nPlayerBestpaths = cPosition.n_player_bestpaths,
        nOpponentBestpaths = cPosition.n_opponent_bestpaths;

  static List<Link> _linksFromCStruct(final bindings.Position cPosition) {
    final links = <Link>[];
    for (var k = 0; k < cPosition.n_link; k++) {
      links.add(
        Link(
          cPosition.link.elementAt(k).ref.score,
          cPosition.link.elementAt(k).ref.move,
        ),
      );
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
  final int flag;

  /// bestpath count of player
  final int nPlayerBestpaths;

  /// bestpath count of opponent
  final int nOpponentBestpaths;

  /// best score links
  List<Link> get bestScoreLinks {
    if (links.isEmpty) return [];
    final linksSortedByScore = links
      ..sort((final a, final b) => b.score.compareTo(a.score));
    final bestScore = linksSortedByScore.first.score;
    return linksSortedByScore
        .where((final element) => element.score == bestScore)
        .toList();
  }
}

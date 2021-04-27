import 'package:meta/meta.dart';

import 'link.dart';

@immutable
class BestPathListToWinWithLink {
  const BestPathListToWinWithLink(this.bestPathListOfCurrentPlayer, this.bestPathListOfOpponentPlayer, this.link);

  /// best path list to win for current player.
  ///
  /// this means that if you learn these pathes, you win to opposite best moves definitely.
  final List<String> bestPathListOfCurrentPlayer;

  /// best path list to win for opponent player.
  ///
  /// this means that if you learn these pathes, you win to opposite best moves definitely.
  final List<String> bestPathListOfOpponentPlayer;

  /// link.
  final Link link;
}

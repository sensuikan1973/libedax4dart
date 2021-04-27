import 'package:meta/meta.dart';

import 'link.dart';

@immutable
class BestPathNumToWinWithLink {
  const BestPathNumToWinWithLink(this.bestPathNumOfCurrentPlayer, this.bestPathNumOfOpponentPlayer, this.link);

  /// best path num to win for current player.
  ///
  /// this means that if you learn these pathes, you win to opposite best moves definitely.
  final int bestPathNumOfCurrentPlayer;

  /// best path num to win for opponent player.
  ///
  /// this means that if you learn these pathes, you win to opposite best moves definitely.
  final int bestPathNumOfOpponentPlayer;

  /// link.
  final Link link;
}

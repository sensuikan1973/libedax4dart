import 'package:meta/meta.dart';

import 'link.dart';

@immutable
class BestPathNumWithLink {
  const BestPathNumWithLink(this.bestPathNumOfCurrentPlayer, this.bestPathNumOfOpponentPlayer, this.link);

  /// best path num to win for current player.
  final int bestPathNumOfCurrentPlayer;

  /// best path num to win for opponent player.
  final int bestPathNumOfOpponentPlayer;

  /// link.
  final Link link;
}

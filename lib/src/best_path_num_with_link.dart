import 'package:meta/meta.dart';

import 'link.dart';

@immutable
class BestPathNumWithLink {
  const BestPathNumWithLink(this.bestPathNumOfBlack, this.bestPathNumOfWhite, this.link);

  /// best path num to win for current player.
  final int bestPathNumOfBlack;

  /// best path num to win for opponent player.
  final int bestPathNumOfWhite;

  /// link.
  final Link link;
}

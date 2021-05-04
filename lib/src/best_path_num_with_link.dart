import 'package:meta/meta.dart';

import 'link.dart';
import 'util.dart';

@immutable
class BestPathNumWithLink {
  const BestPathNumWithLink(this.bestPathNumOfBlack, this.bestPathNumOfWhite, this.link, this.move);

  /// best path num to win for current player.
  final int bestPathNumOfBlack;

  /// best path num to win for opponent player.
  final int bestPathNumOfWhite;

  /// link.
  final Link link;

  /// played square.
  final int move;

  /// e.g. `f5`
  String get moveString => move2String(move);
}

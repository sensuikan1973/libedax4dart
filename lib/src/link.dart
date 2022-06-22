import 'package:meta/meta.dart';

import 'util.dart';

/// dart representation of Link in libedax world.
@immutable
class Link {
  const Link(this.score, this.move);

  /// move score
  final int score;

  /// move coordinate
  final int move;

  /// e.g. `f5`
  String get moveString => move2String(move);

  /// e.g. `+10`
  String get scoreString => score2String(score);
}

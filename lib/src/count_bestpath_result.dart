import 'package:meta/meta.dart';

import 'board.dart';
import 'position.dart';

/// dart representation of CountBestpathResult in libedax world.
@immutable
class CountBestpathResult {
  const CountBestpathResult(
    this.board,
    this.position,
    this.playerColor,
  );

  final Board board;

  final Position position;

  final int playerColor;
}

import 'package:meta/meta.dart';

import 'board.dart';
import 'position.dart';

/// dart representation of CountBestpathResult in libedax world.
@immutable
class CountBestpathResult {
  const CountBestpathResult(
    this.board,
    this.position,
  );

  final Board board;

  final Position position;
}

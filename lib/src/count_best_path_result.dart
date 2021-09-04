import 'package:meta/meta.dart';

import 'board.dart';
import 'position.dart';

@immutable
class CountBestpathResult {
  const CountBestpathResult(
    this.board,
    this.position,
  );

  final Board board;

  final Position position;
}

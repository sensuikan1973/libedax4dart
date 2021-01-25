import 'package:meta/meta.dart';

import 'move.dart';
import 'position.dart';

@immutable
class MoveListWithPosition {
  const MoveListWithPosition(this.moveList, this.position);

  /// move list.
  final List<Move> moveList;

  /// position.
  final Position position;
}

import 'package:meta/meta.dart';

import 'move.dart';
import 'position.dart';

@immutable
class MoveListWithPosition {
  const MoveListWithPosition(this.moveList, this.position, this.symetry);

  /// move list.
  final List<Move> moveList;

  /// position.
  final Position position;

  /// Symetry of position.
  final int symetry;
}

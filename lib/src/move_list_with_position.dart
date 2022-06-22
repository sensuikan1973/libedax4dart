import 'package:meta/meta.dart';

import 'move.dart';
import 'position.dart';

/// dart representation of Set of MoveList and Position in libedax world.
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

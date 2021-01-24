import 'package:meta/meta.dart';

import 'move.dart';
import 'position.dart';

@immutable
class MoveListWithPosition {
  const MoveListWithPosition(this.moveList, this.position);

  /// player's bitboard.
  final List<Move> moveList;

  /// opponent's bitboard.
  final Position position;
}

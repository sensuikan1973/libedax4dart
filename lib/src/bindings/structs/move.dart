import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Move extends Struct {
  /// bitboard representation of flipped squares.
  @Uint64()
  external int flipped;

  /// played square.
  @Int32()
  external int x;

  @Int32()
  external int score;

  /// move cost.
  @Int32()
  external int cost;

  /// next move in a MoveList.
  external Pointer<Move> next;
}

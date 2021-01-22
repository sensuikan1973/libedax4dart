import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Move extends Struct {
  factory Move.allocate(
    int flipped,
    int x,
    int score,
    int cost,
    Pointer<Move> next,
  ) =>
      allocate<Move>().ref
        ..flipped = flipped
        ..x = x
        ..score = score
        ..cost = cost
        ..next = next;

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
  Pointer<Move>? next;
}

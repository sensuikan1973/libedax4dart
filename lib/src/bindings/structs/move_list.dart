// ignore_for_file: non_constant_identifier_names
// follow libedax naming

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'move.dart';

class MoveList extends Struct {
  factory MoveList.allocate(Pointer<Pointer<Move>> move, int n_moves) => allocate<MoveList>().ref
    ..move = move
    ..n_moves = n_moves;

  Pointer<Pointer<Move>>? move;

  @Int32()
  int? n_moves;
}

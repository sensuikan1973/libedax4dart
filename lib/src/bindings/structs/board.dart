import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Board extends Struct {
  factory Board.allocate(int player, int opponent) => allocate<Board>().ref
    ..player = player
    ..opponent = opponent;

  @Uint64()
  int? player;

  @Uint64()
  int? opponent;
}

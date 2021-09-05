import 'dart:ffi';

class Board extends Struct {
  @Uint64()
  external int player;

  @Uint64()
  external int opponent;
}

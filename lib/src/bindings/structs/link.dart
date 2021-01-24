import 'dart:ffi';

class Link extends Struct {
  /// move score
  @Uint8()
  external int score;

  /// move coordinate
  @Uint8()
  external int move;
}

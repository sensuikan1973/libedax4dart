// ignore_for_file: non_constant_identifier_names
// follow libedax naming

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'board.dart';

class Position extends Struct {
  factory Position.allocate(
    Pointer<Pointer<Board>> board,
    int n_wins,
    int n_draws,
    int n_losses,
    int n_lines,
    Pointer<Utf8> n_link,
    Pointer<Utf8> level,
    Pointer<Utf8> done,
    Pointer<Utf8> todo,
  ) =>
      allocate<Position>().ref
        ..board = board
        ..n_wins = n_wins
        ..n_draws = n_draws
        ..n_losses = n_losses
        ..n_lines = n_lines
        ..n_link = n_link
        ..level = level
        ..done = done
        ..todo = todo;

  /// (unique) board.
  Pointer<Pointer<Board>>? board;

  // TODO: implement
  // Pointer<Link> leaf;

  // TODO: implement
  // Link.ByReference leaf;

  @Int32()
  int? n_wins;

  @Int32()
  int? n_draws;

  @Int32()
  int? n_losses;

  @Int32()
  int? n_lines;

  Pointer<Utf8>? n_link;

  Pointer<Utf8>? level;

  Pointer<Utf8>? done;

  Pointer<Utf8>? todo;

  Pointer<Score>? score;
}

class Score extends Struct {
  factory Score.allocate(int value, int lower, int upper) => allocate<Score>().ref
    ..value = value
    ..lower = lower
    ..upper = upper;

  @Int16() // C short is 16 bit
  int? value;

  @Int16() // C short is 16 bit
  int? lower;

  @Int16() // C short is 16 bit
  int? upper;
}

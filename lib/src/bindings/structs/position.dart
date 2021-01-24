// ignore_for_file: non_constant_identifier_names
// follow libedax naming

import 'dart:ffi';
import 'board.dart';
import 'link.dart';

class Position extends Struct {
  external Board _unique_board_item_0;

  /// Helper for array `board`.
  ArrayHelper_Hint_board_level0 get board => ArrayHelper_Hint_board_level0(this, [1], 0, 0);

  /// best remaining move
  external Link leaf;

  // linking moves
  external Pointer<Link> link;

  /// game win count
  @Uint32()
  external int n_wins;

  /// game draw count
  @Uint32()
  external int n_draws;

  /// game loss count
  @Uint32()
  external int n_losses;

  /// unterminated line count
  @Uint32()
  external int n_lines;

  /// Position value & bounds
  external _Score score;

  /// linking moves number
  @Uint8()
  external int n_link;

  /// search level
  @Uint8()
  external int level;

  /// done/undone flag
  @Uint8()
  external int done;

  /// todo flag
  @Uint8()
  external int todo;
}

class _Score extends Struct {
  @Int16() // C short is 16 bit
  external int value;

  @Int16() // C short is 16 bit
  external int lower;

  @Int16() // C short is 16 bit
  external int upper;
}

/// Helper for array `board` in struct `Position`.
// ignore: camel_case_types
class ArrayHelper_Hint_board_level0 {
  final Position _struct;
  final List<int> dimensions;
  final int level;
  final int _absoluteIndex;
  int get length => dimensions[level];
  // ignore: sort_constructors_first
  ArrayHelper_Hint_board_level0(this._struct, this.dimensions, this.level, this._absoluteIndex);
  void _checkBounds(int index) {
    if (index >= length || index < 0) {
      throw RangeError('Dimension $level: index not in range 0..$length exclusive.');
    }
  }

  Board operator [](int index) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        return _struct._unique_board_item_0;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }

  void operator []=(int index, Board value) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        _struct._unique_board_item_0 = value;
        break;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }
}

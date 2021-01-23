import 'dart:ffi' as ffi;
import 'move.dart';

/// (simple) list of a legal moves
class MoveList extends ffi.Struct {
  external Move _unique_move_item_0;
  external Move _unique_move_item_1;
  external Move _unique_move_item_2;
  external Move _unique_move_item_3;
  external Move _unique_move_item_4;
  external Move _unique_move_item_5;
  external Move _unique_move_item_6;
  external Move _unique_move_item_7;
  external Move _unique_move_item_8;
  external Move _unique_move_item_9;
  external Move _unique_move_item_10;
  external Move _unique_move_item_11;
  external Move _unique_move_item_12;
  external Move _unique_move_item_13;
  external Move _unique_move_item_14;
  external Move _unique_move_item_15;
  external Move _unique_move_item_16;
  external Move _unique_move_item_17;
  external Move _unique_move_item_18;
  external Move _unique_move_item_19;
  external Move _unique_move_item_20;
  external Move _unique_move_item_21;
  external Move _unique_move_item_22;
  external Move _unique_move_item_23;
  external Move _unique_move_item_24;
  external Move _unique_move_item_25;
  external Move _unique_move_item_26;
  external Move _unique_move_item_27;
  external Move _unique_move_item_28;
  external Move _unique_move_item_29;
  external Move _unique_move_item_30;
  external Move _unique_move_item_31;
  external Move _unique_move_item_32;
  external Move _unique_move_item_33;

  /// Helper for array `move`.
  ArrayHelper_MoveList_move_level0 get move => ArrayHelper_MoveList_move_level0(this, [34], 0, 0);
  @ffi.Int32()
  external int n_moves;
}

/// Helper for array `move` in struct `MoveList`.
class ArrayHelper_MoveList_move_level0 {
  final MoveList _struct;
  final List<int> dimensions;
  final int level;
  final int _absoluteIndex;
  int get length => dimensions[level];
  ArrayHelper_MoveList_move_level0(this._struct, this.dimensions, this.level, this._absoluteIndex);
  void _checkBounds(int index) {
    if (index >= length || index < 0) {
      throw RangeError('Dimension $level: index not in range 0..${length} exclusive.');
    }
  }

  Move operator [](int index) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        return _struct._unique_move_item_0;
      case 1:
        return _struct._unique_move_item_1;
      case 2:
        return _struct._unique_move_item_2;
      case 3:
        return _struct._unique_move_item_3;
      case 4:
        return _struct._unique_move_item_4;
      case 5:
        return _struct._unique_move_item_5;
      case 6:
        return _struct._unique_move_item_6;
      case 7:
        return _struct._unique_move_item_7;
      case 8:
        return _struct._unique_move_item_8;
      case 9:
        return _struct._unique_move_item_9;
      case 10:
        return _struct._unique_move_item_10;
      case 11:
        return _struct._unique_move_item_11;
      case 12:
        return _struct._unique_move_item_12;
      case 13:
        return _struct._unique_move_item_13;
      case 14:
        return _struct._unique_move_item_14;
      case 15:
        return _struct._unique_move_item_15;
      case 16:
        return _struct._unique_move_item_16;
      case 17:
        return _struct._unique_move_item_17;
      case 18:
        return _struct._unique_move_item_18;
      case 19:
        return _struct._unique_move_item_19;
      case 20:
        return _struct._unique_move_item_20;
      case 21:
        return _struct._unique_move_item_21;
      case 22:
        return _struct._unique_move_item_22;
      case 23:
        return _struct._unique_move_item_23;
      case 24:
        return _struct._unique_move_item_24;
      case 25:
        return _struct._unique_move_item_25;
      case 26:
        return _struct._unique_move_item_26;
      case 27:
        return _struct._unique_move_item_27;
      case 28:
        return _struct._unique_move_item_28;
      case 29:
        return _struct._unique_move_item_29;
      case 30:
        return _struct._unique_move_item_30;
      case 31:
        return _struct._unique_move_item_31;
      case 32:
        return _struct._unique_move_item_32;
      case 33:
        return _struct._unique_move_item_33;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }

  void operator []=(int index, Move value) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        _struct._unique_move_item_0 = value;
        break;
      case 1:
        _struct._unique_move_item_1 = value;
        break;
      case 2:
        _struct._unique_move_item_2 = value;
        break;
      case 3:
        _struct._unique_move_item_3 = value;
        break;
      case 4:
        _struct._unique_move_item_4 = value;
        break;
      case 5:
        _struct._unique_move_item_5 = value;
        break;
      case 6:
        _struct._unique_move_item_6 = value;
        break;
      case 7:
        _struct._unique_move_item_7 = value;
        break;
      case 8:
        _struct._unique_move_item_8 = value;
        break;
      case 9:
        _struct._unique_move_item_9 = value;
        break;
      case 10:
        _struct._unique_move_item_10 = value;
        break;
      case 11:
        _struct._unique_move_item_11 = value;
        break;
      case 12:
        _struct._unique_move_item_12 = value;
        break;
      case 13:
        _struct._unique_move_item_13 = value;
        break;
      case 14:
        _struct._unique_move_item_14 = value;
        break;
      case 15:
        _struct._unique_move_item_15 = value;
        break;
      case 16:
        _struct._unique_move_item_16 = value;
        break;
      case 17:
        _struct._unique_move_item_17 = value;
        break;
      case 18:
        _struct._unique_move_item_18 = value;
        break;
      case 19:
        _struct._unique_move_item_19 = value;
        break;
      case 20:
        _struct._unique_move_item_20 = value;
        break;
      case 21:
        _struct._unique_move_item_21 = value;
        break;
      case 22:
        _struct._unique_move_item_22 = value;
        break;
      case 23:
        _struct._unique_move_item_23 = value;
        break;
      case 24:
        _struct._unique_move_item_24 = value;
        break;
      case 25:
        _struct._unique_move_item_25 = value;
        break;
      case 26:
        _struct._unique_move_item_26 = value;
        break;
      case 27:
        _struct._unique_move_item_27 = value;
        break;
      case 28:
        _struct._unique_move_item_28 = value;
        break;
      case 29:
        _struct._unique_move_item_29 = value;
        break;
      case 30:
        _struct._unique_move_item_30 = value;
        break;
      case 31:
        _struct._unique_move_item_31 = value;
        break;
      case 32:
        _struct._unique_move_item_32 = value;
        break;
      case 33:
        _struct._unique_move_item_33 = value;
        break;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }
}

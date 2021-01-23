import 'dart:ffi' as ffi;

import 'hint.dart';

/// Hint list (for libEdax)
///
/// @author lavox
/// @date 2018/1/17
class HintList extends ffi.Struct {
  external Hint _unique_hint_item_0;
  external Hint _unique_hint_item_1;
  external Hint _unique_hint_item_2;
  external Hint _unique_hint_item_3;
  external Hint _unique_hint_item_4;
  external Hint _unique_hint_item_5;
  external Hint _unique_hint_item_6;
  external Hint _unique_hint_item_7;
  external Hint _unique_hint_item_8;
  external Hint _unique_hint_item_9;
  external Hint _unique_hint_item_10;
  external Hint _unique_hint_item_11;
  external Hint _unique_hint_item_12;
  external Hint _unique_hint_item_13;
  external Hint _unique_hint_item_14;
  external Hint _unique_hint_item_15;
  external Hint _unique_hint_item_16;
  external Hint _unique_hint_item_17;
  external Hint _unique_hint_item_18;
  external Hint _unique_hint_item_19;
  external Hint _unique_hint_item_20;
  external Hint _unique_hint_item_21;
  external Hint _unique_hint_item_22;
  external Hint _unique_hint_item_23;
  external Hint _unique_hint_item_24;
  external Hint _unique_hint_item_25;
  external Hint _unique_hint_item_26;
  external Hint _unique_hint_item_27;
  external Hint _unique_hint_item_28;
  external Hint _unique_hint_item_29;
  external Hint _unique_hint_item_30;
  external Hint _unique_hint_item_31;
  external Hint _unique_hint_item_32;
  external Hint _unique_hint_item_33;

  /// Helper for array `hint`.
  ArrayHelper_HintList_hint_level0 get hint => ArrayHelper_HintList_hint_level0(this, [34], 0, 0);
  @ffi.Int32()
  external int n_hints;
}

/// Helper for array `hint` in struct `HintList`.
class ArrayHelper_HintList_hint_level0 {
  final HintList _struct;
  final List<int> dimensions;
  final int level;
  final int _absoluteIndex;
  int get length => dimensions[level];
  ArrayHelper_HintList_hint_level0(this._struct, this.dimensions, this.level, this._absoluteIndex);
  void _checkBounds(int index) {
    if (index >= length || index < 0) {
      throw RangeError('Dimension $level: index not in range 0..${length} exclusive.');
    }
  }

  Hint operator [](int index) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        return _struct._unique_hint_item_0;
      case 1:
        return _struct._unique_hint_item_1;
      case 2:
        return _struct._unique_hint_item_2;
      case 3:
        return _struct._unique_hint_item_3;
      case 4:
        return _struct._unique_hint_item_4;
      case 5:
        return _struct._unique_hint_item_5;
      case 6:
        return _struct._unique_hint_item_6;
      case 7:
        return _struct._unique_hint_item_7;
      case 8:
        return _struct._unique_hint_item_8;
      case 9:
        return _struct._unique_hint_item_9;
      case 10:
        return _struct._unique_hint_item_10;
      case 11:
        return _struct._unique_hint_item_11;
      case 12:
        return _struct._unique_hint_item_12;
      case 13:
        return _struct._unique_hint_item_13;
      case 14:
        return _struct._unique_hint_item_14;
      case 15:
        return _struct._unique_hint_item_15;
      case 16:
        return _struct._unique_hint_item_16;
      case 17:
        return _struct._unique_hint_item_17;
      case 18:
        return _struct._unique_hint_item_18;
      case 19:
        return _struct._unique_hint_item_19;
      case 20:
        return _struct._unique_hint_item_20;
      case 21:
        return _struct._unique_hint_item_21;
      case 22:
        return _struct._unique_hint_item_22;
      case 23:
        return _struct._unique_hint_item_23;
      case 24:
        return _struct._unique_hint_item_24;
      case 25:
        return _struct._unique_hint_item_25;
      case 26:
        return _struct._unique_hint_item_26;
      case 27:
        return _struct._unique_hint_item_27;
      case 28:
        return _struct._unique_hint_item_28;
      case 29:
        return _struct._unique_hint_item_29;
      case 30:
        return _struct._unique_hint_item_30;
      case 31:
        return _struct._unique_hint_item_31;
      case 32:
        return _struct._unique_hint_item_32;
      case 33:
        return _struct._unique_hint_item_33;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }

  void operator []=(int index, Hint value) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        _struct._unique_hint_item_0 = value;
        break;
      case 1:
        _struct._unique_hint_item_1 = value;
        break;
      case 2:
        _struct._unique_hint_item_2 = value;
        break;
      case 3:
        _struct._unique_hint_item_3 = value;
        break;
      case 4:
        _struct._unique_hint_item_4 = value;
        break;
      case 5:
        _struct._unique_hint_item_5 = value;
        break;
      case 6:
        _struct._unique_hint_item_6 = value;
        break;
      case 7:
        _struct._unique_hint_item_7 = value;
        break;
      case 8:
        _struct._unique_hint_item_8 = value;
        break;
      case 9:
        _struct._unique_hint_item_9 = value;
        break;
      case 10:
        _struct._unique_hint_item_10 = value;
        break;
      case 11:
        _struct._unique_hint_item_11 = value;
        break;
      case 12:
        _struct._unique_hint_item_12 = value;
        break;
      case 13:
        _struct._unique_hint_item_13 = value;
        break;
      case 14:
        _struct._unique_hint_item_14 = value;
        break;
      case 15:
        _struct._unique_hint_item_15 = value;
        break;
      case 16:
        _struct._unique_hint_item_16 = value;
        break;
      case 17:
        _struct._unique_hint_item_17 = value;
        break;
      case 18:
        _struct._unique_hint_item_18 = value;
        break;
      case 19:
        _struct._unique_hint_item_19 = value;
        break;
      case 20:
        _struct._unique_hint_item_20 = value;
        break;
      case 21:
        _struct._unique_hint_item_21 = value;
        break;
      case 22:
        _struct._unique_hint_item_22 = value;
        break;
      case 23:
        _struct._unique_hint_item_23 = value;
        break;
      case 24:
        _struct._unique_hint_item_24 = value;
        break;
      case 25:
        _struct._unique_hint_item_25 = value;
        break;
      case 26:
        _struct._unique_hint_item_26 = value;
        break;
      case 27:
        _struct._unique_hint_item_27 = value;
        break;
      case 28:
        _struct._unique_hint_item_28 = value;
        break;
      case 29:
        _struct._unique_hint_item_29 = value;
        break;
      case 30:
        _struct._unique_hint_item_30 = value;
        break;
      case 31:
        _struct._unique_hint_item_31 = value;
        break;
      case 32:
        _struct._unique_hint_item_32 = value;
        break;
      case 33:
        _struct._unique_hint_item_33 = value;
        break;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }
}

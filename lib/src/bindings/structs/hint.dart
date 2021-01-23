import 'dart:ffi' as ffi;

import 'line.dart';

/// Hint (for libEdax)
///
/// @author lavox
/// @date 2018/1/17
class Hint extends ffi.Struct {
  /// < searched depth(except book moves)
  @ffi.Int32()
  external int depth;

  /// < searched selectivity(except book moves)
  @ffi.Int32()
  external int selectivity;

  /// < best move found
  @ffi.Int32()
  external int move;

  /// < best score
  @ffi.Int32()
  external int score;

  /// < upper score(except book moves)
  @ffi.Int32()
  external int upper;

  /// < lower score(except book moves)
  @ffi.Int32()
  external int lower;

  external Line _unique_pv_item_0;

  /// Helper for array `pv`.
  ArrayHelper_Hint_pv_level0 get pv => ArrayHelper_Hint_pv_level0(this, [1], 0, 0);

  /// < searched time(except book moves)
  @ffi.Int64()
  external int time;

  /// < searched node count(except book moves)
  @ffi.Uint64()
  external int n_nodes;

  /// < book move origin
  @ffi.Int32()
  external int book_move;
}

/// Helper for array `pv` in struct `Hint`.
class ArrayHelper_Hint_pv_level0 {
  final Hint _struct;
  final List<int> dimensions;
  final int level;
  final int _absoluteIndex;
  int get length => dimensions[level];
  ArrayHelper_Hint_pv_level0(this._struct, this.dimensions, this.level, this._absoluteIndex);
  void _checkBounds(int index) {
    if (index >= length || index < 0) {
      throw RangeError('Dimension $level: index not in range 0..${length} exclusive.');
    }
  }

  Line operator [](int index) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        return _struct._unique_pv_item_0;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }

  void operator []=(int index, Line value) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        _struct._unique_pv_item_0 = value;
        break;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }
}

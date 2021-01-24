import 'dart:ffi' as ffi;

/// (simple) sequence of a legal moves
class Line extends ffi.Struct {
  @ffi.Int8()
  external int _unique_move_item_0;
  @ffi.Int8()
  external int _unique_move_item_1;
  @ffi.Int8()
  external int _unique_move_item_2;
  @ffi.Int8()
  external int _unique_move_item_3;
  @ffi.Int8()
  external int _unique_move_item_4;
  @ffi.Int8()
  external int _unique_move_item_5;
  @ffi.Int8()
  external int _unique_move_item_6;
  @ffi.Int8()
  external int _unique_move_item_7;
  @ffi.Int8()
  external int _unique_move_item_8;
  @ffi.Int8()
  external int _unique_move_item_9;
  @ffi.Int8()
  external int _unique_move_item_10;
  @ffi.Int8()
  external int _unique_move_item_11;
  @ffi.Int8()
  external int _unique_move_item_12;
  @ffi.Int8()
  external int _unique_move_item_13;
  @ffi.Int8()
  external int _unique_move_item_14;
  @ffi.Int8()
  external int _unique_move_item_15;
  @ffi.Int8()
  external int _unique_move_item_16;
  @ffi.Int8()
  external int _unique_move_item_17;
  @ffi.Int8()
  external int _unique_move_item_18;
  @ffi.Int8()
  external int _unique_move_item_19;
  @ffi.Int8()
  external int _unique_move_item_20;
  @ffi.Int8()
  external int _unique_move_item_21;
  @ffi.Int8()
  external int _unique_move_item_22;
  @ffi.Int8()
  external int _unique_move_item_23;
  @ffi.Int8()
  external int _unique_move_item_24;
  @ffi.Int8()
  external int _unique_move_item_25;
  @ffi.Int8()
  external int _unique_move_item_26;
  @ffi.Int8()
  external int _unique_move_item_27;
  @ffi.Int8()
  external int _unique_move_item_28;
  @ffi.Int8()
  external int _unique_move_item_29;
  @ffi.Int8()
  external int _unique_move_item_30;
  @ffi.Int8()
  external int _unique_move_item_31;
  @ffi.Int8()
  external int _unique_move_item_32;
  @ffi.Int8()
  external int _unique_move_item_33;
  @ffi.Int8()
  external int _unique_move_item_34;
  @ffi.Int8()
  external int _unique_move_item_35;
  @ffi.Int8()
  external int _unique_move_item_36;
  @ffi.Int8()
  external int _unique_move_item_37;
  @ffi.Int8()
  external int _unique_move_item_38;
  @ffi.Int8()
  external int _unique_move_item_39;
  @ffi.Int8()
  external int _unique_move_item_40;
  @ffi.Int8()
  external int _unique_move_item_41;
  @ffi.Int8()
  external int _unique_move_item_42;
  @ffi.Int8()
  external int _unique_move_item_43;
  @ffi.Int8()
  external int _unique_move_item_44;
  @ffi.Int8()
  external int _unique_move_item_45;
  @ffi.Int8()
  external int _unique_move_item_46;
  @ffi.Int8()
  external int _unique_move_item_47;
  @ffi.Int8()
  external int _unique_move_item_48;
  @ffi.Int8()
  external int _unique_move_item_49;
  @ffi.Int8()
  external int _unique_move_item_50;
  @ffi.Int8()
  external int _unique_move_item_51;
  @ffi.Int8()
  external int _unique_move_item_52;
  @ffi.Int8()
  external int _unique_move_item_53;
  @ffi.Int8()
  external int _unique_move_item_54;
  @ffi.Int8()
  external int _unique_move_item_55;
  @ffi.Int8()
  external int _unique_move_item_56;
  @ffi.Int8()
  external int _unique_move_item_57;
  @ffi.Int8()
  external int _unique_move_item_58;
  @ffi.Int8()
  external int _unique_move_item_59;
  @ffi.Int8()
  external int _unique_move_item_60;
  @ffi.Int8()
  external int _unique_move_item_61;
  @ffi.Int8()
  external int _unique_move_item_62;
  @ffi.Int8()
  external int _unique_move_item_63;
  @ffi.Int8()
  external int _unique_move_item_64;
  @ffi.Int8()
  external int _unique_move_item_65;
  @ffi.Int8()
  external int _unique_move_item_66;
  @ffi.Int8()
  external int _unique_move_item_67;
  @ffi.Int8()
  external int _unique_move_item_68;
  @ffi.Int8()
  external int _unique_move_item_69;
  @ffi.Int8()
  external int _unique_move_item_70;
  @ffi.Int8()
  external int _unique_move_item_71;
  @ffi.Int8()
  external int _unique_move_item_72;
  @ffi.Int8()
  external int _unique_move_item_73;
  @ffi.Int8()
  external int _unique_move_item_74;
  @ffi.Int8()
  external int _unique_move_item_75;
  @ffi.Int8()
  external int _unique_move_item_76;
  @ffi.Int8()
  external int _unique_move_item_77;
  @ffi.Int8()
  external int _unique_move_item_78;
  @ffi.Int8()
  external int _unique_move_item_79;

  /// Helper for array `move`.
  ArrayHelper_Line_move_level0 get move => ArrayHelper_Line_move_level0(this, [80], 0, 0);
  @ffi.Int32()
  external int n_moves;

  @ffi.Int32()
  external int color;
}

/// Helper for array `move` in struct `Line`.
class ArrayHelper_Line_move_level0 {
  final Line _struct;
  final List<int> dimensions;
  final int level;
  final int _absoluteIndex;
  int get length => dimensions[level];
  ArrayHelper_Line_move_level0(this._struct, this.dimensions, this.level, this._absoluteIndex);
  void _checkBounds(int index) {
    if (index >= length || index < 0) {
      throw RangeError('Dimension $level: index not in range 0..${length} exclusive.');
    }
  }

  int operator [](int index) {
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
      case 34:
        return _struct._unique_move_item_34;
      case 35:
        return _struct._unique_move_item_35;
      case 36:
        return _struct._unique_move_item_36;
      case 37:
        return _struct._unique_move_item_37;
      case 38:
        return _struct._unique_move_item_38;
      case 39:
        return _struct._unique_move_item_39;
      case 40:
        return _struct._unique_move_item_40;
      case 41:
        return _struct._unique_move_item_41;
      case 42:
        return _struct._unique_move_item_42;
      case 43:
        return _struct._unique_move_item_43;
      case 44:
        return _struct._unique_move_item_44;
      case 45:
        return _struct._unique_move_item_45;
      case 46:
        return _struct._unique_move_item_46;
      case 47:
        return _struct._unique_move_item_47;
      case 48:
        return _struct._unique_move_item_48;
      case 49:
        return _struct._unique_move_item_49;
      case 50:
        return _struct._unique_move_item_50;
      case 51:
        return _struct._unique_move_item_51;
      case 52:
        return _struct._unique_move_item_52;
      case 53:
        return _struct._unique_move_item_53;
      case 54:
        return _struct._unique_move_item_54;
      case 55:
        return _struct._unique_move_item_55;
      case 56:
        return _struct._unique_move_item_56;
      case 57:
        return _struct._unique_move_item_57;
      case 58:
        return _struct._unique_move_item_58;
      case 59:
        return _struct._unique_move_item_59;
      case 60:
        return _struct._unique_move_item_60;
      case 61:
        return _struct._unique_move_item_61;
      case 62:
        return _struct._unique_move_item_62;
      case 63:
        return _struct._unique_move_item_63;
      case 64:
        return _struct._unique_move_item_64;
      case 65:
        return _struct._unique_move_item_65;
      case 66:
        return _struct._unique_move_item_66;
      case 67:
        return _struct._unique_move_item_67;
      case 68:
        return _struct._unique_move_item_68;
      case 69:
        return _struct._unique_move_item_69;
      case 70:
        return _struct._unique_move_item_70;
      case 71:
        return _struct._unique_move_item_71;
      case 72:
        return _struct._unique_move_item_72;
      case 73:
        return _struct._unique_move_item_73;
      case 74:
        return _struct._unique_move_item_74;
      case 75:
        return _struct._unique_move_item_75;
      case 76:
        return _struct._unique_move_item_76;
      case 77:
        return _struct._unique_move_item_77;
      case 78:
        return _struct._unique_move_item_78;
      case 79:
        return _struct._unique_move_item_79;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }

  void operator []=(int index, int value) {
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
      case 34:
        _struct._unique_move_item_34 = value;
        break;
      case 35:
        _struct._unique_move_item_35 = value;
        break;
      case 36:
        _struct._unique_move_item_36 = value;
        break;
      case 37:
        _struct._unique_move_item_37 = value;
        break;
      case 38:
        _struct._unique_move_item_38 = value;
        break;
      case 39:
        _struct._unique_move_item_39 = value;
        break;
      case 40:
        _struct._unique_move_item_40 = value;
        break;
      case 41:
        _struct._unique_move_item_41 = value;
        break;
      case 42:
        _struct._unique_move_item_42 = value;
        break;
      case 43:
        _struct._unique_move_item_43 = value;
        break;
      case 44:
        _struct._unique_move_item_44 = value;
        break;
      case 45:
        _struct._unique_move_item_45 = value;
        break;
      case 46:
        _struct._unique_move_item_46 = value;
        break;
      case 47:
        _struct._unique_move_item_47 = value;
        break;
      case 48:
        _struct._unique_move_item_48 = value;
        break;
      case 49:
        _struct._unique_move_item_49 = value;
        break;
      case 50:
        _struct._unique_move_item_50 = value;
        break;
      case 51:
        _struct._unique_move_item_51 = value;
        break;
      case 52:
        _struct._unique_move_item_52 = value;
        break;
      case 53:
        _struct._unique_move_item_53 = value;
        break;
      case 54:
        _struct._unique_move_item_54 = value;
        break;
      case 55:
        _struct._unique_move_item_55 = value;
        break;
      case 56:
        _struct._unique_move_item_56 = value;
        break;
      case 57:
        _struct._unique_move_item_57 = value;
        break;
      case 58:
        _struct._unique_move_item_58 = value;
        break;
      case 59:
        _struct._unique_move_item_59 = value;
        break;
      case 60:
        _struct._unique_move_item_60 = value;
        break;
      case 61:
        _struct._unique_move_item_61 = value;
        break;
      case 62:
        _struct._unique_move_item_62 = value;
        break;
      case 63:
        _struct._unique_move_item_63 = value;
        break;
      case 64:
        _struct._unique_move_item_64 = value;
        break;
      case 65:
        _struct._unique_move_item_65 = value;
        break;
      case 66:
        _struct._unique_move_item_66 = value;
        break;
      case 67:
        _struct._unique_move_item_67 = value;
        break;
      case 68:
        _struct._unique_move_item_68 = value;
        break;
      case 69:
        _struct._unique_move_item_69 = value;
        break;
      case 70:
        _struct._unique_move_item_70 = value;
        break;
      case 71:
        _struct._unique_move_item_71 = value;
        break;
      case 72:
        _struct._unique_move_item_72 = value;
        break;
      case 73:
        _struct._unique_move_item_73 = value;
        break;
      case 74:
        _struct._unique_move_item_74 = value;
        break;
      case 75:
        _struct._unique_move_item_75 = value;
        break;
      case 76:
        _struct._unique_move_item_76 = value;
        break;
      case 77:
        _struct._unique_move_item_77 = value;
        break;
      case 78:
        _struct._unique_move_item_78 = value;
        break;
      case 79:
        _struct._unique_move_item_79 = value;
        break;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }
}

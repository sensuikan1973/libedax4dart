import 'package:meta/meta.dart';

import 'constants.dart';
import 'ffi/bindings.dart' as bindings;
import 'util.dart';

/// dart representation of Board in libedax world,
@immutable
class Board {
  const Board(this.player, this.opponent);

  /// initialize from C struct
  Board.fromCStruct(final bindings.Board cBoard)
    : player = cBoard.player,
      opponent = cBoard.opponent;

  /// player's bitboard.
  final int player;

  /// opponent's bitboard.
  final int opponent;

  /// square list of player's bitboard.
  List<int> get squaresOfPlayer => _squares(player);

  /// square String list of player's bitboard.
  List<String> get squareStringsOfPlayer =>
      _squares(player).map(move2String).toList();

  /// square list of opponent's bitboard.
  List<int> get squaresOfOpponent => _squares(opponent);

  /// square String list of opponent's bitboard.
  List<String> get squareStringsOfOpponent =>
      _squares(opponent).map(move2String).toList();

  List<int> _squares(final int bitboard) {
    final result = <int>[];
    final target = BigInt.from(bitboard).toUnsigned(bindings.BOARD_SIZE);
    var mask = BigInt.from(0x8000000000000000).toUnsigned(bindings.BOARD_SIZE);
    var i = 1;
    while (i <= bindings.BOARD_SIZE) {
      if ((mask & target) == mask) {
        result.add(bindings.BOARD_SIZE - i);
      } // NOTE: head of edax bitboard is "h8".
      mask = mask >> 1;
      i++;
    }
    return result..sort(); // ensure sorted list.
  }

  /// Radix 16 String.
  ///
  /// e.g. `0010387c38100000`.
  String get playerRadix16String => radix16Board(player);

  /// Radix 16 String.
  ///
  /// e.g. `0010387c38100000`.
  String get opponentRadix16String => radix16Board(opponent);

  /// get string applicable to `edaxSetboard` command.
  ///
  /// e.g. `-------------------*-------**O----**O*-----O--------------------W`.
  String stringApplicableToSetboard(final int currentColor) {
    final pStone = currentColor == TurnColor.black
        ? ColorChar.black
        : ColorChar.white;
    final oStone = currentColor == TurnColor.black
        ? ColorChar.white
        : ColorChar.black;

    final buffer = StringBuffer();
    for (var k = 0; k < 8; k++) {
      for (var j = 0; j < 8; j++) {
        final mask = 1 << (j + 8 * k);
        if ((player & mask) != 0) {
          buffer.write(pStone);
        } else if ((opponent & mask) != 0) {
          buffer.write(oStone);
        } else {
          buffer.write(ColorChar.empty);
        }
      }
    }
    buffer.write(currentColor == TurnColor.black ? 'B' : 'W');
    return buffer.toString();
  }

  /// get human readable board.
  ///
  /// example
  /// ```txt
  ///   A B C D E F G H
  /// 1 - - - - - - - - 1
  /// 2 - - - - - - - - 2
  /// 3 - - - - * - - - 3
  /// 4 - - - * * * - - 4
  /// 5 - - * * * * * - 5
  /// 6 - - - * * * - - 6
  /// 7 - - - - * - - - 7
  /// 8 - - - - - - - - 8
  ///   A B C D E F G H
  /// ```
  String prettyString(final int currentColor) {
    final pStone = currentColor == TurnColor.black
        ? ColorChar.black
        : ColorChar.white;
    final oStone = currentColor == TurnColor.black
        ? ColorChar.white
        : ColorChar.black;

    final buffer = StringBuffer()..writeln('  A B C D E F G H');
    for (var k = 0; k < 8; k++) {
      buffer.write('${k + 1} ');
      for (var j = 0; j < 8; j++) {
        final mask = 1 << (j + 8 * k);
        if ((player & mask) != 0) {
          buffer.write(pStone);
        } else if ((opponent & mask) != 0) {
          buffer.write(oStone);
        } else {
          buffer.write(ColorChar.empty);
        }
        buffer.write(' ');
      }
      buffer.writeln(k + 1);
    }
    buffer.writeln('  A B C D E F G H');
    return buffer.toString();
  }
}

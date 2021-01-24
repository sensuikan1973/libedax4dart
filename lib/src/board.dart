import 'package:meta/meta.dart';

import 'constants.dart';
import 'util.dart';

@immutable
class Board {
  const Board(this.player, this.opponent);

  /// player's bitboard.
  final int player;

  /// opponent's bitboard.
  final int opponent;

  /// Radix 16 String.
  ///
  /// e.g. `0010387c38100000`.
  String get playerRadix16String => radix16Board(player);

  /// Radix 16 String.
  ///
  /// e.g. `0010387c38100000`.
  String get opponentRadix16String => radix16Board(opponent);

  /// get human readable board.
  ///
  /// example
  ///
  ///   A B C D E F G H <br>
  /// 1 - - - - - - - - 1 <br>
  /// 2 - - - - - - - - 2 <br>
  /// 3 - - - - * - - - 3 <br>
  /// 4 - - - * * * - - 4 <br>
  /// 5 - - * * * * * - 5 <br>
  /// 6 - - - * * * - - 6 <br>
  /// 7 - - - - * - - - 7 <br>
  /// 8 - - - - - - - - 8 <br>
  ///   A B C D E F G H
  String prettyString(int currentColor) {
    final pStone = currentColor == TurnColor.black ? '*' : 'O';
    final oStone = currentColor == TurnColor.black ? 'O' : '*';

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
          buffer.write('-');
        }
        buffer.write(' ');
      }
      buffer.writeln(k + 1);
    }
    buffer.writeln('  A B C D E F G H');
    return buffer.toString();
  }
}

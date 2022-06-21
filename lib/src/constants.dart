import 'ffi/bindings.dart' as bindings;

const boardSize = bindings.BOARD_SIZE;

class TurnColor {
  /// BLACK turn.
  static const black = bindings.BLACK;

  /// WHITE turn.
  static const white = bindings.WHITE;
}

/// See: https://github.com/abulmo/edax-reversi/blob/1ae7c9fe5322ac01975f1b3196e788b0d25c1e10/src/board.c#L144-L200
class ColorChar {
  /// BLACK char. You can use this for `LibEdax.edaxSetboard`.
  static const black = '*';

  /// WHITE char. You can use this for `LibEdax.edaxSetboard`.
  static const white = 'O';

  /// EMPTY char.
  static const empty = '-';
}

class MoveMark {
  /// PASS string of BLACK.
  ///
  /// See: https://github.com/abulmo/edax-reversi/blob/1ae7c9fe5322ac01975f1b3196e788b0d25c1e10/src/move.c#L76
  static const passStringOfBlack = 'PA';

  /// PASS string of WHITE.
  ///
  /// See: https://github.com/abulmo/edax-reversi/blob/1ae7c9fe5322ac01975f1b3196e788b0d25c1e10/src/move.c#L76
  static const passStringOfWhite = 'pa';

  /// PASS move.
  static const pass = bindings.PASS;

  /// No move.
  static const noMove = bindings.NOMOVE;
}

/// `LowerLimit` constants for `edaxBookCountBoardBestpath`.
class BookCountBoardBestPathLowerLimit {
  /// only best moves.
  static const best = bindings.BESTPATH_BEST;
}

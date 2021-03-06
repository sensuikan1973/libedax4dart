class TurnColor {
  /// BLACK turn.
  static const black = 0;

  /// WHITE turn.
  static const white = 1;
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
  static const pass = 64;

  /// No move.
  static const noMove = 65;
}

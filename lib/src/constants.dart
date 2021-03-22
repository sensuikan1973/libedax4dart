class TurnColor {
  /// BLACK turn.
  static const black = 0;

  /// WHITE turn.
  static const white = 1;
}

class MoveMark {
  /// PASS string.
  ///
  /// NOTE: edaxGetMoves() can contain passString upper case `PA`.
  static const passString = 'pa';

  /// PASS move.
  static const pass = 64;

  /// No move.
  static const noMove = 65;
}

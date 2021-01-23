import 'package:meta/meta.dart';

@immutable
class Board {
  const Board(this.player, this.opponent);

  /// player's bitboard.
  final int player;

  /// opponent's bitboard.
  final int opponent;

  // print human redable board.
  void show() => ''; // TODO: implement
}

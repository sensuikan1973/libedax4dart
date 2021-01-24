import 'package:meta/meta.dart';

@immutable
class Link {
  const Link(this.score, this.move);

  /// move score
  final int score;

  /// move coordinate
  final int move;
}

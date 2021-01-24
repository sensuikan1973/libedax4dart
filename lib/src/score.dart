import 'package:meta/meta.dart';

@immutable
class Score {
  const Score(this.value, this.lower, this.upper);

  final int value;

  final int lower;

  final int upper;
}

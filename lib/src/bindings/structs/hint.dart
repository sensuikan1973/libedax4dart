import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Hint extends Struct {
  factory Hint.allocate() => allocate<Hint>().ref;

  List<int> get selectivityTable => [73, 87, 95, 98, 99, 100];
}

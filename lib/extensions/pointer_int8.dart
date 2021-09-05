// See: https://github.com/dart-lang/ffigen/issues/72

import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension Int8PointerString on Pointer<Int8> {
  String toStr() => cast<Utf8>().toDartString();
}

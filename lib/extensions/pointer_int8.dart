// See: https://github.com/dart-lang/ffigen/issues/72

import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension Int8PointerString on Pointer<Int8> {
  // See: https://pub.dev/packages/ffigen#how-does-ffigen-handle-c-strings
  String toStr() => cast<Utf8>().toDartString();
}

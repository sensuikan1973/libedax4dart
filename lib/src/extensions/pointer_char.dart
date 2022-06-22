// See: https://github.com/dart-lang/ffigen/issues/72

import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension CharPointerString on Pointer<Char> {
  // See: https://pub.dev/packages/ffigen#how-does-ffigen-handle-c-strings
  String toDartStr() => cast<Utf8>().toDartString();
}

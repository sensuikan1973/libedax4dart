// See: https://github.com/dart-lang/ffigen/issues/72

import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension Int8Pointer on String {
  Pointer<Int8> toInt8Pointer() => toNativeUtf8().cast<Int8>();
}

// See: https://github.com/dart-lang/ffigen/issues/72

import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension CharPointer on String {
  Pointer<Char> toCharPointer(Allocator allocator) =>
      toNativeUtf8(allocator: allocator).cast<Char>();
}

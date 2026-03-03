// See: https://github.com/dart-lang/ffigen/issues/72

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

extension CharPointer on String {
  Pointer<Char> toCharPointer(Allocator allocator) {
    if (Platform.isWindows) {
      final bytes = systemEncoding.encode(this);
      final pointer = allocator<Uint8>(bytes.length + 1);
      final buffer = pointer.asTypedList(bytes.length + 1);
      buffer.setAll(0, bytes);
      buffer[bytes.length] = 0;
      return pointer.cast<Char>();
    }

    return toNativeUtf8(allocator: allocator).cast<Char>();
  }
}

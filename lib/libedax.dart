import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'src/bindings/bindings.dart';

class LibEdax {
  LibEdax() {
    // experimental code to confirm FFI implementation
    final argv = allocate<Pointer<Utf8>>();
    bindings.initialize(0, argv);
    free(argv);
  }
}

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'bindings/bindings.dart';

class LibEdax {
  LibEdax();

  void initialize() {
    final argv = allocate<Pointer<Utf8>>();
    bindings.initialize(0, argv);
    free(argv);
  }

  void terminate() => bindings.terminate();
}

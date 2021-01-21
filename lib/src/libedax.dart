import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'bindings/bindings.dart';

@immutable
class LibEdax {
  const LibEdax();

  void initialize() {
    final argv = allocate<Pointer<Utf8>>();
    bindings.initialize(0, argv);
    free(argv);
  }

  void terminate() => bindings.terminate();
}

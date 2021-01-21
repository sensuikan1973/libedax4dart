import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'bindings/bindings.dart';

@immutable
class LibEdax {
  const LibEdax();

  /// Initialize libedax.
  ///
  /// TODO: describe
  void initialize([List<String> args = const []]) {
    final argsPointers = args.map(Utf8.toUtf8).toList();
    final pointerPointer = allocate<Pointer<Utf8>>(count: argsPointers.length);
    for (var k = 0; k < argsPointers.length; k++) {
      pointerPointer[k] = argsPointers[k];
    }
    bindings.initialize(args.length, pointerPointer);
    free(pointerPointer);
  }

  /// Terminate libedax.
  void terminate() => bindings.terminate();
}

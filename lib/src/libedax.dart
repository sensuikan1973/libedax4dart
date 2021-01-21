import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'bindings/bindings.dart';

@immutable
class LibEdax {
  const LibEdax();

  /// Initialize libedax.
  ///
  /// Be careful that the first argument in [args] is ignored.
  /// ```dart
  /// initialize(['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16'])
  /// ```
  ///
  /// If you want to know more, See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
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

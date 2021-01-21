import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'bindings/bindings.dart';

@immutable
class LibEdax {
  const LibEdax();

  /// BLACK turn.
  int get black => 0;

  /// WHITE turn.
  int get white => 1;

  /// PASS Move.
  int get pass => 64;

  /// No Move.
  int get noMove => 65;

  /// Initialize libedax.
  ///
  /// Be careful that the first argument in [args] is ignored.
  /// ```dart
  /// const edax = LibEdax();
  /// edax.libedaxInitialize(['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16']);
  /// ```
  ///
  /// If you want to know more, See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
  void libedaxInitialize([List<String> args = const []]) {
    final argsPointers = args.map(Utf8.toUtf8).toList();
    final pointerPointer = allocate<Pointer<Utf8>>(count: argsPointers.length);
    for (var k = 0; k < argsPointers.length; k++) {
      pointerPointer[k] = argsPointers[k];
    }
    bindings.libedaxInitialize(args.length, pointerPointer);
    free(pointerPointer);
  }

  /// Terminate libedax.
  void libedaxTerminate() => bindings.libedaxTerminate();

  /// Init board.
  void edaxInit() => bindings.edaxInit();

  /// Init board based on setboard command.
  void edaxNew() => bindings.edaxNew();

  /// Undo.
  /// If mode is 0 or 2, undo until human's turn.
  void edaxUndo() => bindings.edaxUndo();

  /// Redo.
  /// If mode is 0 or 2, redo until human's turn.
  void edaxRedo() => bindings.edaxRedo();

  /// Set mode.
  /// * 0: Human(B) vs  Edax(W)
  /// * 1: Edax(B)  vs  Human(W)
  /// * 2: Edax(B)  vs  Edax(W)
  /// * 3: Human(B) vs  Human(W)
  void edaxMode(int mode) => bindings.edaxMode(mode);

  /// Flip vertical.
  void edaxVmirror() => bindings.edaxVmirror();

  /// Play moves.
  /// you can pass Lower case or Upper case. `f5F6F6g7` is OK.
  /// you can also pass opening name. (e.g. `play brightwell`)
  void edaxPlay(String moves) => bindings.edaxPlay(Utf8.toUtf8(moves));

  /// Stop edax search process, and set mode 3.
  void edaxStop() => bindings.edaxStop();

  /// print version.
  void edaxVersion() => bindings.edaxVersion();

  /// Play move.
  /// you can pass Lower case or Upper case. `f5` `F5` is OK.
  void edaxMove(String move) => bindings.edaxMove(Utf8.toUtf8(move));

  /// Get the opening name of the current game, in English.
  /// e.g. brightwell, tiger, rose, ....
  String edaxOpening() => Utf8.fromUtf8(bindings.edaxOpening());

  /// Check if the current game is over.
  bool edaxIsGameOver() => bindings.edaxIsGameOver() == 1;
}

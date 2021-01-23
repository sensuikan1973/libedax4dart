import 'dart:ffi';

import 'package:ffi/ffi.dart';

import './generated_bindings.dart';

void main() {
  final edax = LibEdaxBindings(DynamicLibrary.open('bin/libedax.dylib'));
  final args = List<String>.empty();
  final argsPointers = args.map(Utf8.toUtf8).toList();
    final pointerPointer = allocate<Pointer<Int8>>(count: argsPointers.length);
    for (var k = 0; k < argsPointers.length; k++) {
      pointerPointer[k] = argsPointers[k].cast<Int8>();
    }
  edax..libedax_initialize(args.length, pointerPointer)..edax_init()..edax_version();
  print(edax.edax_get_current_player());
  final board = allocate<Board>();
  edax.edax_get_board(board);
  print(board.ref.player);
  free(pointerPointer);
}

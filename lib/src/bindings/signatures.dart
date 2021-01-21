import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Native type is based on DLL_API of https://github.com/lavox/edax-reversi/tree/libedax.
// If you know the list, clone the repository and switch the branch, and grep "DLL_API".

typedef libedax_initialize_native_t = Int32 Function(Int32 argc, Pointer<Pointer<Utf8>> argv);
typedef libedax_terminate_native_t = Int32 Function();

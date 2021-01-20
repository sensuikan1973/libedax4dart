import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef libedax_initialize_native_t = Int32 Function(Int32 argc, Pointer<Pointer<Utf8>> argv);

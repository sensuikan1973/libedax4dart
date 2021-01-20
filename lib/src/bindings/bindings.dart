import 'dart:ffi';
import 'package:ffi/ffi.dart';
import '../ffi/dylib_utils.dart';
import 'signatures.dart';

_LibEdaxBindings? _cachedBindings;
_LibEdaxBindings get bindings => _cachedBindings ??= _LibEdaxBindings();

class _LibEdaxBindings {
  _LibEdaxBindings() {
    libedax = dlopenPlatformSpecific();
    _bindFunctions();
  }

  late DynamicLibrary libedax;

  late int Function(int argc, Pointer<Pointer<Utf8>> argv) initialize;

  void _bindFunctions() {
    initialize = libedax.lookup<NativeFunction<libedax_initialize_native_t>>('libedax_initialize').asFunction();
    // TODO: implement another function
  }
}

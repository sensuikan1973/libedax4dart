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
  late int Function() terminate;
  late int Function() version;

  void _bindFunctions() {
    initialize = libedax.lookup<NativeFunction<libedax_initialize_native_t>>('libedax_initialize').asFunction();
    terminate = libedax.lookup<NativeFunction<libedax_terminate_native_t>>('libedax_terminate').asFunction();
    version = libedax.lookup<NativeFunction<edax_version_native_t>>('edax_version').asFunction();
    // TODO: implement another function
  }
}

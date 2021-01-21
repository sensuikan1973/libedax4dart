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

  late final DynamicLibrary libedax;

  late final int Function(int argc, Pointer<Pointer<Utf8>> argv) libedaxInitialize;
  late final int Function() libedaxTerminate;
  late final int Function() edaxInit;
  late final int Function() edaxNew;
  late final int Function() edaxVersion;

  void _bindFunctions() {
    libedaxInitialize = libedax.lookup<NativeFunction<libedax_initialize_native_t>>('libedax_initialize').asFunction();
    libedaxTerminate = libedax.lookup<NativeFunction<libedax_terminate_native_t>>('libedax_terminate').asFunction();
    edaxInit = libedax.lookup<NativeFunction<edax_version_native_t>>('edax_init').asFunction();
    edaxNew = libedax.lookup<NativeFunction<edax_version_native_t>>('edax_new').asFunction();
    edaxVersion = libedax.lookup<NativeFunction<edax_version_native_t>>('edax_version').asFunction();
    // TODO: implement another function
  }
}

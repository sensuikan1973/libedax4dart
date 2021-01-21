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
  late final int Function() edaxUndo;
  late final int Function() edaxRedo;
  late final int Function(int mode) edaxMode;
  late final int Function(Pointer<Utf8> board) edaxSetboard;
  late final int Function() edaxVmirror;
  late final int Function(Pointer<Utf8> moves) edaxPlay;
  late final int Function() edaxGo;
  late final int Function() edaxStop;
  late final int Function() edaxVersion;
  late final int Function(Pointer<Utf8> moves) edaxMove;
  late final Pointer<Utf8> Function() edaxOpening;
  late final int Function() edaxBookOn;
  late final int Function() edaxBookOff;
  late final int Function(int randomness) edaxBookRandomness;
  late final int Function() edaxIsGameOver;
  late final int Function(int color) edaxGetMobilityCount;

  void _bindFunctions() {
    libedaxInitialize = libedax.lookup<NativeFunction<libedax_initialize_native_t>>('libedax_initialize').asFunction();
    libedaxTerminate = libedax.lookup<NativeFunction<libedax_terminate_native_t>>('libedax_terminate').asFunction();
    edaxInit = libedax.lookup<NativeFunction<edax_init_native_t>>('edax_init').asFunction();
    edaxNew = libedax.lookup<NativeFunction<edax_new_native_t>>('edax_new').asFunction();
    edaxUndo = libedax.lookup<NativeFunction<edax_undo_native_t>>('edax_undo').asFunction();
    edaxRedo = libedax.lookup<NativeFunction<edax_redo_native_t>>('edax_redo').asFunction();
    edaxMode = libedax.lookup<NativeFunction<edax_mode_native_t>>('edax_mode').asFunction();
    edaxSetboard = libedax.lookup<NativeFunction<edax_setboard_native_t>>('edax_setboard').asFunction();
    edaxVmirror = libedax.lookup<NativeFunction<edax_vmirror_native_t>>('edax_vmirror').asFunction();
    edaxPlay = libedax.lookup<NativeFunction<edax_play_native_t>>('edax_play').asFunction();
    edaxGo = libedax.lookup<NativeFunction<edax_go_native_t>>('edax_go').asFunction();
    edaxStop = libedax.lookup<NativeFunction<edax_stop_native_t>>('edax_stop').asFunction();
    edaxVersion = libedax.lookup<NativeFunction<edax_version_native_t>>('edax_version').asFunction();
    edaxMove = libedax.lookup<NativeFunction<edax_move_native_t>>('edax_move').asFunction();
    edaxOpening = libedax.lookup<NativeFunction<edax_opening_native_t>>('edax_opening').asFunction();
    edaxBookOn = libedax.lookup<NativeFunction<edax_book_on_native_t>>('edax_book_on').asFunction();
    edaxBookOff = libedax.lookup<NativeFunction<edax_book_off_native_t>>('edax_book_off').asFunction();
    edaxBookRandomness =
        libedax.lookup<NativeFunction<edax_book_randomness_native_t>>('edax_book_randomness').asFunction();
    edaxIsGameOver = libedax.lookup<NativeFunction<edax_is_game_over_native_t>>('edax_is_game_over').asFunction();
    edaxGetMobilityCount =
        libedax.lookup<NativeFunction<edax_get_mobility_count_native_t>>('edax_get_mobility_count').asFunction();
  }
}

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import '../ffi/dylib_utils.dart';
import 'signatures.dart';
import 'structs/board.dart';
import 'structs/hint_list.dart';
import 'structs/move.dart';
import 'structs/move_list.dart';

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
  late final int Function(int n, Pointer<HintList> hintList) edaxHint;
  late final int Function(Pointer<MoveList> moveList) edaxGetBookMove;
  late final int Function(Pointer<MoveList> excludeList) edaxHintPrepare;
  late final int Function() edaxStop;
  late final int Function() edaxVersion;
  late final int Function(Pointer<Utf8> moves) edaxMove;
  late final Pointer<Utf8> Function() edaxOpening;
  late final int Function() edaxBookOn;
  late final int Function() edaxBookOff;
  late final int Function(int randomness) edaxBookRandomness;
  late final int Function(int level, int depth) edaxBookNew;
  late final int Function(Pointer<Utf8> optionName, Pointer<Utf8> val) edaxSetOption;
  late final Pointer<Utf8> Function(Pointer<Uint8> str) edaxGetMoves;
  late final int Function() edaxIsGameOver;
  late final int Function() edaxCanMove;
  late final int Function(Pointer<Move> move) edaxGetLastMove;
  late final int Function(Pointer<Board> board) edaxGetBoard;
  late final int Function() edaxGetCurrentPlayer;
  late final int Function(int color) edaxGetDisc;
  late final int Function(int color) edaxGetMobilityCount;

  late final int Function(int bit) bitCount;

  void _bindFunctions() {
    libedaxInitialize = _lookupNativeFunc<libedax_initialize_native_t>('libedax_initialize').asFunction();
    libedaxTerminate = _lookupNativeFunc<libedax_terminate_native_t>('libedax_terminate').asFunction();
    edaxInit = _lookupNativeFunc<edax_init_native_t>('edax_init').asFunction();
    edaxNew = _lookupNativeFunc<edax_new_native_t>('edax_new').asFunction();
    edaxUndo = _lookupNativeFunc<edax_undo_native_t>('edax_undo').asFunction();
    edaxRedo = _lookupNativeFunc<edax_redo_native_t>('edax_redo').asFunction();
    edaxMode = _lookupNativeFunc<edax_mode_native_t>('edax_mode').asFunction();
    edaxSetboard = _lookupNativeFunc<edax_setboard_native_t>('edax_setboard').asFunction();
    edaxVmirror = _lookupNativeFunc<edax_vmirror_native_t>('edax_vmirror').asFunction();
    edaxPlay = _lookupNativeFunc<edax_play_native_t>('edax_play').asFunction();
    edaxGo = _lookupNativeFunc<edax_go_native_t>('edax_go').asFunction();
    edaxHint = _lookupNativeFunc<edax_hint_native_t>('edax_hint').asFunction();
    edaxGetBookMove = _lookupNativeFunc<edax_get_bookmove_native_t>('edax_get_bookmove').asFunction();
    edaxHintPrepare = _lookupNativeFunc<edax_hint_prepare_native_t>('edax_hint_prepare').asFunction();
    edaxStop = _lookupNativeFunc<edax_stop_native_t>('edax_stop').asFunction();
    edaxVersion = _lookupNativeFunc<edax_version_native_t>('edax_version').asFunction();
    edaxMove = _lookupNativeFunc<edax_move_native_t>('edax_move').asFunction();
    edaxOpening = _lookupNativeFunc<edax_opening_native_t>('edax_opening').asFunction();
    edaxBookOn = _lookupNativeFunc<edax_book_on_native_t>('edax_book_on').asFunction();
    edaxBookOff = _lookupNativeFunc<edax_book_off_native_t>('edax_book_off').asFunction();
    edaxBookRandomness = _lookupNativeFunc<edax_book_randomness_native_t>('edax_book_randomness').asFunction();
    edaxBookNew = _lookupNativeFunc<edax_book_new_native_t>('edax_book_new').asFunction();
    edaxSetOption = _lookupNativeFunc<edax_set_option_native_t>('edax_set_option').asFunction();
    edaxGetMoves = _lookupNativeFunc<edax_get_moves_native_t>('edax_get_moves').asFunction();
    edaxIsGameOver = _lookupNativeFunc<edax_is_game_over_native_t>('edax_is_game_over').asFunction();
    edaxCanMove = _lookupNativeFunc<edax_can_move_native_t>('edax_can_move').asFunction();
    edaxGetLastMove = _lookupNativeFunc<edax_get_last_move_native_t>('edax_get_last_move').asFunction();
    edaxGetBoard = _lookupNativeFunc<edax_get_board_native_t>('edax_get_board').asFunction();
    edaxGetCurrentPlayer = _lookupNativeFunc<edax_get_current_player_native_t>('edax_get_current_player').asFunction();
    edaxGetDisc = _lookupNativeFunc<edax_get_disc_native_t>('edax_get_disc').asFunction();
    edaxGetMobilityCount = _lookupNativeFunc<edax_get_mobility_count_native_t>('edax_get_mobility_count').asFunction();

    bitCount = _lookupNativeFunc<bit_count_native_t>('bit_count').asFunction();
  }

  Pointer<NativeFunction<T>> _lookupNativeFunc<T extends Function>(String symbolName) =>
      libedax.lookup<NativeFunction<T>>(symbolName);
}

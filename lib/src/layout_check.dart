// lib/src/layout_check.dart
// Utility to verify Position struct layout between libedax C binary and Dart FFI bindings.

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'ffi/dylib_utils.dart';
import 'ffi/bindings.dart' as bindings;

/// Call C API libedax_get_position_layout and compare with Dart bindings size.
/// Returns true if sizes match (basic check), false otherwise.
bool verifyPositionLayout([String dllPath = '']) {
  final dylib = dlopenPlatformSpecific(dllPath);
  final layoutFn = dylib.lookupFunction<
      Int32 Function(Pointer<Int32>, Int32),
      int Function(Pointer<Int32>, int)>('libedax_get_position_layout');

  final out = calloc<Int32>(11);
  try {
    final n = layoutFn(out, 11);
    if (n != 11) {
      print('libedax_get_position_layout failed (returned $n)');
      return false;
    }
    final values = List<int>.generate(11, (i) => out[i]);
    final cSize = values[0];
    final cBoardOffset = values[1];
    final cLeafOffset = values[2];
    final cFlagOffset = values[3];
    final cNPlayerBestpaths = values[4];
    final cNOppBestpaths = values[5];
    final cLinkOffset = values[6];
    final cNWins = values[7];
    final cScoreOffset = values[8];
    final cNLinkOffset = values[9];
    final cLevelOffset = values[10];

    final dartSize = sizeOf<bindings.Position>();
    print('C sizeof(Position) = $cSize, Dart bindings sizeof = $dartSize');
    if (cSize != dartSize) {
      print('SIZE MISMATCH');
    } else {
      print('size matches');
    }

    print('C offsets (bytes): board:$cBoardOffset leaf:$cLeafOffset flag:$cFlagOffset n_player_bestpaths:$cNPlayerBestpaths n_opponent_bestpaths:$cNOppBestpaths link:$cLinkOffset n_wins:$cNWins score:$cScoreOffset n_link:$cNLinkOffset level:$cLevelOffset');

    return cSize == dartSize;
  } finally {
    calloc.free(out);
  }
}

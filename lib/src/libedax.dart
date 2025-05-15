import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

import 'board.dart';
import 'constants.dart';
import 'count_bestpath_result.dart';
import 'extensions/pointer_char.dart';
import 'extensions/string.dart';
import 'ffi/bindings.dart' as bindings;
import 'ffi/dylib_utils.dart';
import 'hint.dart';
import 'move.dart';
import 'move_list_with_position.dart';
import 'position.dart';

/// main class which call libedax api with ffi.
@immutable
class LibEdax {
  LibEdax([final String dllPath = '']) {
    _dylib = dlopenPlatformSpecific(dllPath);
    _bindings = bindings.LibEdaxBindings(_dylib);
  }

  late final DynamicLibrary _dylib;
  late final bindings.LibEdaxBindings _bindings;

  /// Initialize libedax.
  ///
  /// Be careful that the first argument in [args] is ignored.
  /// ```dart
  /// final edax = LibEdax();
  /// edax.libedaxInitialize(['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16']);
  /// ```
  ///
  /// If you want to know more, See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
  void libedaxInitialize([final List<String> args = const []]) {
    final argsPointers = args.map((final arg) => arg.toCharPointer()).toList();

    // See: https://github.com/dart-lang/ffigen/issues/72
    final pointerPointer = calloc<Pointer<Char>>(argsPointers.length);
    for (var k = 0; k < argsPointers.length; k++) {
      pointerPointer[k] = argsPointers[k];
    }
    _bindings.libedax_initialize(args.length, pointerPointer);
    calloc.free(pointerPointer);
  }

  /// Terminate libedax.
  void libedaxTerminate() => _bindings.libedax_terminate();

  /// Close dll.
  ///
  /// After you call this, if you use edax command, you have to recreate [LibEdax] instance.
  void closeDll() => _dylib.close();

  /// Init board.
  void edaxInit() => _bindings.edax_init();

  /// Init board based on setboard command.
  void edaxNew() => _bindings.edax_new();

  /// Undo move.
  ///
  /// If mode is 0 or 2, undo until human's turn.
  void edaxUndo() => _bindings.edax_undo();

  /// Redo move.
  ///
  /// If mode is 0 or 2, redo until human's turn.
  void edaxRedo() => _bindings.edax_redo();

  /// Set mode.
  /// * 0: Human(B) vs  Edax(W)
  /// * 1: Edax(B)  vs  Human(W)
  /// * 2: Edax(B)  vs  Edax(W)
  /// * 3: Human(B) vs  Human(W)
  void edaxMode(final int mode) => _bindings.edax_mode(mode);

  /// Flip vertical.
  void edaxVmirror() => _bindings.edax_vmirror();

  /// Rotate.
  ///
  /// angle: 90 or 180 or 270.
  void edaxRotate(final int angle) {
    if (![90, 180, 270].contains(angle)) {
      throw Exception('angle of edaxRotate supports only 90,180,270');
    }
    _bindings.edax_rotate(angle);
  }

  /// Play moves.
  ///
  /// you can pass Lower case or Upper case. `f5F6F6g7` is OK. <br>
  /// you can also pass opening name. (e.g. `brightwell`) <br>
  /// opening names are listed on [opening.c](https://github.com/lavox/edax-reversi/blob/libedax/src/opening.c).
  void edaxPlay(final String moves) {
    final arg = moves.toCharPointer();
    _bindings.edax_play(arg);
    calloc.free(arg);
  }

  /// Let edax move.
  void edaxGo() => _bindings.edax_go();

  /// Get hint.
  List<Hint> edaxHint(final int n) {
    final dst = calloc<bindings.HintList>();
    _bindings.edax_hint(n, dst);
    final hintList = dst.ref;
    final result = <Hint>[];
    for (var k = 0; k < hintList.n_hints; k++) {
      final h = hintList.hint[k + 1];
      result.add(Hint.fromCStruct(h));
    }
    calloc.free(dst);
    return result;
  }

  /// Get book move list.
  List<Move> edaxGetBookMove() {
    final dst = calloc<bindings.MoveList>();
    _bindings.edax_get_bookmove(dst);
    final moveList = dst.ref;
    final result = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      result.add(Move.fromCStruct(m));
    }
    calloc.free(dst);
    return result;
  }

  /// Get book move list with position.
  MoveListWithPosition edaxGetBookMoveWithPosition() {
    final dstM = calloc<bindings.MoveList>();
    final dstP = calloc<bindings.Position>();
    final symetry = _bindings.edax_get_bookmove_with_position(dstM, dstP);

    final moveList = dstM.ref;
    final resultMoveList = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      resultMoveList.add(Move.fromCStruct(m));
    }
    calloc.free(dstM);

    final position = Position.fromCStruct(dstP.ref);
    calloc.free(dstP);

    return MoveListWithPosition(resultMoveList, position, symetry);
  }

  /// Get book move list with position by specified moves.
  MoveListWithPosition edaxGetBookMoveWithPositionByMoves(final String moves) {
    final dstM = calloc<bindings.MoveList>();
    final dstP = calloc<bindings.Position>();
    final movesPointer = moves.toCharPointer();
    final symetry = _bindings.edax_get_bookmove_with_position_by_moves(
      movesPointer,
      dstM,
      dstP,
    );
    calloc.free(movesPointer);

    final moveList = dstM.ref;
    final resultMoveList = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      resultMoveList.add(Move.fromCStruct(m));
    }
    calloc.free(dstM);

    final position = Position.fromCStruct(dstP.ref);
    calloc.free(dstP);

    return MoveListWithPosition(resultMoveList, position, symetry);
  }

  /// Prepare to get hint.
  ///
  /// __Call [edaxHintNext] after calling this function__.
  // TODO: implement exclude list if you need.
  void edaxHintPrepare() => _bindings.edax_hint_prepare(nullptr);

  /// Get a hint.
  ///
  /// __Call [edaxHintPrepare] before calling this function__. <br>
  /// If there are no more hints, `hint.isNoMove` will be true.
  Hint edaxHintNext() {
    final dst = calloc<bindings.Hint>();
    _bindings.edax_hint_next(dst);
    final hint = Hint.fromCStruct(dst.ref);
    calloc.free(dst);
    return hint;
  }

  /// Get a hint.
  ///
  /// __Call [edaxHintPrepare] before calling this function__. <br>
  /// If there are no more hints, `hint.isNoMove` will be true. <br>
  /// __This function doesn't use Multi-PV search for analyze usecase. This can be faster than [edaxHintNext]__.
  Hint edaxHintNextNoMultiPvDepth() {
    final dst = calloc<bindings.Hint>();
    _bindings.edax_hint_next_no_multipv_depth(dst);
    final hint = Hint.fromCStruct(dst.ref);
    calloc.free(dst);
    return hint;
  }

  /// Stop edax search process, and set mode 3.
  void edaxStop() => _bindings.edax_stop();

  /// print version.
  void edaxVersion() => _bindings.edax_version();

  /// Play move.
  ///
  /// you can pass Lower case or Upper case. `f5` `F5` is OK. <br>
  /// if you want to switch turn when mobilicty count is 0, pass `MoveMark.passString`.
  void edaxMove(final String move) {
    final arg = move.toCharPointer();
    _bindings.edax_move(arg);
    calloc.free(arg);
  }

  /// Set board from string.
  ///
  /// e.g. `-W----W--------------------WB------WBB-----W--------------------B`.
  /// * BLACK: `B`,`b`,`x`,`X`,`*`
  /// * WHITE: `o`,`O`,`w`,`W`
  /// * EMPTY: `-`,`.`
  ///
  /// Last char is turn.
  void edaxSetboard(final String board) {
    final arg = board.toCharPointer();
    _bindings.edax_setboard(arg);
    calloc.free(arg);
  }

  /// Get the opening name of the current game, in English.
  ///
  /// e.g. `brightwell`, `tiger`, `rose`, ....
  String edaxOpening() => _bindings.edax_opening().toDartStr();

  /// Use book on `edaxGo`, `edaxHint`, `mode 2`.<br>
  /// default is on.
  void edaxBookOn() => _bindings.edax_book_on();

  /// Don't use book on `edaxGo`, `edaxHint`, `mode 2`.
  void edaxBookOff() => _bindings.edax_book_off();

  /// Set randomness on `edaxGo`, `mode 2`. <br>
  /// default is 0.
  ///
  /// edax will choose move with the randomness width.
  void edaxBookRandomness(final int randomness) =>
      _bindings.edax_book_randomness(randomness);

  /// Create a new book.
  void edaxBookNew(final int level, final int depth) =>
      _bindings.edax_book_new(level, depth);

  /// Load book.
  void edaxBookLoad(final String bookFile) {
    final arg = bookFile.toCharPointer();
    _bindings.edax_book_load(arg);
    calloc.free(arg);
  }

  /// Show book.
  ///
  /// Probably, you should use [edaxGetBookMoveWithPosition()]. <br>
  /// See: https://github.com/sensuikan1973/libedax4dart/issues/46
  Position edaxBookShow() {
    final dstP = calloc<bindings.Position>();
    _bindings.edax_book_show(dstP);
    final position = Position.fromCStruct(dstP.ref);
    calloc.free(dstP);
    return position;
  }

  /// Set option.
  ///
  /// See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
  void edaxSetOption(final String optionName, final String val) {
    final optionNameArg = optionName.toCharPointer();
    final valArg = val.toCharPointer();
    _bindings.edax_set_option(optionNameArg, valArg);
    calloc
      ..free(optionNameArg)
      ..free(valArg);
  }

  /// Get current moves.
  String edaxGetMoves() {
    final moves = calloc<Char>(80 * 2 + 1);
    final result = _bindings.edax_get_moves(moves).toDartStr();
    calloc.free(moves);
    return result;
  }

  /// Check if the current game is over.
  bool edaxIsGameOver() => _bindings.edax_is_game_over() == 1;

  /// Check if the current player can move.
  bool edaxCanMove() => _bindings.edax_can_move() == 1;

  /// Get the last move.
  ///
  /// NOTE: you have to handle the case that noMove is true.
  Move edaxGetLastMove() {
    final moves = edaxGetMoves();
    if (moves.isEmpty) return const Move(0, MoveMark.noMove, 0, 0);

    final dst = calloc<bindings.Move>();
    _bindings.edax_get_last_move(dst);
    final move = Move.fromCStruct(dst.ref);
    calloc.free(dst);
    return move;
  }

  /// Get the current board.
  Board edaxGetBoard() {
    final dst = calloc<bindings.Board>();
    _bindings.edax_get_board(dst);
    final board = Board.fromCStruct(dst.ref);
    calloc.free(dst);
    return board;
  }

  /// Get the current player.
  /// * 0: BLACK
  /// * 1: WHITE
  int edaxGetCurrentPlayer() => _bindings.edax_get_current_player();

  /// Get the opponent player.
  /// * 0: BLACK
  /// * 1: WHITE
  int edaxGetOpponentPlayer() {
    final currentPlayer = _bindings.edax_get_current_player();
    if (currentPlayer == TurnColor.black) {
      return TurnColor.white;
    } else {
      return TurnColor.black;
    }
  }

  /// Get the current number of discs.
  int edaxGetDisc(final int color) => _bindings.edax_get_disc(color);

  /// Get the legal move count.
  int edaxGetMobilityCount(final int color) =>
      _bindings.edax_get_mobility_count(color);

  /// Count bit.
  int popCount(final int bit) => _bindings.bit_count(bit);

  /// Count bestpath with book.
  ///
  /// Compute the indicator of efficiency to win, which means the minimum number you should memorize on the situation both of players always choose one of the move list which of score is larger than lower limit.
  ///
  /// This function is very __advanced__. <br>
  /// __You must understand [the book structure of edax](https://choi.lavox.net/edax/book) and following important notice list__.
  ///
  /// * Because internal each node lookup is stopped when book has no links, the more lower the accuracy of your book is, the more lower this feature accuracy is.
  ///   * In addition, if your book has some depth links (e.g. 24, 30, 40, ...), shallow depth link (≈ path is few) can be taken with a reasonable probability.
  ///   * __In a word, if the accuracy of your book is low, you shouldn't use this function__. For you reference, if your book has N GB and the depth is more than 30, this feature can probably be inidicator.
  /// * This function only lookup the best score links. So, this indicator can't consider easy win links which is _not_ best score. In reversi game, the situation can sometimes be found in my experience as a player.
  ///   * __In a word, as you know, this indicator isn't perfect. This is just a indicator__.
  /// * The depth of this feature depends on your book.
  /// * The moves which meet up with another moves is counted respectively.
  ///   * btw, symmetric moves is counted 1 because of edax book structure.
  CountBestpathResult edaxBookCountBoardBestpath(
    final Board board, {
    required final int playerColor,
    // by default, LowerLimit is only best moves.
    final int playerLowerLimit = BookCountBoardBestPathLowerLimit.best,
    final int opponentLowerLimit = BookCountBoardBestPathLowerLimit.best,
  }) {
    final dstP = calloc<bindings.Position>();
    final dstB = calloc<bindings.Board>();
    dstB.ref.player = board.player;
    dstB.ref.opponent = board.opponent;
    _bindings.edax_book_count_board_bestpath(
      dstB,
      dstP,
      playerLowerLimit,
      opponentLowerLimit,
      playerColor,
    );

    final position = Position.fromCStruct(dstP.ref);
    calloc
      ..free(dstP)
      ..free(dstB);
    return CountBestpathResult(board, position, playerColor);
  }

  /// Stop [edaxBookCountBoardBestpath].
  void edaxBookStopCountBestpath() => _bindings.edax_book_stop_count_bestpath();

  /// Print play.
  ///
  /// example: after play f5d6c5f4d3, play_print prints
  /// ```txt
  ///   A B C D E F G H            BLACK            A  B  C  D  E  F  G  H
  /// 1 - - - - - - - - 1         0:00.012       1 |  |  |  |  |  |  |  |  | 1
  /// 2 - - - . - - - - 2    6 discs   6 moves   2 |  |  |  |  |  |  |  |  | 2
  /// 3 - - . * . - - - 3                        3 |  |  |  | 5|  |  |  |  | 3
  /// 4 - . . * * O - - 4  ply  6 (55 empties)   4 |  |  |  |()|##| 4|  |  | 4
  /// 5 - . * * O * . - 5    White's turn (O)    5 |  |  | 3|##|()| 1|  |  | 5
  /// 6 - - - O - . - - 6                        6 |  |  |  | 2|  |  |  |  | 6
  /// 7 - - - - - - - - 7    3 discs   8 moves   7 |  |  |  |  |  |  |  |  | 7
  /// 8 - - - - - - - - 8         0:00.000       8 |  |  |  |  |  |  |  |  | 8
  ///   A B C D E F G H            WHITE            A  B  C  D  E  F  G  H
  /// ```
  void edaxPlayPrint() => _bindings.edax_play_print();

  /// Fix book.
  ///
  /// See: https://choi.lavox.net/edax/ref_command_book#book_fix
  void edaxBookFix() => _bindings.edax_book_fix();

  /// Book deviate.
  ///
  /// See: https://choi.lavox.net/edax/ref_command_book#book_deviate
  void edaxBookDeviate(final int relativeError, final int absoluteError) =>
      _bindings.edax_book_deviate(relativeError, absoluteError);

  /// Dump options.
  void edaxOptionsDump() => _bindings.edax_options_dump();

  /// Book store.
  ///
  /// See: https://choi.lavox.net/edax/ref_command_book#book_store
  void edaxBookStore() => _bindings.edax_book_store();

  /// Book save.
  ///
  /// See: https://choi.lavox.net/edax/ref_command_book#book_save
  void edaxBookSave(final String bookFile) {
    final arg = bookFile.toCharPointer();
    _bindings.edax_book_save(arg);
    calloc.free(arg);
  }

  /// Enable book_verbose to get stdout by bprint in edax.
  void edaxEnableBookVerbose() => _bindings.edax_enable_book_verbose();

  /// Disable book_verbose not to get stdout by bprint in edax.
  void edaxDisableBookVerbose() => _bindings.edax_disable_book_verbose();

  /// Set book verbosity.
  ///
  /// NOTE: this verbosity is unrelated to `book_verbose` which shows stdout by bprint in edax.
  void edaxBookVerbose(final int verbosity) =>
      _bindings.edax_book_verbose(verbosity);

  /// Check if current player should pass.
  bool edaxBoardIsPass(final Board board) {
    final dstB = calloc<bindings.Board>();
    dstB.ref.player = board.player;
    dstB.ref.opponent = board.opponent;
    final result = _bindings.edax_board_is_pass(dstB);
    calloc.free(dstB);
    return result == 1;
  }

  /// Get square color.
  /// 0 = player, 1 = opponent, 2 = empty.
  int edaxBoardGetSquareColor(final Board board, final int x) {
    final dstB = calloc<bindings.Board>();
    dstB.ref.player = board.player;
    dstB.ref.opponent = board.opponent;
    final result = _bindings.edax_board_get_square_color(dstB, x);
    calloc.free(dstB);
    return result;
  }
}

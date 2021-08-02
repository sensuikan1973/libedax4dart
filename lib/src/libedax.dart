import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

import 'api/api.dart' as api;
import 'api/util.dart';
import 'ffi/bindings.dart' as bindings;
import 'ffi/dylib_utils.dart';

@immutable
class LibEdax {
  LibEdax([final String dllPath = '']) {
    dylib = dlopenPlatformSpecific(dllPath);
    _bindings = bindings.LibEdaxBindings(dylib);
  }

  late final DynamicLibrary dylib;
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
    final argsPointers = args.map((final arg) => arg.toNativeUtf8()).toList();
    final pointerPointer = calloc<Pointer<Int8>>(argsPointers.length);
    for (var k = 0; k < argsPointers.length; k++) {
      pointerPointer[k] = argsPointers[k].cast<Int8>();
    }
    _bindings.libedax_initialize(args.length, pointerPointer);
    calloc.free(pointerPointer);
  }

  /// Terminate libedax.
  void libedaxTerminate() => _bindings.libedax_terminate();

  /// Init board.
  void edaxInit() => _bindings.edax_init();

  /// Init board based on setboard command.
  void edaxNew() => _bindings.edax_new();

  /// Undo.
  ///
  /// If mode is 0 or 2, undo until human's turn.
  void edaxUndo() => _bindings.edax_undo();

  /// Redo.
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
    if (![90, 180, 270].contains(angle)) throw Exception('angle of edaxRotate supports only 90,180,270');
    _bindings.edax_rotate(angle);
  }

  /// Play moves.
  ///
  /// you can pass Lower case or Upper case. `f5F6F6g7` is OK. <br>
  /// you can also pass opening name. (e.g. `brightwell`) <br>
  /// opening names are listed on [opening.c](https://github.com/lavox/edax-reversi/blob/libedax/src/opening.c).
  void edaxPlay(final String moves) {
    final arg = moves.toNativeUtf8().cast<Int8>();
    _bindings.edax_play(arg);
    calloc.free(arg);
  }

  /// Let edax move.
  void edaxGo() => _bindings.edax_go();

  /// Get hint.
  List<api.Hint> edaxHint(final int n) {
    final dst = calloc<bindings.HintList>();
    _bindings.edax_hint(n, dst);
    final hintList = dst.ref;
    final result = <api.Hint>[];
    for (var k = 0; k < hintList.n_hints; k++) {
      final h = hintList.hint[k + 1];
      result.add(api.Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move));
    }
    calloc.free(dst);
    return result;
  }

  /// Get book move list.
  List<api.Move> edaxGetBookMove() {
    final dst = calloc<bindings.MoveList>();
    _bindings.edax_get_bookmove(dst);
    final moveList = dst.ref;
    final result = <api.Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      result.add(api.Move(m.flipped, m.x, m.score, m.cost));
    }
    calloc.free(dst);
    return result;
  }

  /// Get book move list with position.
  api.MoveListWithPosition edaxGetBookMoveWithPosition() {
    final dstM = calloc<bindings.MoveList>();
    final dstP = calloc<bindings.Position>();
    final symetry = _bindings.edax_get_bookmove_with_position(dstM, dstP);

    final moveList = dstM.ref;
    final resultMoveList = <api.Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      resultMoveList.add(api.Move(m.flipped, m.x, m.score, m.cost));
    }
    calloc.free(dstM);

    final pos = dstP.ref;
    final board = api.Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = api.Link(pos.leaf.score, pos.leaf.move);
    final links = <api.Link>[];
    for (var k = 0; k < pos.n_link; k++) {
      links.add(api.Link(pos.link.elementAt(k).ref.score, pos.link.elementAt(k).ref.move));
    }
    final score = api.Score(pos.score.value, pos.score.lower, pos.score.upper);
    final resultPosition = api.Position(
      board,
      leaf,
      links,
      pos.n_wins,
      pos.n_draws,
      pos.n_losses,
      pos.n_lines,
      score,
      pos.n_link,
      pos.level,
      pos.done,
      pos.todo,
    );
    calloc.free(dstP);

    return api.MoveListWithPosition(resultMoveList, resultPosition, symetry);
  }

  /// Get book move list with position by specified moves.
  api.MoveListWithPosition edaxGetBookMoveWithPositionByMoves(final String moves) {
    final dstM = calloc<bindings.MoveList>();
    final dstP = calloc<bindings.Position>();
    final symetry = _bindings.edax_get_bookmove_with_position_by_moves(moves.toNativeUtf8().cast<Int8>(), dstM, dstP);

    final moveList = dstM.ref;
    final resultMoveList = <api.Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      resultMoveList.add(api.Move(m.flipped, m.x, m.score, m.cost));
    }
    calloc.free(dstM);

    final pos = dstP.ref;
    final board = api.Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = api.Link(pos.leaf.score, pos.leaf.move);
    final links = <api.Link>[];
    for (var k = 0; k < pos.n_link; k++) {
      links.add(api.Link(pos.link.elementAt(k).ref.score, pos.link.elementAt(k).ref.move));
    }
    final score = api.Score(pos.score.value, pos.score.lower, pos.score.upper);
    final resultPosition = api.Position(
      board,
      leaf,
      links,
      pos.n_wins,
      pos.n_draws,
      pos.n_losses,
      pos.n_lines,
      score,
      pos.n_link,
      pos.level,
      pos.done,
      pos.todo,
    );
    calloc.free(dstP);

    return api.MoveListWithPosition(resultMoveList, resultPosition, symetry);
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
  api.Hint edaxHintNext() {
    final dst = calloc<bindings.Hint>();
    _bindings.edax_hint_next(dst);
    final h = dst.ref;
    final result = api.Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move);
    calloc.free(dst);
    return result;
  }

  /// Get a hint.
  ///
  /// __Call [edaxHintPrepare] before calling this function__. <br>
  /// If there are no more hints, `hint.isNoMove` will be true. <br>
  /// __This function doesn't use Multi-PV search for analyze usecase. This can be faster than [edaxHintNext]__.
  api.Hint edaxHintNextNoMultiPvDepth() {
    final dst = calloc<bindings.Hint>();
    _bindings.edax_hint_next_no_multipv_depth(dst);
    final h = dst.ref;
    final result = api.Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move);
    calloc.free(dst);
    return result;
  }

  /// Stop edax search process, and set mode 3.
  void edaxStop() => _bindings.edax_stop();

  /// print version.
  void edaxVersion() => _bindings.edax_version();

  /// Play move.
  ///
  /// you can pass Lower case or Upper case. `f5` `F5` is OK. <br>
  /// if you want to switch turn when mobilicty count is 0, pass `api.MoveMark.passString`.
  void edaxMove(final String move) {
    final arg = move.toNativeUtf8().cast<Int8>();
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
    final arg = board.toNativeUtf8().cast<Int8>();
    _bindings.edax_setboard(arg);
    calloc.free(arg);
  }

  /// Get the opening name of the current game, in English.
  ///
  /// e.g. `brightwell`, `tiger`, `rose`, ....
  String edaxOpening() => _bindings.edax_opening().toString();

  /// Use book on `edaxGo`, `edaxHint`, `mode 2`.<br>
  /// default is on.
  void edaxBookOn() => _bindings.edax_book_on();

  /// Don't use book on `edaxGo`, `edaxHint`, `mode 2`.
  void edaxBookOff() => _bindings.edax_book_off();

  /// Set randomness on `edaxGo`, `mode 2`. <br>
  /// default is 0.
  ///
  /// edax will choose move with the randomness width.
  void edaxBookRandomness(final int randomness) => _bindings.edax_book_randomness(randomness);

  /// Create a new book.
  void edaxBookNew(final int level, final int depth) => _bindings.edax_book_new(level, depth);

  /// Load book.
  void edaxBookLoad(final String bookFile) {
    final arg = bookFile.toNativeUtf8().cast<Int8>();
    _bindings.edax_book_load(arg);
    calloc.free(arg);
  }

  /// Show book.
  ///
  /// Probably, you should use [edaxGetBookMoveWithPosition()]. <br>
  /// See: https://github.com/sensuikan1973/libedax4dart/issues/46
  api.Position edaxBookShow() {
    final dstP = calloc<bindings.Position>();
    _bindings.edax_book_show(dstP);

    final pos = dstP.ref;
    final board = api.Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = api.Link(pos.leaf.score, pos.leaf.move);
    final links = <api.Link>[];
    for (var k = 0; k < pos.n_link; k++) {
      links.add(api.Link(pos.link.elementAt(k).ref.score, pos.link.elementAt(k).ref.move));
    }
    final score = api.Score(pos.score.value, pos.score.lower, pos.score.upper);
    final result = api.Position(
      board,
      leaf,
      links,
      pos.n_wins,
      pos.n_draws,
      pos.n_losses,
      pos.n_lines,
      score,
      pos.n_link,
      pos.level,
      pos.done,
      pos.todo,
    );
    calloc.free(dstP);
    return result;
  }

  /// Set option.
  ///
  /// See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
  void edaxSetOption(final String optionName, final String val) =>
      _bindings.edax_set_option(optionName.toNativeUtf8().cast<Int8>(), val.toNativeUtf8().cast<Int8>());

  /// Get current moves.
  String edaxGetMoves() {
    final moves = calloc<Uint8>(80 * 2 + 1);
    final result = _bindings.edax_get_moves(moves.cast<Int8>()).toString();
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
  api.Move edaxGetLastMove() {
    final moves = edaxGetMoves();
    if (moves.isEmpty) return const api.Move(0, api.MoveMark.noMove, 0, 0);

    final dst = calloc<bindings.Move>();
    _bindings.edax_get_last_move(dst);
    final move = dst.ref;
    final result = api.Move(move.flipped, move.x, move.score, move.cost);
    calloc.free(dst);
    return result;
  }

  /// Get the current board.
  api.Board edaxGetBoard() {
    final dst = calloc<bindings.Board>();
    _bindings.edax_get_board(dst);
    final board = dst.ref;
    final result = api.Board(board.player, board.opponent);
    calloc.free(dst);
    return result;
  }

  /// Get the current player.
  /// * 0: BLACK
  /// * 1: WHITE
  int edaxGetCurrentPlayer() => _bindings.edax_get_current_player();

  /// Get the current number of discs.
  int edaxGetDisc(final int color) => _bindings.edax_get_disc(color);

  /// Get the legal move count.
  int edaxGetMobilityCount(final int color) => _bindings.edax_get_mobility_count(color);

  /// Count bit.
  int popCount(final int bit) => _bindings.bit_count(bit);

  /// Compute the indicator of efficiency to win, which means the minimum number you should memorize on the situation both of players always choose one of the best move list.
  ///
  /// [level] is search depth. <br>
  /// If [onlyBestScoreLink] is true, only compute the best score links on the current moves.
  ///
  /// This is a Dart level function, and unique feature to libedax4dart.
  ///
  /// btw, you can also see the graph of tree generated by this function, with using `BestPathNumWithLink.root.exportGraphvizDotFile()`. <br>
  /// e.g. on a light book, when current moves is 'f5f6', you can get a graph like this([graphviz online](https://bit.ly/3edxWGO)).
  ///
  /// This function is not only experimental but also __advanced__. <br>
  /// __You must understand [the book structure of edax](https://choi.lavox.net/edax/book) and following important notice list__.
  ///
  /// * Because internal each node lookup is stopped when book has no links, the more lower the accuracy of your book is, the more lower this feature accuracy is.
  ///   * In addition, if your book has some depth links (e.g. 24, 30, 40, ...), shallow depth link (≈ path is few) can be taken with a reasonable probability.
  ///   * __In a word, if the accuracy of your book is low, you shoudn't use this function__. For you reference, if your book has N GB and the depth is more than 30, this feature can probably be inidicator.
  /// * This function only lookup the best score links. So, this indicator can't consider easy win links which is _not_ best score. In reversi game, the situation can sometimes be found in my experience as a player.
  ///   * __In a word, as you know, this indicator isn't perfect. This is just a indicator__.
  /// * The depth of this feature depends on [level] or your book.
  /// * The moves which meet up with anoter moves is counted respectively.
  ///   * btw, symmetric moves is counted 1 because of edax book structure.
  /// * O(k^N). slow.
  ///   * TODO(developer): consider following implementation.
  ///     * isolation.
  ///     * save tree data on local.
  ///
  /// REF: https://github.com/abulmo/edax-reversi/blob/1ae7c9fe5322ac01975f1b3196e788b0d25c1e10/src/book.c#L2438-L2447
  @experimental
  List<api.BestPathNumWithLink> computeBestPathNumWithLink({
    required final int level,
    final bool onlyBestScoreLink = true,
    final bool enableToPrintMovesOnBuildingTree = false,
  }) {
    final headMoves = edaxGetMoves();
    final maxDepth = headMoves.length + level * 2;
    if (headMoves.isEmpty || headMoves.length >= maxDepth) return [];

    final headColor = edaxGetCurrentPlayer();
    final moveListWithPosition = edaxGetBookMoveWithPositionByMoves(headMoves);
    final position = moveListWithPosition.position;
    final targetRootLinks = onlyBestScoreLink ? position.bestScoreLinks : position.links;

    return targetRootLinks.map((final link) {
      final move = symetryMove(link.move, moveListWithPosition.symetry);
      final root = api.BestPathNumNode(
        null,
        api.BestPathNumNodeValue(
          headMoves + move2String(move),
          headColor == api.TurnColor.black ? api.TurnColor.white : api.TurnColor.black,
        ),
      );
      _buildTree(root, maxDepth, enableToPrintMovesOnBuildingTree);
      return api.BestPathNumWithLink(
        root.value.bestPathNumOfBlack,
        root.value.bestPathNumOfWhite,
        link,
        move,
        root,
      );
    }).toList();
  }

  /// See: [computeBestPathNumWithLink]
  ///
  /// you can get BestPathNumWithLink one by one.
  @experimental
  Stream<api.BestPathNumWithLink> streamOfBestPathNumWithLink({
    required final int level,
    final bool onlyBestScoreLink = true,
    final bool enableToPrintMovesOnBuildingTree = false,
  }) async* {
    final headMoves = edaxGetMoves();
    final maxDepth = headMoves.length + level * 2;
    if (headMoves.isEmpty || headMoves.length >= maxDepth) return;

    final headColor = edaxGetCurrentPlayer();
    final moveListWithPosition = edaxGetBookMoveWithPositionByMoves(headMoves);
    final position = moveListWithPosition.position;
    final targetRootLinks = onlyBestScoreLink ? position.bestScoreLinks : position.links;

    for (final link in targetRootLinks) {
      final move = symetryMove(link.move, moveListWithPosition.symetry);
      final root = api.BestPathNumNode(
        null,
        api.BestPathNumNodeValue(
          headMoves + move2String(move),
          headColor == api.TurnColor.black ? api.TurnColor.white : api.TurnColor.black,
        ),
      );
      _buildTree(root, maxDepth, enableToPrintMovesOnBuildingTree);
      yield api.BestPathNumWithLink(
        root.value.bestPathNumOfBlack,
        root.value.bestPathNumOfWhite,
        link,
        move,
        root,
      );
    }
  }

  void _buildTree(final api.BestPathNumNode parent, final int maxDepth, final bool enableToPrintMovesOnBuildingTree) {
    if (parent.value.moves.length >= maxDepth) {
      // On edge, reagard (1,1) .
      parent.value.bestPathNumOfBlack = 1;
      parent.value.bestPathNumOfWhite = 1;
      return;
    }
    final moveListWithPosition = edaxGetBookMoveWithPositionByMoves(parent.value.moves);
    final position = moveListWithPosition.position;
    if (position.links.isEmpty) {
      // On edge, reagard (1,1) .
      parent.value.bestPathNumOfBlack = 1;
      parent.value.bestPathNumOfWhite = 1;
      return;
    }

    final addedNodeList = position.bestScoreLinks.map((final link) {
      final move = symetryMove(link.move, moveListWithPosition.symetry);
      final node = api.BestPathNumNode(
        parent,
        api.BestPathNumNodeValue(
          parent.value.moves + move2String(move),
          parent.value.currentColor == api.TurnColor.black ? api.TurnColor.white : api.TurnColor.black,
        ),
      );
      if (enableToPrintMovesOnBuildingTree) print(node.value.moves); // ignore: avoid_print
      _buildTree(node, maxDepth, enableToPrintMovesOnBuildingTree);
      return node;
    });
    for (final addedNode in addedNodeList) {
      parent.children.add(addedNode);
      if (parent.value.currentColor == api.TurnColor.black) {
        parent.value.bestPathNumOfWhite += addedNode.value.bestPathNumOfWhite;
        parent.value.bestPathNumOfBlack = min(parent.value.bestPathNumOfBlack, addedNode.value.bestPathNumOfBlack);
      } else {
        parent.value.bestPathNumOfBlack += addedNode.value.bestPathNumOfBlack;
        parent.value.bestPathNumOfWhite = min(parent.value.bestPathNumOfWhite, addedNode.value.bestPathNumOfWhite);
      }
    }
  }

  /// close dll
  ///
  /// FIXME: this is workaround Function.
  /// See: https://github.com/dart-lang/sdk/issues/40159
  ///
  /// After you call this, if you use edax command, you have to recreate [LibEdax] instance.
  @experimental
  void closeDll() => _dlCloseFunc(dylib.handle);

  int Function(Pointer<Void>) get _dlCloseFunc {
    final funcName = Platform.isWindows ? 'FreeLibrary' : 'dlclose';
    return _stdlib.lookup<NativeFunction<Int32 Function(Pointer<Void>)>>(funcName).asFunction();
  }

  // See: https://github.com/dart-lang/ffi/blob/f3346299c55669cc0db48afae85b8110088bf8da/lib/src/allocation.dart#L8-L11
  DynamicLibrary get _stdlib => Platform.isWindows ? DynamicLibrary.open('kernel32.dll') : DynamicLibrary.process();
}

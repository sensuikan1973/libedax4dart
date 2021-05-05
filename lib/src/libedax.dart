import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'best_path_num_with_link.dart';
import 'bindings/bindings.dart';
import 'bindings/structs/board.dart' as c_board;
import 'bindings/structs/hint.dart' as c_hint;
import 'bindings/structs/hint_list.dart' as c_hintlist;
import 'bindings/structs/move.dart' as c_move;
import 'bindings/structs/move_list.dart' as c_movelist;
import 'bindings/structs/position.dart' as c_position;
import 'board.dart';
import 'constants.dart';
import 'hint.dart';
import 'link.dart';
import 'move.dart';
import 'move_list_with_position.dart';
import 'position.dart';
import 'score.dart';
import 'util.dart';

@immutable
class LibEdax {
  LibEdax([String dllPath = '']) : _bindings = LibEdaxBindings(dllPath);

  final LibEdaxBindings _bindings;

  /// Initialize libedax.
  ///
  /// Be careful that the first argument in [args] is ignored.
  /// ```dart
  /// final edax = LibEdax();
  /// edax.libedaxInitialize(['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16']);
  /// ```
  ///
  /// If you want to know more, See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
  void libedaxInitialize([List<String> args = const []]) {
    final argsPointers = args.map((arg) => arg.toNativeUtf8()).toList();
    final pointerPointer = calloc<Pointer<Uint8>>(argsPointers.length);
    for (var k = 0; k < argsPointers.length; k++) {
      pointerPointer[k] = argsPointers[k].cast<Uint8>();
    }
    _bindings.libedaxInitialize(args.length, pointerPointer);
    calloc.free(pointerPointer);
  }

  /// Terminate libedax.
  void libedaxTerminate() => _bindings.libedaxTerminate();

  /// close dll
  ///
  /// After you call this, if you use edax command, you have to recreate [LibEdax] instance.
  @experimental
  void closeDll() => _bindings.closeDll();

  /// Init board.
  void edaxInit() => _bindings.edaxInit();

  /// Init board based on setboard command.
  void edaxNew() => _bindings.edaxNew();

  /// Undo.
  ///
  /// If mode is 0 or 2, undo until human's turn.
  void edaxUndo() => _bindings.edaxUndo();

  /// Redo.
  ///
  /// If mode is 0 or 2, redo until human's turn.
  void edaxRedo() => _bindings.edaxRedo();

  /// Set mode.
  /// * 0: Human(B) vs  Edax(W)
  /// * 1: Edax(B)  vs  Human(W)
  /// * 2: Edax(B)  vs  Edax(W)
  /// * 3: Human(B) vs  Human(W)
  void edaxMode(int mode) => _bindings.edaxMode(mode);

  /// Flip vertical.
  void edaxVmirror() => _bindings.edaxVmirror();

  /// Rotate.
  ///
  /// angle: 90 or 180 or 270.
  void edaxRotate(int angle) {
    if (![90, 180, 270].contains(angle)) throw Exception('angle of edaxRotate supports only 90,180,270');
    _bindings.edaxRotate(angle);
  }

  /// Play moves.
  ///
  /// you can pass Lower case or Upper case. `f5F6F6g7` is OK. <br>
  /// you can also pass opening name. (e.g. `brightwell`) <br>
  /// opening names are listed on [opening.c](https://github.com/lavox/edax-reversi/blob/libedax/src/opening.c).
  void edaxPlay(String moves) => _bindings.edaxPlay(moves.toNativeUtf8());

  /// Let edax move.
  void edaxGo() => _bindings.edaxGo();

  /// Get hint.
  List<Hint> edaxHint(int n) {
    final dst = calloc<c_hintlist.HintList>();
    _bindings.edaxHint(n, dst);
    final hintList = dst.ref;
    final result = <Hint>[];
    for (var k = 0; k < hintList.n_hints; k++) {
      final h = hintList.hint[k + 1];
      result.add(Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move));
    }
    calloc.free(dst);
    return result;
  }

  /// Get book move list.
  List<Move> edaxGetBookMove() {
    final dst = calloc<c_movelist.MoveList>();
    _bindings.edaxGetBookMove(dst);
    final moveList = dst.ref;
    final result = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      result.add(Move(m.flipped, m.x, m.score, m.cost));
    }
    calloc.free(dst);
    return result;
  }

  /// Get book move list with position.
  MoveListWithPosition edaxGetBookMoveWithPosition() {
    final dstM = calloc<c_movelist.MoveList>();
    final dstP = calloc<c_position.Position>();
    final symetry = _bindings.edaxGetBookMoveWithPosition(dstM, dstP);

    final moveList = dstM.ref;
    final resultMoveList = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      resultMoveList.add(Move(m.flipped, m.x, m.score, m.cost));
    }
    calloc.free(dstM);

    final pos = dstP.ref;
    final board = Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = Link(pos.leaf.score, pos.leaf.move);
    final links = <Link>[];
    for (var k = 0; k < pos.n_link; k++) {
      links.add(Link(pos.link.elementAt(k).ref.score, pos.link.elementAt(k).ref.move));
    }
    final score = Score(pos.score.value, pos.score.lower, pos.score.upper);
    final resultPosition = Position(
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

    return MoveListWithPosition(resultMoveList, resultPosition, symetry);
  }

  /// Get book move list with position by specified moves.
  MoveListWithPosition edaxGetBookMoveWithPositionByMoves(String moves) {
    final dstM = calloc<c_movelist.MoveList>();
    final dstP = calloc<c_position.Position>();
    final symetry = _bindings.edaxGetBookMoveWithPositionByMoves(moves.toNativeUtf8(), dstM, dstP);

    final moveList = dstM.ref;
    final resultMoveList = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      resultMoveList.add(Move(m.flipped, m.x, m.score, m.cost));
    }
    calloc.free(dstM);

    final pos = dstP.ref;
    final board = Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = Link(pos.leaf.score, pos.leaf.move);
    final links = <Link>[];
    for (var k = 0; k < pos.n_link; k++) {
      links.add(Link(pos.link.elementAt(k).ref.score, pos.link.elementAt(k).ref.move));
    }
    final score = Score(pos.score.value, pos.score.lower, pos.score.upper);
    final resultPosition = Position(
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

    return MoveListWithPosition(resultMoveList, resultPosition, symetry);
  }

  /// Prepare to get hint.
  ///
  /// __Call [edaxHintNext] after calling this function__.
  // TODO: implement exclude list if you need.
  void edaxHintPrepare() => _bindings.edaxHintPrepare(nullptr);

  /// Get a hint.
  ///
  /// __Call [edaxHintPrepare] before calling this function__. <br>
  /// If there are no more hints, `hint.isNoMove` will be true.
  Hint edaxHintNext() {
    final dst = calloc<c_hint.Hint>();
    _bindings.edaxHintNext(dst);
    final h = dst.ref;
    final result = Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move);
    calloc.free(dst);
    return result;
  }

  /// Get a hint.
  ///
  /// __Call [edaxHintPrepare] before calling this function__. <br>
  /// If there are no more hints, `hint.isNoMove` will be true. <br>
  /// __This function doesn't use Multi-PV search for analyze usecase. This can be faster than [edaxHintNext]__.
  Hint edaxHintNextNoMultiPvDepth() {
    final dst = calloc<c_hint.Hint>();
    _bindings.edaxHintNextNoMultiPvDepth(dst);
    final h = dst.ref;
    final result = Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move);
    calloc.free(dst);
    return result;
  }

  /// Stop edax search process, and set mode 3.
  void edaxStop() => _bindings.edaxStop();

  /// print version.
  void edaxVersion() => _bindings.edaxVersion();

  /// Play move.
  ///
  /// you can pass Lower case or Upper case. `f5` `F5` is OK. <br>
  /// if you want to switch turn when mobilicty count is 0, pass `MoveMark.passString`.
  void edaxMove(String move) => _bindings.edaxMove(move.toNativeUtf8());

  /// Set board from string.
  ///
  /// e.g. `-W----W--------------------WB------WBB-----W--------------------B`.
  /// * BLACK: `B`,`b`,`x`,`X`,`*`
  /// * WHITE: `o`,`O`,`w`,`W`
  /// * EMPTY: `-`,`.`
  ///
  /// Last char is turn.
  void edaxSetboard(String board) => _bindings.edaxSetboard(board.toNativeUtf8());

  /// Get the opening name of the current game, in English.
  ///
  /// e.g. `brightwell`, `tiger`, `rose`, ....
  String edaxOpening() => _bindings.edaxOpening().toDartString();

  /// Use book on `edaxGo`, `edaxHint`, `mode 2`.<br>
  /// default is on.
  void edaxBookOn() => _bindings.edaxBookOn();

  /// Don't use book on `edaxGo`, `edaxHint`, `mode 2`.
  void edaxBookOff() => _bindings.edaxBookOff();

  /// Set randomness on `edaxGo`, `mode 2`. <br>
  /// default is 0.
  ///
  /// edax will choose move with the randomness width.
  void edaxBookRandomness(int randomness) => _bindings.edaxBookRandomness(randomness);

  /// Create a new book.
  void edaxBookNew(int level, int depth) => _bindings.edaxBookNew(level, depth);

  /// Load book.
  void edaxBookLoad(String bookFile) => _bindings.edaxBookLoad(bookFile.toNativeUtf8());

  /// Show book.
  ///
  /// Probably, you should use [edaxGetBookMoveWithPosition()]. <br>
  /// See: https://github.com/sensuikan1973/libedax4dart/issues/46
  Position edaxBookShow() {
    final dstP = calloc<c_position.Position>();
    _bindings.edaxBookShow(dstP);

    final pos = dstP.ref;
    final board = Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = Link(pos.leaf.score, pos.leaf.move);
    final links = <Link>[];
    for (var k = 0; k < pos.n_link; k++) {
      links.add(Link(pos.link.elementAt(k).ref.score, pos.link.elementAt(k).ref.move));
    }
    final score = Score(pos.score.value, pos.score.lower, pos.score.upper);
    final result = Position(
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
  void edaxSetOption(String optionName, String val) =>
      _bindings.edaxSetOption(optionName.toNativeUtf8(), val.toNativeUtf8());

  /// Get current moves.
  String edaxGetMoves() {
    final moves = calloc<Uint8>(80 * 2 + 1);
    final result = _bindings.edaxGetMoves(moves).toDartString();
    calloc.free(moves);
    return result;
  }

  /// Check if the current game is over.
  bool edaxIsGameOver() => _bindings.edaxIsGameOver() == 1;

  /// Check if the current player can move.
  bool edaxCanMove() => _bindings.edaxCanMove() == 1;

  /// Get the last move.
  ///
  /// NOTE: you have to handle the case that noMove is true.
  Move edaxGetLastMove() {
    final moves = edaxGetMoves();
    if (moves.isEmpty) return const Move(0, MoveMark.noMove, 0, 0);

    final dst = calloc<c_move.Move>();
    _bindings.edaxGetLastMove(dst);
    final move = dst.ref;
    final result = Move(move.flipped, move.x, move.score, move.cost);
    calloc.free(dst);
    return result;
  }

  /// Get the current board.
  Board edaxGetBoard() {
    final dst = calloc<c_board.Board>();
    _bindings.edaxGetBoard(dst);
    final board = dst.ref;
    final result = Board(board.player, board.opponent);
    calloc.free(dst);
    return result;
  }

  /// Get the current player.
  /// * 0: BLACK
  /// * 1: WHITE
  int edaxGetCurrentPlayer() => _bindings.edaxGetCurrentPlayer();

  /// Get the current number of discs.
  int edaxGetDisc(int color) => _bindings.edaxGetDisc(color);

  /// Get the legal move count.
  int edaxGetMobilityCount(int color) => _bindings.edaxGetMobilityCount(color);

  /// Count bit.
  int popCount(int bit) => _bindings.bitCount(bit);

  /// Compute the indicator of efficiency to win, which means the minimum number you should memorize on the situation both of players always choose one of the best move list.
  ///
  /// [level] is dig depth.
  /// If [onlyBestScoreLink] is true, only compute the best score links on the current moves.
  ///
  /// This is a Dart level function, and unique feature to libedax4dart.
  ///
  /// You can see the graph of tree generated by this function, with using `BestPathNumWithLink.root.exportGraphvizDotFile()`. <br>
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
  /// * The depth of this feature depends on your book.
  /// * The moves which meet up with anoter moves is counted respectively.
  ///   * btw, symmetric moves is counted 1 because of edax book structure.
  /// * O(k^N). slow.
  ///   * TODO(developer): consider following implementation.
  ///     * isolation.
  ///     * separation with prepare function and execute on by one function.
  ///     * save tree data on local.
  @experimental
  List<BestPathNumWithLink> computeBestPathNumWithLink({required int level, bool onlyBestScoreLink = true}) {
    final headMoves = edaxGetMoves();
    final maxDepth = headMoves.length + level * 2;
    if (headMoves.isEmpty || headMoves.length >= maxDepth) return [];

    final headColor = edaxGetCurrentPlayer();
    final moveListWithPosition = edaxGetBookMoveWithPositionByMoves(headMoves);
    final position = moveListWithPosition.position;
    final targetRootLinks = onlyBestScoreLink ? position.bestScoreLinks : position.links;

    // TODO: consider isolation.
    // TODO: save tree data on local.
    return targetRootLinks.map((link) {
      final move = symetryMove(link.move, moveListWithPosition.symetry);
      final root = BestPathNumNode(
        null,
        BestPathNumNodeValue(
          headMoves + move2String(move),
          headColor == TurnColor.black ? TurnColor.white : TurnColor.black,
        ),
      );
      _buildTree(root, maxDepth);
      return BestPathNumWithLink(
        root.value.bestPathNumOfBlack,
        root.value.bestPathNumOfWhite,
        link,
        move,
        root,
      );
    }).toList();
  }

  void _buildTree(BestPathNumNode parent, int maxDepth) {
    final moveListWithPosition = edaxGetBookMoveWithPositionByMoves(parent.value.moves);
    final position = moveListWithPosition.position;
    if (position.links.isEmpty || parent.value.moves.length >= maxDepth) {
      // On edge, reagard (1,1) .
      parent.value.bestPathNumOfBlack = 1;
      parent.value.bestPathNumOfWhite = 1;
      return;
    }

    final addedNodeList = position.bestScoreLinks.map((link) {
      final move = symetryMove(link.move, moveListWithPosition.symetry);
      final node = BestPathNumNode(
        parent,
        BestPathNumNodeValue(
          parent.value.moves + move2String(move),
          parent.value.currentColor == TurnColor.black ? TurnColor.white : TurnColor.black,
        ),
      );
      _buildTree(node, maxDepth);
      return node;
    });
    for (final addedNode in addedNodeList) {
      parent.children.add(addedNode);
      if (parent.value.currentColor == TurnColor.black) {
        parent.value.bestPathNumOfWhite += addedNode.value.bestPathNumOfWhite;
        parent.value.bestPathNumOfBlack = min(parent.value.bestPathNumOfBlack, addedNode.value.bestPathNumOfBlack);
      } else {
        parent.value.bestPathNumOfBlack += addedNode.value.bestPathNumOfBlack;
        parent.value.bestPathNumOfWhite = min(parent.value.bestPathNumOfWhite, addedNode.value.bestPathNumOfWhite);
      }
    }
  }
}

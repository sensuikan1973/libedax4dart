import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'bindings/bindings.dart';
import 'bindings/structs/board.dart' as c_board;
import 'bindings/structs/hint.dart' as c_hint;
import 'bindings/structs/hint_list.dart' as c_hintlist;
import 'bindings/structs/move.dart' as c_move;
import 'bindings/structs/move_list.dart' as c_movelist;
import 'bindings/structs/position.dart' as c_position;
import 'board.dart';
import 'hint.dart';
import 'link.dart';
import 'move.dart';
import 'move_list_with_position.dart';
import 'position.dart';
import 'score.dart';

@immutable
class LibEdax {
  LibEdax([String dllDir = '']) : _bindings = LibEdaxBindings(dllDir);

  final LibEdaxBindings _bindings;

  /// Initialize libedax.
  ///
  /// Be careful that the first argument in [args] is ignored.
  /// ```dart
  /// const edax = LibEdax();
  /// edax.libedaxInitialize(['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16']);
  /// ```
  ///
  /// If you want to know more, See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
  void libedaxInitialize([List<String> args = const []]) {
    final argsPointers = args.map(Utf8.toUtf8).toList();
    final pointerPointer = allocate<Pointer<Utf8>>(count: argsPointers.length);
    for (var k = 0; k < argsPointers.length; k++) {
      pointerPointer[k] = argsPointers[k];
    }
    _bindings.libedaxInitialize(args.length, pointerPointer);
    free(pointerPointer);
  }

  /// Terminate libedax.
  void libedaxTerminate() => _bindings.libedaxTerminate();

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

  /// Play moves.
  ///
  /// you can pass Lower case or Upper case. `f5F6F6g7` is OK. <br>
  /// you can also pass opening name. (e.g. `brightwell`) <br>
  /// opening names are listed on [opening.c](https://github.com/lavox/edax-reversi/blob/libedax/src/opening.c).
  void edaxPlay(String moves) => _bindings.edaxPlay(Utf8.toUtf8(moves));

  /// Let edax move.
  void edaxGo() => _bindings.edaxGo();

  /// Get hint.
  List<Hint> edaxHint(int n) {
    final dst = allocate<c_hintlist.HintList>();
    _bindings.edaxHint(n, dst);
    final hintList = dst.ref;
    final result = <Hint>[];
    for (var k = 0; k < hintList.n_hints; k++) {
      final h = hintList.hint[k + 1];
      result.add(Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move));
    }
    free(dst);
    return result;
  }

  /// Get book move list.
  List<Move> edaxGetBookMove() {
    final dst = allocate<c_movelist.MoveList>();
    _bindings.edaxGetBookMove(dst);
    final moveList = dst.ref;
    final result = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      result.add(Move(m.flipped, m.x, m.score, m.cost));
    }
    free(dst);
    return result;
  }

  /// Get book move list with position.
  MoveListWithPosition edaxGetBookMoveWithPosition() {
    final dstM = allocate<c_movelist.MoveList>();
    final dstP = allocate<c_position.Position>();
    _bindings.edaxGetBookMoveWithPosition(dstM, dstP);

    final moveList = dstM.ref;
    final resultMoveList = <Move>[];
    for (var k = 0; k < moveList.n_moves; k++) {
      final m = moveList.move[k + 1];
      resultMoveList.add(Move(m.flipped, m.x, m.score, m.cost));
    }
    free(dstM);

    final pos = dstP.ref;
    final board = Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = Link(pos.leaf.score, pos.leaf.move);
    final link = pos.n_link > 1 ? Link(pos.link.ref.score, pos.link.ref.move) : null;
    final score = Score(pos.score.value, pos.score.lower, pos.score.upper);
    final resultPosition = Position(
      board,
      leaf,
      link,
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
    free(dstP);

    return MoveListWithPosition(resultMoveList, resultPosition);
  }

  /// Prepare to get hint.
  ///
  /// __Call edaxHintNext after calling this function__.
  // TODO: implement exclude list if you need.
  void edaxHintPrepare() => _bindings.edaxHintPrepare(nullptr);

  /// Get a hint.
  ///
  /// __Call edaxHintPrepare before calling this function__. <br>
  /// If there are no more hints, hint will be noMove.
  Hint edaxHintNext() {
    final dst = allocate<c_hint.Hint>();
    _bindings.edaxHintNext(dst);
    final h = dst.ref;
    final result = Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move);
    free(dst);
    return result;
  }

  /// Get a hint.
  ///
  /// __Call edaxHintPrepare before calling this function__. <br>
  /// If there are no more hints, hint will be noMove.
  /// __This function use Multi-PV search for analyze usecase. This may be slower than edaxHintNext__.
  Hint edaxHintNextNoMultiPvDepth() {
    final dst = allocate<c_hint.Hint>();
    _bindings.edaxHintNextNoMultiPvDepth(dst);
    final h = dst.ref;
    final result = Hint(h.depth, h.selectivity, h.move, h.score, h.upper, h.lower, h.book_move);
    free(dst);
    return result;
  }

  /// Stop edax search process, and set mode 3.
  void edaxStop() => _bindings.edaxStop();

  /// print version.
  void edaxVersion() => _bindings.edaxVersion();

  /// Play move.
  ///
  /// you can pass Lower case or Upper case. `f5` `F5` is OK.
  void edaxMove(String move) => _bindings.edaxMove(Utf8.toUtf8(move));

  /// Set board from string.
  ///
  /// e.g. `-W----W--------------------WB------WBB-----W--------------------B`.
  /// * BLACK: `B`,`b`,`x`,`X`,`*`
  /// * WHITE: `o`,`O`,`w`,`W`
  /// * EMPTY: `-`,`.`
  ///
  /// Last char is turn.
  void edaxSetboard(String board) => _bindings.edaxSetboard(Utf8.toUtf8(board));

  /// Get the opening name of the current game, in English.
  ///
  /// e.g. `brightwell`, `tiger`, `rose`, ....
  String edaxOpening() => Utf8.fromUtf8(_bindings.edaxOpening());

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

  /// Show book.
  Position edaxBookShow() {
    final dstP = allocate<c_position.Position>();
    final pos = dstP.ref;
    final board = Board(pos.board[0].player, pos.board[0].opponent);
    final leaf = Link(pos.leaf.score, pos.leaf.move);
    final link = pos.n_link > 1 ? Link(pos.link.ref.score, pos.link.ref.move) : null;
    final score = Score(pos.score.value, pos.score.lower, pos.score.upper);
    final result = Position(
      board,
      leaf,
      link,
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
    free(dstP);
    return result;
  }

  /// Set option.
  ///
  /// See [Options Document](https://sensuikan1973.github.io/edax-reversi/structOptions.html).
  void edaxSetOption(String optionName, String val) =>
      _bindings.edaxSetOption(Utf8.toUtf8(optionName), Utf8.toUtf8(val));

  /// Check if the current game is over.
  String edaxGetMoves() {
    final moves = allocate<Uint8>(count: 80 * 2 + 1);
    final result = Utf8.fromUtf8(_bindings.edaxGetMoves(moves));
    free(moves);
    return result;
  }

  /// Check if the current game is over.
  bool edaxIsGameOver() => _bindings.edaxIsGameOver() == 1;

  /// Check if the current player can move.
  bool edaxCanMove() => _bindings.edaxCanMove() == 1;

  /// Get the last move.
  Move edaxGetLastMove() {
    final dst = allocate<c_move.Move>();
    _bindings.edaxGetLastMove(dst);
    final move = dst.ref;
    final result = Move(move.flipped, move.x, move.score, move.cost);
    free(dst);
    return result;
  }

  /// Get the current board.
  Board edaxGetBoard() {
    final dst = allocate<c_board.Board>();
    _bindings.edaxGetBoard(dst);
    final board = dst.ref;
    final result = Board(board.player, board.opponent);
    free(dst);
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
}

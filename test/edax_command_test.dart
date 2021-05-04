import 'dart:io';

import 'package:libedax4dart/libedax4dart.dart';
import 'package:libedax4dart/src/constants.dart';
import 'package:test/test.dart';

const _testBookFile = './resources/test_book.dat';

void main() {
  test('open and close DynamicLibrary', () {
    final libedax = LibEdax(); // open internally
    libedax.edaxVersion(); // ignore: cascade_invocations

    libedax.closeDll(); // ignore: cascade_invocations
    // libedax.edaxVersion(); => CRASH

    final libedax2 = LibEdax(); // open internally
    libedax2.edaxVersion(); // ignore: cascade_invocations
  });

  group('with a new book (follow default: data/book.dat)', () {
    test('initialize without args, and set option', () {
      LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxVersion()
        ..edaxSetOption('level', '15')
        ..libedaxTerminate();
    });

    test('get last move with no moves', () {
      final edax = LibEdax()
        ..libedaxInitialize()
        ..edaxNew();
      final lastMove = edax.edaxGetLastMove();
      expect(lastMove.isNoMove, true);
      edax.libedaxTerminate();
    });

    test('play "horse" opening', () {
      final edax = LibEdax()
        ..libedaxInitialize()
        ..edaxNew()
        ..edaxBookOff()
        ..edaxBookOn()
        ..edaxPlay('f5d6c5f4d3')
        ..edaxVmirror()
        ..edaxRotate(180);
      expect(edax.edaxOpening(), 'horse');
      edax
        ..edaxUndo()
        ..edaxRedo();
      expect(edax.edaxOpening(), 'horse');
      edax.libedaxTerminate();
    });

    test('board useful getter', () {
      final edax = LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxPlay('f5d6c5f4d3');
      final board = edax.edaxGetBoard();
      expect(edax.edaxGetCurrentPlayer(), TurnColor.white);
      expect(board.squaresOfPlayer, [29, 36, 43]);
      expect(board.squareStringsOfPlayer, ['f4', 'e5', 'd6']);
      expect(board.squaresOfOpponent, [19, 27, 28, 34, 35, 37]);
      expect(board.squareStringsOfOpponent, ['d3', 'd4', 'e4', 'c5', 'd5', 'f5']);
      edax.libedaxTerminate();
    });

    test('setBoard', () {
      const boardString = '-W----W--------------------WB------WBB-----W--------------------B';
      final edax = LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxSetboard(boardString);
      expect(edax.edaxGetDisc(TurnColor.white), 'W'.allMatches(boardString).length);
      expect(edax.edaxGetDisc(TurnColor.black), 'B'.allMatches(boardString).length - 1);
      expect(edax.edaxGetCurrentPlayer(), TurnColor.black);
      edax.libedaxTerminate();
    });

    test('check mobility count', () {
      final edax = LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxBookRandomness(2)
        ..edaxGo();
      expect(edax.edaxGetMobilityCount(TurnColor.white), 3);
      edax.libedaxTerminate();
    });

    test('play a short game until game over', () {
      const initParams = ['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16'];
      final edax = LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit()
        ..edaxMode(3) // human vs human
        ..edaxMove('f5');
      expect(edax.edaxCanMove(), true);
      expect(edax.edaxGetCurrentPlayer(), TurnColor.white);
      expect(edax.edaxIsGameOver(), false);
      edax.edaxPlay('d6C5F4e3f6g5e6e7'); // famous perfect game. BLACK win.
      expect(edax.edaxIsGameOver(), true);
      expect(edax.edaxGetDisc(TurnColor.white), 0);
      expect(edax.edaxGetDisc(TurnColor.black), 13);
      final board = edax.edaxGetBoard();
      expect(board.playerRadix16String, List<String>.filled(16, '0').join()); // white bitboard
      expect(board.opponentRadix16String, '0010387c38100000'); // black bitboard
      stdout.writeln(board.prettyString(edax.edaxGetCurrentPlayer()));
      expect(edax.edaxCanMove(), false);
      final lastMove = edax.edaxGetLastMove();
      expect(lastMove.moveString, 'e7');
      expect(lastMove.isNoMove, false);
      expect(lastMove.isPass, false);
      expect(edax.edaxGetMoves(), 'F5d6C5f4E3f6G5e6E7'); // edax return moves with upper scale B move and lower scale W.
      edax.libedaxTerminate();
    });

    test('book new & get book move', () {
      final edax = LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxBookNew(21, 24); // create shallow book
      final moveList = edax.edaxGetBookMove();
      expect(moveList.length, 1);
      expect(moveList.first.moveString, 'd3');
      edax.libedaxTerminate();
    });
  });

  group('with fixed book. See: resources/test_book_show.txt', () {
    test('load book', () {
      LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxBookLoad(_testBookFile)
        ..edaxMove('f5')
        ..libedaxTerminate();
    });

    test('get book move with position', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit();
      final result = edax.edaxGetBookMoveWithPosition();
      expect(result.position.nLines, 264 + 16);
      expect(result.position.score.value, 0);
      expect(result.position.score.lower, -2);
      expect(result.position.score.upper, 2);
      expect(result.moveList.length, 4);
      expect(result.moveList.where((move) => move.score == 0).length, 4); // all moves are +0
      expect(result.moveList.first.moveString, 'd3'); // D3
      expect(result.moveList[1].moveString, 'c4'); // C4
      expect(result.position.board.player,
          34628173824); // 0000 0000 0000 0000 0000 0000 0000 1000 0001 0000 0000 0000 0000 0000 0000 0000
      expect(result.position.nLink, 4);
      expect(result.position.links.length, 4);
      expect(move2String(result.position.links.first.move), 'd3');
      expect(move2String(result.position.links[1].move), 'c4');
      expect(move2String(result.position.links[2].move), 'f5');
      expect(move2String(result.position.links[3].move), 'e6');

      edax.edaxPlay('f5f6');
      final resultAfterF5F6 = edax.edaxGetBookMoveWithPosition();
      expect(resultAfterF5F6.position.score.value, 1);
      expect(resultAfterF5F6.position.score.lower, -2);
      expect(resultAfterF5F6.position.score.upper, 2);
      expect(resultAfterF5F6.moveList.length, 2);
      expect(resultAfterF5F6.moveList.first.moveString, 'e6');
      expect(resultAfterF5F6.moveList.first.scoreString, '+1');
      expect(resultAfterF5F6.moveList[1].moveString, 'c4');
      expect(resultAfterF5F6.moveList[1].scoreString, '-7');
      expect(resultAfterF5F6.position.nLink, 1);
      expect(resultAfterF5F6.position.links.length, 1);
      expect(move2String(resultAfterF5F6.position.links.first.move), 'c4');
      expect(resultAfterF5F6.position.bestScoreLinks.length, 1);
      expect(move2String(resultAfterF5F6.position.bestScoreLinks.first.move), 'c4');
      edax.libedaxTerminate();
    });

    test('get book move with position by moves', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit();
      final resultAfterF5F6 = edax.edaxGetBookMoveWithPositionByMoves('f5f6');
      expect(resultAfterF5F6.position.score.value, 1);
      expect(resultAfterF5F6.position.score.lower, -2);
      expect(resultAfterF5F6.position.score.upper, 2);
      expect(resultAfterF5F6.moveList.length, 2);
      expect(resultAfterF5F6.moveList.first.moveString, 'e6');
      expect(resultAfterF5F6.moveList.first.scoreString, '+1');
      expect(resultAfterF5F6.moveList[1].moveString, 'c4');
      expect(resultAfterF5F6.moveList[1].scoreString, '-7');
      expect(resultAfterF5F6.position.nLink, 1);
      expect(resultAfterF5F6.position.links.length, 1);
      expect(move2String(resultAfterF5F6.position.links.first.move), 'c4');
      expect(resultAfterF5F6.position.bestScoreLinks.length, 1);
      expect(move2String(resultAfterF5F6.position.bestScoreLinks.first.move), 'c4');

      expect(edax.edaxGetMoves(), ''); // real board is not played
      edax.libedaxTerminate();
    });

    test('get hints', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit();
      final hintList = edax.edaxHint(2);
      expect(hintList.length, 2);
      expect(hintList.first.moveString, 'd3');
      expect(hintList.first.score, 0);
      expect(hintList.first.scoreString, '0');
      expect(hintList.first.isBookMove, true);
      expect(hintList.first.isNoMove, false);
      expect(hintList.first.isPass, false);
      expect(hintList[1].score, lessThanOrEqualTo(1));
      edax.libedaxTerminate();
    });

    test('get hints one by one', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit()
        ..edaxPlay('f5')
        ..edaxHintPrepare();
      final moveList = ['f4', 'd6', 'f6'];
      final hint1 = edax.edaxHintNext();
      expect(hint1.moveString, isIn(moveList));
      final hint2 = edax.edaxHintNext();
      expect(hint2.moveString, isIn(moveList));
      final hint3 = edax.edaxHintNext();
      expect(hint3.moveString, isIn(moveList));
      expect(hint3.moveString, 'f4'); // f4. it's because f4 is the lowest score.
      expect(hint3.score, lessThan(0)); // mouse opening. BLACK has an advantage.
      final hint4 = edax.edaxHintNext();
      expect(hint4.move, MoveMark.noMove);
      expect(hint4.moveString, 'no move');

      edax
        ..edaxMove('f4')
        ..edaxHintPrepare();
      expect(edax.edaxHintNextNoMultiPvDepth().scoreString, '+4');
      edax.libedaxTerminate();
    });

    test('book show', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit();
      final position = edax.edaxBookShow();
      expect(position.nLines, 264 + 16);
      expect(position.score.value, 0);
      expect(position.score.lower, -2);
      expect(position.score.upper, 2);
      expect(position.board.player,
          34628173824); // 0000 0000 0000 0000 0000 0000 0000 1000 0001 0000 0000 0000 0000 0000 0000 0000
      expect(position.nLink, 4);
      expect(position.links.length, 4);
      expect(move2String(position.links.first.move), 'd3');
      expect(move2String(position.links[1].move), 'c4');
      expect(move2String(position.links[2].move), 'f5');
      expect(move2String(position.links[3].move), 'e6');

      edax.edaxPlay('f5f6');
      final positionAfterF5F6Move = edax.edaxBookShow();
      expect(positionAfterF5F6Move.nLink, 1);
      expect(positionAfterF5F6Move.links.length, 1);
      expect(move2String(positionAfterF5F6Move.links.first.move), 'c4');

      edax.libedaxTerminate();
    });

    group('computeBestPathNumWithLink', () {
      test('with no moves', () {
        const initParams = ['', '-book-file', _testBookFile];
        final edax = LibEdax()
          ..libedaxInitialize(initParams)
          ..edaxInit();
        final bestPathNumWithLink = edax.computeBestPathNumWithLink();
        expect(bestPathNumWithLink.isEmpty, true);

        edax.libedaxTerminate();
      });

      test('with moves', () {
        const initParams = ['', '-book-file', _testBookFile];
        final edax = LibEdax()
          ..libedaxInitialize(initParams)
          ..edaxInit()
          ..edaxPlay('f5f6');
        final bestPathNumWithLink = edax.computeBestPathNumWithLink();
        expect(bestPathNumWithLink.first.moveString, 'e6');
        expect(bestPathNumWithLink.first.bestPathNumOfBlack, 2);
        expect(bestPathNumWithLink.first.bestPathNumOfWhite, 2);
        expect(bestPathNumWithLink.isEmpty, false);

        edax.libedaxTerminate();
      });
    });

    group('util command', () {
      test('popCount', () {
        final edax = LibEdax();
        expect(edax.popCount(7), 3); // 0000 0111
        expect(edax.popCount(14), 3); // 0000 1110
        expect(edax.popCount(15), 4); // 0000 1111
        expect(edax.popCount(17), 2); // 0001 0001
      });
    });
  });
}

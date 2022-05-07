// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

const _testBookFile = './resources/test_book.dat';

void main() {
  test('wrong dll path', () {
    expect(() => LibEdax('foo/bar'), throwsArgumentError);
  });

  test('open and close DynamicLibrary', () {
    final edax = LibEdax(); // open internally
    edax.edaxVersion(); // ignore: cascade_invocations

    edax.closeDll(); // ignore: cascade_invocations
    // libedax.edaxVersion(); => CRASH

    LibEdax().edaxVersion();
  });

  group('with a new book (follow default: data/book.dat)', () {
    test('initialize without args, and set option', () {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxVersion()
        ..edaxSetOption('level', '15')
        ..edaxOptionsDump()
        ..libedaxTerminate();
    });

    test('print play', () {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxPlay('f5d6c5f4d3')
        ..edaxPlayPrint()
        ..libedaxTerminate();
    });

    test('fix book', () {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxBookFix()
        ..libedaxTerminate();
    });

    test('get last move with no moves', () {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax.edaxNew();
      final lastMove = edax.edaxGetLastMove();
      expect(lastMove.isNoMove, true);
      edax.libedaxTerminate();
    });

    test('play "horse" opening', () {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
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
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxPlay('f5d6c5f4d3');
      final board = edax.edaxGetBoard();
      final stringApplicableToSetboard =
          board.stringApplicableToSetboard(edax.edaxGetCurrentPlayer());
      expect(
        stringApplicableToSetboard,
        '-------------------*-------**O----**O*-----O--------------------W',
      );
      edax.edaxSetboard(stringApplicableToSetboard);
      expect(edax.edaxGetCurrentPlayer(), TurnColor.white);
      expect(board.squaresOfPlayer, [29, 36, 43]);
      expect(board.squareStringsOfPlayer, ['f4', 'e5', 'd6']);
      expect(board.squaresOfOpponent, [19, 27, 28, 34, 35, 37]);
      expect(
        board.squareStringsOfOpponent,
        ['d3', 'd4', 'e4', 'c5', 'd5', 'f5'],
      );
      stdout.writeln(board.prettyString(edax.edaxGetCurrentPlayer()));
      edax.libedaxTerminate();
    });

    test('setBoard', () {
      const boardString =
          '-O----O--------------------O*------O**-----O--------------------B';
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxSetboard(boardString);
      expect(
        edax.edaxGetDisc(TurnColor.white),
        ColorChar.white.allMatches(boardString).length,
      );
      expect(
        edax.edaxGetDisc(TurnColor.black),
        ColorChar.black.allMatches(boardString).length,
      );
      expect(edax.edaxGetCurrentPlayer(), TurnColor.black);
      edax.libedaxTerminate();
    });

    test('check mobility count', () {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxBookRandomness(2)
        ..edaxGo();
      expect(edax.edaxGetMobilityCount(TurnColor.white), 3);
      edax.libedaxTerminate();
    });

    test('play a short game until game over', () {
      const initParams = [
        '',
        '-eval-file',
        'data/eval.dat',
        '-book-file',
        'data/book.dat',
        '-level',
        '16'
      ];
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));
      edax
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
      expect(
        board.playerRadix16String,
        List<String>.filled(16, '0').join(),
      ); // white bitboard
      expect(board.opponentRadix16String, '0010387c38100000'); // black bitboard
      expect(edax.edaxCanMove(), false);
      final lastMove = edax.edaxGetLastMove();
      expect(lastMove.moveString, 'e7');
      expect(lastMove.isNoMove, false);
      expect(lastMove.isPass, false);
      expect(
        edax.edaxGetMoves(),
        'F5d6C5f4E3f6G5e6E7',
      ); // edax return moves with upper scale B move and lower scale W.
      edax.libedaxTerminate();
    });
  });

  group('with fixed book. See: resources/test_book_show.txt', () {
    test('load book', () {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxBookLoad(_testBookFile)
        ..edaxMove('f5')
        ..libedaxTerminate();
    });

    test('get book move', () async {
      final edax = LibEdax()..libedaxInitialize();
      sleep(const Duration(seconds: 1));
      edax.edaxInit();
      final moveList = edax.edaxGetBookMove();
      expect(moveList.length, 1);
      expect(moveList.first.moveString, 'd3');
      edax.libedaxTerminate();
    });

    test('get book move with position', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));
      edax.edaxInit();
      final result = edax.edaxGetBookMoveWithPosition();
      expect(result.position.nLines, 264 + 16);
      expect(result.position.score.value, 0);
      expect(result.position.score.lower, -2);
      expect(result.position.score.upper, 2);
      expect(result.moveList.length, 4);
      expect(
        result.moveList.where((final move) => move.score == 0).length,
        4,
      ); // all moves are +0
      expect(result.moveList.first.moveString, 'd3'); // D3
      expect(result.moveList[1].moveString, 'c4'); // C4
      expect(
        result.position.board.player,
        34628173824,
      ); // 0000 0000 0000 0000 0000 0000 0000 1000 0001 0000 0000 0000 0000 0000 0000 0000
      expect(result.position.nLink, 4);
      expect(result.position.links.length, 4);
      expect(result.position.links.first.moveString, 'd3');
      expect(result.position.links[1].moveString, 'c4');
      expect(result.position.links[2].moveString, 'f5');
      expect(result.position.links[3].moveString, 'e6');

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
      expect(resultAfterF5F6.position.links.first.moveString, 'c4');
      expect(resultAfterF5F6.position.bestScoreLinks.length, 1);
      expect(resultAfterF5F6.position.bestScoreLinks.first.moveString, 'c4');
      edax.libedaxTerminate();
    });

    test('get book move with position by moves', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));
      edax.edaxInit();
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
      expect(resultAfterF5F6.position.links.first.moveString, 'c4');
      expect(resultAfterF5F6.position.bestScoreLinks.length, 1);
      expect(resultAfterF5F6.position.bestScoreLinks.first.moveString, 'c4');

      expect(edax.edaxGetMoves(), ''); // real board is not played
      edax.libedaxTerminate();
    });

    test('get hints', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));
      edax.edaxInit();
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
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));
      edax
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
      expect(
        hint3.moveString,
        'f4',
      ); // f4. it's because f4 is the lowest score.
      expect(
        hint3.score,
        lessThan(0),
      ); // mouse opening. BLACK has an advantage.
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
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));
      edax.edaxInit();
      final position = edax.edaxBookShow();
      expect(position.nLines, 264 + 16);
      expect(position.score.value, 0);
      expect(position.score.lower, -2);
      expect(position.score.upper, 2);
      expect(
        position.board.player,
        34628173824,
      ); // 0000 0000 0000 0000 0000 0000 0000 1000 0001 0000 0000 0000 0000 0000 0000 0000
      expect(position.nLink, 4);
      expect(position.links.length, 4);
      expect(position.links.first.moveString, 'd3');
      expect(position.links[1].moveString, 'c4');
      expect(position.links[2].moveString, 'f5');
      expect(position.links[3].moveString, 'e6');
      expect(position.links.every((final l) => l.scoreString == '0'), true);

      edax.edaxPlay('f5f6');
      final positionAfterF5F6Move = edax.edaxBookShow();
      expect(positionAfterF5F6Move.nLink, 1);
      expect(positionAfterF5F6Move.links.length, 1);
      expect(positionAfterF5F6Move.links.first.moveString, 'c4');
      edax.libedaxTerminate();
    });

    test('book count bestpath', () {
      const initParams = ['', '-book-file', _testBookFile];
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));
      edax
        ..edaxInit()
        ..edaxMove('f5');
      final bestpathResult = edax.edaxBookCountBestpath(edax.edaxGetBoard());
      expect(bestpathResult.position.nPlayerBestpaths, 1);
      expect(bestpathResult.position.nOpponentBestpaths, 1);

      edax.edaxMove('f6');
      final bestpathResult2 = edax.edaxBookCountBestpath(edax.edaxGetBoard());
      expect(bestpathResult2.position.nPlayerBestpaths, 2);
      expect(bestpathResult2.position.nOpponentBestpaths, 1);
      edax
        ..edaxBookStopCountBestpath()
        ..libedaxTerminate();
    });

    test('play a short game with edax vs edax, and book store', () {
      const bookFile = 'data/book_store_test.dat';
      File(bookFile).deleteSync(); // ensure idempotence

      const initParams = ['', '-book-file', bookFile, '-level', '1'];
      final edax = LibEdax()..libedaxInitialize(initParams);
      sleep(const Duration(seconds: 1));

      const opening = 'f5f4f3';
      edax
        ..edaxInit()
        ..edaxPlay(opening);
      final position = edax.edaxGetBookMoveWithPosition().position;
      expect(position.nLink, 0);
      edax
        ..edaxMode(2) // edax vs edax
        ..edaxGo()
        ..edaxPlayPrint()
        ..edaxBookStore()
        ..edaxBookSave(bookFile)
        ..edaxMode(3) // human vs human
        ..edaxInit()
        ..edaxPlay(opening);
      final positionAfterLearning = edax.edaxGetBookMoveWithPosition().position;
      expect(positionAfterLearning.nLink, 1);
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
}

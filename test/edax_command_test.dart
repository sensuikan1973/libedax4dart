import 'dart:io';

import 'package:libedax4dart/libedax4dart.dart';
import 'package:libedax4dart/src/constants.dart';
import 'package:test/test.dart';

const testBookFile = './resources/test_book.dat';

void main() {
  tearDown(() {
    final sleepSec = Platform.environment['sleepSec'];
    if (sleepSec != null) sleep(Duration(seconds: int.parse(sleepSec)));
  });

  group('with a new book (follow default: data/book.dat)', () {
    test('initialize without args, and set option', () {
      const LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxVersion()
        ..edaxSetOption('level', '15')
        ..libedaxTerminate();
    });

    test('play "horse" opening', () {
      final edax = const LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxBookOn()
        ..edaxPlay('f5d6c5f4d3');
      expect(edax.edaxOpening(), 'horse');
      edax.libedaxTerminate();
    });

    test('setBoard', () {
      const boardString = '-W----W--------------------WB------WBB-----W--------------------B';
      final edax = const LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxSetboard(boardString);
      expect(edax.edaxGetDisc(TurnColor.white), 'W'.allMatches(boardString).length);
      expect(edax.edaxGetDisc(TurnColor.black), 'B'.allMatches(boardString).length - 1);
      expect(edax.edaxGetCurrentPlayer(), TurnColor.black);
      edax.libedaxTerminate();
    });

    test('check mobility count', () {
      final edax = const LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxBookRandomness(2)
        ..edaxGo();
      expect(edax.edaxGetMobilityCount(TurnColor.white), 3);
      edax.libedaxTerminate();
    });

    test('play a short game until game over', () {
      const initParams = ['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16'];
      final edax = const LibEdax()
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
      expect(_radix16board(board.player), List<String>.filled(16, '0').join()); // white bitboard
      expect(_radix16board(board.opponent), '0010387c38100000'); // black bitboard
      print(board.prettyString(edax.edaxGetCurrentPlayer())); // ignore: avoid_print
      expect(edax.edaxCanMove(), false);
      final lastMove = edax.edaxGetLastMove();
      expect(lastMove.x, 52); // e7 is 52th. (a1 is 0th)
      expect(lastMove.isNoMove, false);
      expect(lastMove.isPass, false);
      expect(edax.edaxGetMoves(), 'F5d6C5f4E3f6G5e6E7'); // edax return moves with upper scale B move and lower scale W.
      edax.libedaxTerminate();
    });

    test('book new & get book move', () {
      final edax = const LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxBookNew(21, 24); // create shallow book
      final moveList = edax.edaxGetBookMove();
      expect(moveList.length, 1);
      expect(moveList.first.x, 19); // when book new, firstly book has "D3" position.
      edax.libedaxTerminate();
    });
  });

  group('with fixed book. See: resources/test_book_show.txt', () {
    test('get book move with position', () {
      const initParams = ['', '-book-file', testBookFile];
      final edax = const LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit();
      final result = edax.edaxGetBookMoveWithPosition();
      expect(result.position.nLines, 264 + 16);
      expect(result.position.score.value, 0);
      expect(result.position.score.lower, -2);
      expect(result.position.score.upper, 2);
      expect(result.moveList.length, 4);
      expect(result.moveList.where((move) => move.score == 0).length, 4); // all moves are +0
      expect(result.moveList.first.x, 19); // D3
      expect(result.moveList[1].x, 26); // C4
      expect(result.position.board.player,
          34628173824); // 0000 0000 0000 0000 0000 0000 0000 1000 0001 0000 0000 0000 0000 0000 0000 0000
      edax.edaxMove('f5');
      final resultF5 = edax.edaxGetBookMoveWithPosition();
      expect(resultF5.position.score.value, 0);
      expect(resultF5.position.score.lower, -2);
      expect(resultF5.position.score.upper, 2);
      expect(resultF5.moveList.length, 2);
      expect(resultF5.moveList.first.x, 45); // F6
      expect(resultF5.moveList.first.score, -1);
      expect(resultF5.moveList[1].x, 43); // D6
      expect(resultF5.moveList[1].score, 0);
      edax.libedaxTerminate();
    });

    test('get hints', () {
      const initParams = ['', '-book-file', testBookFile];
      final edax = const LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit();
      final hintList = edax.edaxHint(2);
      expect(hintList.length, 2);
      expect(hintList.first.move, 19);
      expect(hintList.first.score, 0);
      expect(hintList[1].score, lessThanOrEqualTo(1));
      edax.libedaxTerminate();
    });

    test('get hints one by one', () {
      const initParams = ['', '-book-file', testBookFile];
      final edax = const LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit()
        ..edaxPlay('f5')
        ..edaxHintPrepare();
      final moveList = [29 /*f4*/, 43 /*d6*/, 45 /*f6*/];
      final hint1 = edax.edaxHintNext();
      expect(hint1.move, isIn(moveList));
      final hint2 = edax.edaxHintNext();
      expect(hint2.move, isIn(moveList));
      final hint3 = edax.edaxHintNext();
      expect(hint3.move, isIn(moveList));
      expect(hint3.move, 29); // f4. it's because f6 is the lowest score.
      expect(hint3.score, lessThan(0)); // mouse opening. BLACK has an advantage.
      final hint4 = edax.edaxHintNext();
      expect(hint4.move, MoveMark.noMove);
      edax.libedaxTerminate();
    });

    test('book show', () {
      const initParams = ['', '-book-file', testBookFile];
      final edax = const LibEdax()
        ..libedaxInitialize(initParams)
        ..edaxInit();
      final position = edax.edaxBookShow();
      expect(position.nLines, 264 + 16);
      expect(position.score.value, 0);
      expect(position.score.lower, -2);
      expect(position.score.upper, 2);
      expect(position.board.player,
          34628173824); // 0000 0000 0000 0000 0000 0000 0000 1000 0001 0000 0000 0000 0000 0000 0000 0000
      edax.libedaxTerminate();
    }, skip: 'unstable. TODO: investigae');
  });
}

// Convert bitboard to String with radix 16 and 0 padding.
// e.g. `0010387c38100000`.
String _radix16board(int bit) => bit.toRadixString(16).padLeft(16, '0');

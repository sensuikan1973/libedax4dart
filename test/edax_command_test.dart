import 'dart:io';

import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() {
    final sleepSec = Platform.environment['sleepSec'];
    if (sleepSec != null) sleep(Duration(seconds: int.parse(sleepSec)));
  });

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
    expect(edax.edaxGetDisc(edax.white), 'W'.allMatches(boardString).length);
    expect(edax.edaxGetDisc(edax.black), 'B'.allMatches(boardString).length - 1);
    expect(edax.edaxGetCurrentPlayer(), edax.black);
    edax.libedaxTerminate();
  });

  test('check mobility count', () {
    final edax = const LibEdax()
      ..libedaxInitialize()
      ..edaxInit()
      ..edaxBookRandomness(2)
      ..edaxGo();
    expect(edax.edaxGetMobilityCount(edax.white), 3);
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
    expect(edax.edaxGetCurrentPlayer(), edax.white);
    expect(edax.edaxIsGameOver(), false);
    edax.edaxPlay('d6C5F4e3f6g5e6e7'); // famous perfect game. BLACK win.
    expect(edax.edaxIsGameOver(), true);
    expect(edax.edaxGetDisc(edax.white), 0);
    expect(edax.edaxGetDisc(edax.black), 13);
    expect(_radix16board(edax.edaxGetBoard().player), List<String>.filled(16, '0').join()); // white bitboard
    expect(_radix16board(edax.edaxGetBoard().opponent), '0010387c38100000'); // black bitboard
    expect(edax.edaxCanMove(), false);
    expect(edax.edaxGetLastMove().x, 52); // e7 is 52th. (a1 is 0th)
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

  test('get hints', () {
    final edax = const LibEdax()
      ..libedaxInitialize()
      ..edaxInit();
    final hintList = edax.edaxHint(2);
    expect(hintList.length, 2);
    expect(hintList.first.move, 19); // when normal book, firstly book has "D3" position.
    expect(hintList.first.score, 1); // at first, the score is +1.
    expect(hintList[1].score, lessThanOrEqualTo(1)); // second score is
    edax.libedaxTerminate();
  });

  test('get hints one by one', () {
    final edax = const LibEdax()
      ..libedaxInitialize()
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
    expect(hint4.move, edax.noMove);
    edax.libedaxTerminate();
  });
}

// Convert bitboard to String with radix 16 and 0 padding.
// e.g. `0010387c38100000`.
String _radix16board(int bit) => bit.toRadixString(16).padLeft(16, '0');

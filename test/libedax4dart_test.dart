import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  test('initialize without args, and set option', () {
    const LibEdax()
      ..libedaxInitialize()
      ..edaxVersion()
      ..edaxSetOption('level', '15')
      ..libedaxTerminate();
  });

  test('play "horse" opening', () {
    final edax = const LibEdax()
      ..libedaxInitialize()
      ..edaxBookOn()
      ..edaxPlay('f5d6c5f4d3');
    expect(edax.edaxOpening(), 'horse');
    edax.libedaxTerminate();
  });

  test('setBoard', () {
    const boardString = '-W----W--------------------WB------WBB-----W--------------------B';
    final edax = const LibEdax()
      ..libedaxInitialize()
      ..edaxSetboard(boardString);
    expect(edax.edaxGetDisc(edax.white), 'W'.allMatches(boardString).length);
    expect(edax.edaxGetDisc(edax.black), 'B'.allMatches(boardString).length - 1);
    expect(edax.edaxGetCurrentPlayer(), edax.black);
    edax.libedaxTerminate();
  });

  test('check mobility count', () {
    final edax = const LibEdax()
      ..libedaxInitialize()
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
    expect(edax.edaxCanMove(), false);
    edax.libedaxTerminate();
  });
}

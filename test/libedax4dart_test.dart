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
      ..edaxPlay('f5d6c5f4d3');
    expect(edax.edaxOpening(), 'horse');
    edax.libedaxTerminate();
  });

  test('check mobility count', () {
    final edax = const LibEdax()
      ..libedaxInitialize()
      ..edaxGo();
    expect(edax.edaxGetMobilityCount(edax.white), 3);
    edax.libedaxTerminate();
  });

  test('check number of discs count', () {
    final edax = const LibEdax()
      ..libedaxInitialize()
      ..edaxGo();
    expect(edax.edaxGetDisc(edax.black), 4);
    expect(edax.edaxGetDisc(edax.white), 1);
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

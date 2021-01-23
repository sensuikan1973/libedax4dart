import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  test('echo', () {
    print('yeah'); // ignore: avoid_print
  });

  test('func with no arg', () {
    const LibEdax()
      ..libedaxInitialize()
      ..edaxInit()
      ..edaxVersion()
      ..edaxBookOn()
      ..edaxBookOff()
      ..libedaxTerminate();
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
    // expect(_radix16board(edax.edaxGetBoard().player), List<String>.filled(16, '0').join()); // white bitboard
    // expect(_radix16board(edax.edaxGetBoard().opponent), '0010387c38100000'); // black bitboard
    expect(edax.edaxCanMove(), false);
    // expect(edax.edaxGetLastMove().x, 52); // e7 is 52th. (a1 is 0th)
    // expect(edax.edaxGetMoves(), 'F5d6C5f4E3f6G5e6E7'); // edax return moves with upper scale B move and lower scale W.
    edax.libedaxTerminate();
  });

  // test('get book move', () {
  //   final edax = const LibEdax()
  //     ..libedaxInitialize()
  //     ..edaxInit()
  //     ..edaxBookNew(21, 24); // create shallow book
  //   final moveList = edax.edaxGetBookMove();
  //   expect(moveList.n_moves, 1);
  //   expect(moveList.move.length, 34); // edax return move list with legal move max size "32 + 2".
  //   expect(moveList.move[1].x, 19); // when book new, firstly book has "D3" position.
  //   edax.libedaxTerminate();
  // });
}

// Convert bitboard to String with radix 16 and 0 padding.
// e.g. `0010387c38100000`.
String _radix16board(int bit) => bit.toRadixString(16).padLeft(16, '0');

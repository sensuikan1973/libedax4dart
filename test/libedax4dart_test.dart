import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  test('initialize without args', () {
    const LibEdax()
      ..libedaxInitialize()
      ..edaxVersion()
      ..libedaxTerminate();
  });

  test('with mode 3 (human vs human), play a short game', () {
    const initParams = ['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16'];
    final edax = const LibEdax()
      ..libedaxInitialize(initParams)
      ..edaxInit()
      ..edaxMove('f5');
    expect(edax.edaxIsGameOver(), false);
    edax.edaxPlay('d6C5F4e3f6g5e6e7'); // famous perfect game. BLACK win.
    expect(edax.edaxIsGameOver(), true);
    edax.libedaxTerminate();
  });
}

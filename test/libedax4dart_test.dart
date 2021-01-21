import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

void main() {
  test('experimental test', () {
    const initParams = ['', '-eval-file', 'data/eval.dat', '-book-file', 'data/book.dat', '-level', '16'];
    const LibEdax()
      ..libedaxInitialize(initParams)
      ..edaxVersion()
      ..edaxInit()
      ..edaxNew()
      ..libedaxTerminate();
  });
}

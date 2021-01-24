import 'package:libedax4dart/libedax4dart.dart';
import 'package:test/test.dart';

const testBookFile = './resources/test_book.dat';

void main() {
  // pub run test . --tags exp
  group('experimental test for DEBUG', () {
    test('initialize without args', () {
      LibEdax()
        ..libedaxInitialize()
        ..edaxInit()
        ..edaxVersion()
        ..libedaxTerminate();
    });

    // test('initialize without args', () {
    //   LibEdax()
    //     ..libedaxInitialize()
    //     ..edaxInit()
    //     ..edaxVersion()
    //     ..libedaxTerminate();
    // });

    // test('initialize without args', () {
    //   LibEdax()
    //     ..libedaxInitialize()
    //     ..edaxInit()
    //     ..edaxVersion()
    //     ..libedaxTerminate();
    // });

    // test('initialize without args', () {
    //   LibEdax()
    //     ..libedaxInitialize()
    //     ..edaxInit()
    //     ..edaxVersion()
    //     ..libedaxTerminate();
    // });

    // test('initialize without args', () {
    //   LibEdax()
    //     ..libedaxInitialize()
    //     ..edaxInit()
    //     ..edaxVersion()
    //     ..libedaxTerminate();
    // });
  }, tags: 'exp');
}

import 'dart:io';

import 'package:libedax4dart/libedax4dart.dart';

void main() {
  // initialize
  const initParams = [
    '',
    '-book-file',
    './resources/test_book.dat',
    '-level',
    '16'
  ];
  final edax = LibEdax()
    ..libedaxInitialize(initParams)
    ..edaxInit()
    ..edaxOptionsDump();
  stdout.writeln(edax.edaxGetBoard().prettyString(edax.edaxGetCurrentPlayer()));

  /// play
  edax
    ..edaxPlay('f5f6f7g7')
    ..edaxPlayPrint();

  stdout
    ..writeln(edax.edaxGetBoard().prettyString(edax.edaxGetCurrentPlayer()))
    ..writeln('moves: ${edax.edaxGetMoves()}')
    ..writeln('is game over ?: ${edax.edaxIsGameOver() ? 'YES' : 'NO'}')
    ..writeln('can move ?: ${edax.edaxCanMove() ? 'YES' : 'NO'}')
    ..writeln('BLACK discs: ${edax.edaxGetDisc(TurnColor.black)}')
    ..writeln('White discs: ${edax.edaxGetDisc(TurnColor.white)}');

  /// get hints
  final hintList = edax.edaxHint(2);
  stdout
    ..writeln(
      '1st move: ${hintList.first.moveString}, ${hintList.first.scoreString}',
    )
    ..writeln(
      '2nd move: ${hintList[1].moveString}, ${hintList[1].scoreString}',
    );

  // NOTE: If you use another command, See: https://sensuikan1973.github.io/libedax4dart/libedax4dart/LibEdax-class.html
}

# 5.10.0

upgrade dependencies.

# 5.9.2

fix bug of internal development workflow.

# 5.9.1

upgrade dependencies.

# 5.9.0

upgrade dependencies.

# 5.8.0

- upgrade dependencies.

# 5.7.0

- upgrade dependencies.

# 5.6.0

- upgrade dependencies.

# 5.5.0

- upgrade dependencies.

# 5.4.1

- loose the version of `meta` package in dependencies.

# 5.4.0

- upgrade dependencies.

# 5.3.1

- loose the version of `meta` package in dependencies.

# 5.3.0

- remove redundant Documentation link on pub.dev.

# 5.2.0

- fix module public/private scope.

# 5.1.0

- add constants.
  - `boardSize`
  - `BookCountBoardBestPathLowerLimit.best`

# 5.0.1

- fix the arguments of `edaxBookCountBoardBestpath`.
- fix the documentation of `edaxBookCountBoardBestpath`.

# 5.0.0

- [Breaking Change] integrate `done` flag and `todo` flag on `Position` class to `flag`.
- add `edaxBookCountBoardBestpath` and deprecate `edaxBookCountBestpath`.

# 4.1.0

- upgrade dependencies.

# 4.0.3

- downgrade Dart SDK min version for pub.

# 4.0.2

- mild update README and example.

# 4.0.1

- fix typo on CHANGELOG.

# 4.0.0

- remove `Pointer<Int8>` extension `toStr` and add `Pointer<Char>` extension `toDartStr`.
- remove `String` extension `toInt8Pointer` amd add `toCharPointer`.

# 3.6.0

- mild update documentation.

# 3.5.0

- add `edaxBookVerbose`.
- add `edaxEnableBookVerbose`.
- add `edaxDisableBookVerbose`.

# 3.4.0

- add `edaxBookStore`.
- add `edaxBookSave`.

# 3.3.0

- add `edaxOptionsDump`.

# 3.2.0

- add `edaxBookFix`.
- add `edaxBookDeviate`.

# 3.1.1

- enhance documentation of `edaxPlayPrint`.

# 3.1.0

- add `edaxPlayPrint`.

# 3.0.0

- [Breaking Change] if you don't specify dll path, libedax4dart search `libedax.universal.dylib`. in past, that is `libedax.dylib`.
- upgrade libedax lib to support Apple Silicon.
  - See: https://developer.apple.com/documentation/apple-silicon/building-a-universal-macos-binary

# 2.14.1

- restore `CHANGELOG.md`.

# 2.14.0

- upgrade dependencies.

# 2.13.0

- upgrade dependencies.

# 2.12.0

- upgrade dependencies.
- fix typos on documentation.

# 2.11.0

- mild upgrade libedax binary.

# 2.10.0

- mild update documentation of `edaxBookCountBestpath`.

# 2.9.1

- follow Dart Package ecosystem changed. (See: https://github.com/sensuikan1973/libedax4dart/pull/118)

# 2.9.0

- follow Dart Package ecosystem changed. (See: https://github.com/sensuikan1973/libedax4dart/pull/117)

# 2.8.0

- add `empty` to `ColorChar`.

# 2.7.0

- add const `ColorChar`.

# 2.6.0

- upgrade dependencies.

# 2.5.0

- upgrade dependencies.

# 2.4.0

- upgrade dependencies.

# 2.3.0

- add useful getter `stringApplicableToSetboard` to Board class.

# 2.2.0

- upgrade ffigen package from `3.0.0` to `4.1.0`.

# 2.1.0

- upgrade dependencies.

# 2.0.0

- [internal migration] Migrate from manual bindings to auto generated bindings by ffigen package.

# 1.5.0

- delete deprecated functions.
  - `computeBestPathNumWithLink`
  - `streamOfBestPathNumWithLink`

# 1.4.0

- enable `edaxBookCountBestpath` to receive Board param.

# 1.3.0

- add `edaxBookCountBestpath`, `edaxBookStopCountBestpath`
- deprecate `computeBestPathNumWithLink`, `streamOfBestPathNumWithLink`
  - although these functions are deprecated, if you specify level(search depth), you can use these functions. you can't do that with `edaxBookCountBestpath`, for now.

# 1.2.0

- upgrade libedax.

# 1.1.0

- fix memory leak.
- upgrade dependencies.

# 1.0.0

release stable version.

# 0.14.0-beta

- upgrade dependencies.

# 0.13.1-beta

- upgrade dependencies.

# 0.13.0-beta

- add `streamOfBestPathNumWithLink`.

# 0.12.4-beta

- improve performance of `computeBestPathNumWithLink`.

# 0.12.3-beta

- improve documentation of `computeBestPathNumWithLink`.

# 0.12.2-beta

- fix a path num bug of `computeBestPathNumWithLink`.
- add `enableToPrintMovesOnBuildingTree` arg to `computeBestPathNumWithLink`.

# 0.12.1-beta

- add `onlyBestScoreLink` arg to `computeBestPathNumWithLink`.

# 0.12.0-beta

- **Breaking Changes**
  - change the arg of `computeBestPathNumWithLink`.
  - fix the bug of `computeBestPathNumWithLink`.

# 0.11.1-beta

- add documentation link on pub.dev.

# 0.11.0-beta

- New Features
  - add `computeBestPathNumWithLink`.
  - improve documentation links.

# 0.10.0-beta

- **Breaking Changes**
  - fix `PASS` String.
    - separate `PA (BLACK)` and `pa (WHITE)`.

# 0.9.0-beta.0

- add `edaxGetBookMoveWithPositionByMoves`.

# 0.8.0-beta.0

- you can get `Position.links`.
- upgrade libedax bin.
- upgrade dependencies.

# 0.7.0-beta.2

- upgrade dependencies.

# 0.7.0-beta.1

- upgrade dependencies.

# 0.7.0-beta.0

- return the Move represents `noMove` when `edaxGetLastMove` is called with no moves.
  - until now, in the situation, libedax4dart results segment fault. So, developer had to handle the case.

# 0.6.0-beta.3

- add `MoveMark.passString`(`'pa'`).

# 0.6.0-beta.2

- add documentation for `'pa'` of move.

# 0.6.0-beta.1

- fix the documentation of `edaxGetMoves`.

# 0.6.0-beta.0

- add `edaxRotate` command.

# 0.5.1-beta.0

- upgrade dependencies.

# 0.5.0-beta.6

- improve documents.

# 0.5.0-beta.5

- upgrade dependencies.

# 0.5.0-beta.4

- fix incorrect document for `edaxHintNextNoMultiPvDepth`.
- add useful getter to Hint class.

# 0.5.0-beta.2

- add `closeDll` command.
  - in the future, this command maybe deprecated. See: https://github.com/dart-lang/sdk/issues/40159

# 0.5.0-beta.1

- add `edaxBookLoad` command.

# 0.5.0-beta.0

- upgrade ffi package.

# 0.4.0-beta.1

- fix unstable linux shared library.

# 0.4.0-beta.0

- upgrade ffi package.

# 0.3.0-beta.2

- add useful getter to Board class.
  - square list (int/String)

# 0.3.0-beta.1

- update README
- upgrade dependencies

# 0.3.0-beta.0

- use Dart SDK `beta`

# 0.2.1-dev.4

- loosen dependency constraints.

# 0.2.1-dev.3

- you can specify full path of dll.

# 0.2.1-dev.2

- add `edaxBookShow` command.

# 0.2.1-dev.1

- improve [dart document](https://sensuikan1973.github.io/libedax4dart/).
- fix `Hint.score2String`.
- fix boolean binding.

# 0.2.1-dev.0

- add dev suffix because this package uses Dart SDK **`dev`**.
- add getter to board as radix16 String.

# 0.2.0-alpha

publish alpha release.

# 0.1.0

generated by sensuikan1973/dart-boilerplate

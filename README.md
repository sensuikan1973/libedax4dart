# libedax4dart
dart wrapper for [libedax](https://github.com/lavox/edax-reversi/tree/libedax).  
With using libedax4dart, you can execute functions equivalent to edax commands from dart.

To use libedax4dart, you need libedax (C library). Download the asset from latest release.

## Installation
TODO: add  
TODO: publish to https://pub.dev/

## Usage
TODO: add

## Example
TODO: add

## Document
- [libedax4dart](https://sensuikan1973.github.io/libedax4dart/)
- [libedax](https://lavox.github.io/libedax4py/html/libedax_8c.html)
  - There's possibility that thelink is old. In case of that, See: [source code](https://github.com/lavox/edax-reversi/tree/libedax).
- [edax](https://sensuikan1973.github.io/edax-reversi/)

## Reference
- python version: https://github.com/lavox/libedax4py
- java version: https://github.com/lavox/libedax4j

## Development
![dartfmt](https://github.com/sensuikan1973/libedax4dart/workflows/dartfmt/badge.svg)
![dartanalyzer](https://github.com/sensuikan1973/libedax4dart/workflows/dartanalyzer/badge.svg)
![unit_test](https://github.com/sensuikan1973/libedax4dart/workflows/unit_test/badge.svg)  
![publish_libedax_assets](https://github.com/sensuikan1973/libedax4dart/workflows/publish_libedax_assets/badge.svg)

### format
```sh
dartfmt ./ -w -l 120
```

### document
```sh
dartdoc && open doc/api/index.html
```

### reference
- [dart:ffi](https://dart.dev/guides/libraries/c-interop)
  - [dart-lang/samples/ffi](https://github.com/dart-lang/samples/tree/master/ffi) : simple sample
  - [dart-lang/sdk/samples/ffi](https://github.com/dart-lang/sdk/tree/master/samples/ffi) : complicated sample
- [Dart Documentation](https://dart.dev/guides/language/effective-dart/documentation)

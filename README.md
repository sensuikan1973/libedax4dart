# libedax4dart
dart wrapper for [libedax](https://github.com/lavox/edax-reversi/tree/libedax).  
With using libedax4dart, you can execute functions equivalent to edax commands from dart.

To use libedax4dart, you need libedax (C library).

## Usage
TODO: publish to https://pub.dev/  
TODO: describe  
(you can download libedax assets for this repo release)

## Document
- **[libedax4dart](https://sensuikan1973.github.io/libedax4dart/)**
- [libedax](https://lavox.github.io/libedax4py/html/libedax_8c.html)
  - There's possibility that the link is old. In case of that, See: [source code](https://github.com/lavox/edax-reversi/tree/libedax).
- [edax](https://sensuikan1973.github.io/edax-reversi/)

## Reference
- python version: https://github.com/lavox/libedax4py
- java version: https://github.com/lavox/libedax4j

## Development
[![dart-channel](https://img.shields.io/badge/Dart-dev-64B5F6.svg?logo=dart)](https://dart.dev/get-dart#release-channels)  
![Dart CI](https://github.com/sensuikan1973/libedax4dart/workflows/Dart%20CI/badge.svg)
![Dart Integration Test](https://github.com/sensuikan1973/libedax4dart/workflows/Dart%20Integration%20Test/badge.svg)

### commands
#### format
```sh
dart format --fix -l 120 .
```

#### test
```sh
pub run test .
```

#### analyze
```sh
dart analyze .
```

#### document
```sh
dartdoc && open doc/api/index.html
```

### reference
- [dart:ffi](https://dart.dev/guides/libraries/c-interop)
  - [dart-lang/samples/ffi](https://github.com/dart-lang/samples/tree/master/ffi) : simple sample
  - [dart-lang/sdk/samples/ffi](https://github.com/dart-lang/sdk/tree/master/samples/ffi) : complicated sample
- [Dart Documentation](https://dart.dev/guides/language/effective-dart/documentation)

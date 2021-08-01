# [libedax4dart](https://pub.dev/packages/libedax4dart)

[![dart-channel](https://img.shields.io/badge/Dart-beta-64B5F6.svg?logo=dart)](https://dart.dev/get-dart#release-channels)

Dart wrapper for [libedax](https://github.com/lavox/edax-reversi/tree/libedax).  
With using libedax4dart, you can execute functions equivalent to [edax](https://sensuikan1973.github.io/edax-reversi/) commands.

## Usage

1. Add `libedax4dart` under `dependencies` in your `pubspec.yaml`.
2. **Add your libedax assets** in the path which you like.  
   **If you don't have yours, you can also download from [here](https://github.com/sensuikan1973/libedax4dart/releases/latest)**.

- (Required) dynamic library
  - macos: `libedax.dylib`
  - windows: `libedax-x64.dll`
  - linux: `libedax.so`
- (Optional) data for edax
  - `book.dat`
  - `eval.dat`

3. With using [`LibEdax`](https://sensuikan1973.github.io/libedax4dart/libedax4dart/LibEdax-class.html), you can run edax commands !

Real World example is https://github.com/sensuikan1973/pedax.

## Document

- **[libedax4dart](https://sensuikan1973.github.io/libedax4dart/)**
- [libedax](https://lavox.github.io/libedax4py/html/libedax_8c.html): This may be old. In case of that, See [source](https://github.com/lavox/edax-reversi/tree/libedax).

## Reference

- python version: [libedax4py](https://github.com/lavox/libedax4py)
- java version: [libedax4j](https://github.com/lavox/libedax4j)

---

## Development

![Dart CI](https://github.com/sensuikan1973/libedax4dart/workflows/Dart%20CI/badge.svg)
![Integration Test](https://github.com/sensuikan1973/libedax4dart/workflows/Integration%20Test/badge.svg)
[![codecov](https://codecov.io/gh/sensuikan1973/libedax4dart/branch/main/graph/badge.svg?token=LdDfCMnDhz)](https://codecov.io/gh/sensuikan1973/libedax4dart)

### commands

#### run example

```sh
cd example && pub get && cd ..
dart example/example.dart
```

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

#### change libedax bin

```sh
# After you edit .libedax-version, run this.
libedax_build_command="make libbuild ARCH=x64-modern COMP=gcc OS=osx" dst="." ./scripts/build_libedax.sh
```

#### generate bindings

```sh
./scripts/fetch_libedax.sh
pub run ffigen --config ffigen.yaml --verbose severe
```

### reference

- [dart:ffi](https://dart.dev/guides/libraries/c-interop)
  - [dart-lang/samples/ffi](https://github.com/dart-lang/samples/tree/master/ffi) : simple sample
  - [dart-lang/sdk/samples/ffi](https://github.com/dart-lang/sdk/tree/master/samples/ffi) : complicated sample
  - issues
    - [dart-lang/ffi/issues](https://github.com/dart-lang/ffi/issues)
    - [dart-lang/sdk/labels/library-ffi](https://github.com/dart-lang/sdk/labels/library-ffi)
- [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)

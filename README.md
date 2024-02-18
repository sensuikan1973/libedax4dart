# [libedax4dart](https://pub.dev/packages/libedax4dart)

![Dart CI](https://github.com/sensuikan1973/libedax4dart/workflows/Dart%20CI/badge.svg)
[![codecov](https://codecov.io/gh/sensuikan1973/libedax4dart/branch/main/graph/badge.svg?token=LdDfCMnDhz)](https://codecov.io/gh/sensuikan1973/libedax4dart)

Dart wrapper for [libedax](https://github.com/sensuikan1973/edax-reversi/tree/libedax_sensuikan1973).  
With using libedax4dart, you can execute functions equivalent to [edax](https://sensuikan1973.github.io/edax-reversi/) commands.

## Usage

1. Add `libedax4dart` under `dependencies` in your `pubspec.yaml`.
2. **Add your libedax assets** in the path which you like.  
   **If you don't have yours, you can also download from [here](https://github.com/sensuikan1973/libedax4dart/releases/latest)**.

- (Required) dynamic library
  - macos: `libedax.universal.dylib`
  - windows: `libedax-x64.dll`
  - linux: `libedax.so`
- (Optional) data for edax
  - `book.dat`
  - `eval.dat`

3. With using `LibEdax`, you can run edax commands !

## Document

- [libedax4dart](https://sensuikan1973.github.io/libedax4dart/)
- [libedax](https://sensuikan1973.github.io/edax-reversi/libedax_8c.html)

## Real World Example

- [pedax](https://github.com/sensuikan1973/pedax) : Flutter Desktop app
- [edax_runner](https://github.com/sensuikan1973/edax_runner) : Dart native CLI app

## References

- python edition: [libedax4py](https://github.com/lavox/libedax4py)
- java edition: [libedax4j](https://github.com/lavox/libedax4j)

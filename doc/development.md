# Development

## commands

### run example

```sh
cd example && dart pub get && cd ..
dart example/example.dart
```

### format

```sh
# fix with line length 80 for pana, although I don't like.
# See: https://github.com/dart-lang/dart_style/issues/918
dart format --fix .
```

### test

```sh
dart run test .
```

### analyze

```sh
dart analyze .

dart fix --apply # auto fix
```

### [pana](https://pub.dev/packages/pana)

```sh
dart run pana
```

### document

```sh
dart doc . --validate-links && open doc/api/index.html
```

### change libedax bin

```sh
# After you edit .libedax-version, run this.
# See: https://developer.apple.com/documentation/apple-silicon/building-a-universal-macos-binary
libedax_build_command="make universal_osx_libbuild" dst="." ./scripts/build_libedax.sh
```

### generate bindings

```sh
# Before this, you must run build_libedax.sh.
dart run ffigen --config ffigen.yaml --verbose severe && dart format --fix .
```

### publish

https://github.com/dart-lang/pub-dev/issues/5388

```sh
dart pub publish
```

## references

- [dart:ffi](https://dart.dev/guides/libraries/c-interop)
  - [dart-lang/samples/ffi](https://github.com/dart-lang/samples/tree/master/ffi) : simple sample
  - [dart-lang/sdk/samples/ffi](https://github.com/dart-lang/sdk/tree/master/samples/ffi) : complicated sample
  - issues
    - [dart-lang/ffi/issues](https://github.com/dart-lang/ffi/issues)
    - [dart-lang/sdk/labels/library-ffi](https://github.com/dart-lang/sdk/labels/library-ffi)
- [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)

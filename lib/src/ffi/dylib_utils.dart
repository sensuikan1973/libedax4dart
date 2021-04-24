import 'dart:ffi';
import 'dart:io' show Directory, Platform;

import 'package:path/path.dart' as p;

String get _libName {
  if (Platform.isLinux || Platform.isAndroid) return 'libedax.so';
  if (Platform.isMacOS) return 'libedax.dylib';
  if (Platform.isWindows) return 'libedax-x64.dll';
  throw Exception('${Platform.operatingSystem} is not supported');
}

DynamicLibrary dlopenPlatformSpecific([String dllPath = '']) =>
    dllPath.isEmpty ? DynamicLibrary.open(p.join(Directory.current.path, _libName)) : DynamicLibrary.open(dllPath);

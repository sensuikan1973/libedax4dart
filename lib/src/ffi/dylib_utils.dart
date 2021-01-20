import 'dart:ffi';
import 'dart:io' show Platform;

String get _libName {
  if (Platform.isLinux || Platform.isAndroid) return 'libedax.so';
  if (Platform.isMacOS) return 'libedax.dylib';
  if (Platform.isWindows) return 'libedax-x64.dll';
  throw Exception('${Platform.operatingSystem} is not supported');
}

DynamicLibrary dlopenPlatformSpecific({String path = ''}) => DynamicLibrary.open('$path$_libName');

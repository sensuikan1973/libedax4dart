import 'dart:ffi';
import 'dart:io' show Directory, Platform;

String get _libName {
  if (Platform.isLinux || Platform.isAndroid) return 'libedax.so';
  if (Platform.isMacOS) return 'libedax.universal.dylib';
  if (Platform.isWindows) return 'libedax-x64.dll';
  throw Exception('${Platform.operatingSystem} is not supported');
}

DynamicLibrary dlopenPlatformSpecific([final String dllPath = '']) {
  final path =
      dllPath.isEmpty ? '${Directory.current.path}/$_libName' : dllPath;
  return DynamicLibrary.open(path);
}

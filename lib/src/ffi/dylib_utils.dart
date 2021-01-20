import 'dart:ffi';
import 'dart:io' show Platform;

String _platformPath(String name, String path) {
  if (Platform.isLinux || Platform.isAndroid) return '${path}lib$name.so';
  if (Platform.isMacOS) return '${path}lib$name.dylib';
  if (Platform.isWindows) return '$path$name.dll';
  throw Exception('${Platform.operatingSystem} is not supported');
}

DynamicLibrary dlopenPlatformSpecific(String name, {String path = ''}) {
  final fullPath = _platformPath(name, path);
  return DynamicLibrary.open(fullPath);
}

import 'dart:io';

import 'package:native_assets_cli/native_assets_cli.dart';

const String _repoUrl = 'https://github.com/sensuikan1973/edax-reversi';
const String _branchName = 'libedax_sensuikan1973';
const String _eval7zUrl = 'https://github.com/abulmo/edax-reversi/releases/download/v4.4/eval.7z';

// Note: This build script requires the following command-line utilities to be installed and available in the PATH:
// - '7z' for extracting archives.
// - A C/C++ build toolchain:
//   - Linux: 'make' and 'gcc'.
//   - Windows: 'make' and 'gcc' (e.g., via MinGW or MSYS2).
//   - macOS: 'make' and 'clang' (Xcode Command Line Tools).
void main(List<String> args) async {
  await NativeAssetsCli.run(args, (config, output) async {
    stdout.writeln('Building native assets for target: ${config.target}');
    stdout.writeln('Build mode: ${config.buildMode}');
    stdout.writeln('Output directory: ${config.outDir}');
    stdout.writeln('Package root: ${config.packageRoot}');

    final libEdaxVersionFile = File('${config.packageRoot.path}/.libedax-version');
    if (!await libEdaxVersionFile.exists()) {
      throw Exception('Error: .libedax-version file not found at ${libEdaxVersionFile.path}');
    }
    final version = (await libEdaxVersionFile.readAsString()).trim();
    stdout.writeln('Found .libedax-version: $version');

    final edaxSourceDirUri = config.outDir.resolve('edax_source/'); // Use Uri for consistent path handling
    final edaxSourceDir = Directory.fromUri(edaxSourceDirUri);

    if (await edaxSourceDir.exists()) {
      stdout.writeln('Deleting existing edax_source directory: ${edaxSourceDir.path}');
      await edaxSourceDir.delete(recursive: true);
    }
    await edaxSourceDir.create(recursive: true);
    stdout.writeln('Created edax_source directory: ${edaxSourceDir.path}');

    stdout.writeln('Cloning $_repoUrl branch $_branchName into ${edaxSourceDir.path}...');
    var processResult = await Process.run(
      'git',
      ['clone', '--branch', _branchName, _repoUrl, edaxSourceDir.path],
    );
    if (processResult.exitCode != 0) {
      throw Exception('Error cloning repository:\n${processResult.stdout}\n${processResult.stderr}');
    }
    stdout.writeln('Clone successful.');

    stdout.writeln('Switching to branch $_branchName in ${edaxSourceDir.path}...');
    processResult = await Process.run(
      'git',
      ['-C', edaxSourceDir.path, 'switch', _branchName],
    );
    if (processResult.exitCode != 0) {
      throw Exception('Error switching branch:\n${processResult.stdout}\n${processResult.stderr}');
    }
    stdout.writeln('Switch branch successful.');

    stdout.writeln('Checking out version $version in ${edaxSourceDir.path}...');
    processResult = await Process.run(
      'git',
      ['-C', edaxSourceDir.path, 'checkout', version],
    );
    if (processResult.exitCode != 0) {
      throw Exception('Error checking out version $version:\n${processResult.stdout}\n${processResult.stderr}');
    }
    stdout.writeln('Checkout successful.');

    final dataPathUri = edaxSourceDirUri.resolve('data/');
    final dataPath = Directory.fromUri(dataPathUri);
    if (!await dataPath.exists()) {
      stdout.writeln('Creating data directory: ${dataPath.path}');
      await dataPath.create(recursive: true);
    }

    final eval7zFileUri = dataPathUri.resolve('eval.7z');
    final eval7zFile = File.fromUri(eval7zFileUri);
    stdout.writeln('Downloading $_eval7zUrl to ${eval7zFile.path}...');
    final httpClient = HttpClient();
    try {
      final request = await httpClient.getUrl(Uri.parse(_eval7zUrl));
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        await response.pipe(eval7zFile.openWrite());
        stdout.writeln('Download of eval.7z complete.');
      } else {
        throw Exception('Error downloading eval.7z: HTTP status ${response.statusCode}');
      }
    } finally {
      httpClient.close();
    }

    stdout.writeln('Extracting ${eval7zFile.path} to ${dataPath.path}...');
    processResult = await Process.run(
      '7z',
      ['x', eval7zFile.path, '-y', '-o${dataPath.path}'],
    );
    if (processResult.exitCode != 0) {
      throw Exception('Error extracting eval.7z:\n${processResult.stdout}\n${processResult.stderr}');
    }
    stdout.writeln('Extraction of eval.7z complete.');

    // Build the native library
    stdout.writeln('Starting build process for edax-reversi...');
    final edaxCloneDirUri = edaxSourceDirUri; // edaxSourceDirUri is already the clone directory Uri

    List<String> buildCommandParts;
    String outputLibName;
    final String hostOS = Platform.operatingSystem;

    if (hostOS == 'linux') {
      buildCommandParts = ['make', 'libbuild', 'ARCH=x64', 'COMP=gcc', 'OS=linux'];
      outputLibName = 'libedax.so';
    } else if (hostOS == 'windows') {
      buildCommandParts = ['make', 'libbuild', 'ARCH=x64', 'COMP=gcc', 'OS=windows'];
      outputLibName = 'libedax-x64.dll';
    } else if (hostOS == 'macos') {
      buildCommandParts = ['make', 'universal_osx_libbuild'];
      outputLibName = 'libedax.universal.dylib';
    } else {
      throw Exception('Unsupported operating system for build: $hostOS');
    }

    final workingDirectory = Directory.fromUri(edaxCloneDirUri.resolve('src/')).path;
    stdout.writeln('Build command: ${buildCommandParts.join(' ')} in $workingDirectory');

    processResult = await Process.run(
      buildCommandParts.first,
      buildCommandParts.skip(1).toList(),
      workingDirectory: workingDirectory,
      runInShell: true,
    );

    stdout.writeln('Build process stdout:\n${processResult.stdout}');
    if (processResult.exitCode != 0) {
      stderr.writeln('Build process stderr:\n${processResult.stderr}');
      throw Exception('Build failed with exit code ${processResult.exitCode}.');
    }
    stdout.writeln('Build process completed successfully.');

    final builtLibPathUri = edaxCloneDirUri.resolve('bin/$outputLibName');
    stdout.writeln('Expected library path: ${builtLibPathUri.toFilePath()}');

    if (!await File.fromUri(builtLibPathUri).exists()) {
      throw Exception('Build failed: Expected output library not found at ${builtLibPathUri.toFilePath()}');
    }
    stdout.writeln('Built library found at ${builtLibPathUri.toFilePath()}');

    final assetId = 'package:libedax4dart/src/ffi/$outputLibName';
    output.addAsset(NativeCodeAsset(
      id: assetId,
      packaging: AssetPackaging.dynamic,
      target: config.target,
      path: AssetPath.file(builtLibPathUri),
    ));
    stdout.writeln('Added native code asset: $assetId linked to ${builtLibPathUri.toFilePath()} for target ${config.target}');

    // Add the data directory as an asset
    final dataPathInCloneUri = edaxCloneDirUri.resolve('data/');
    stdout.writeln('Checking for data directory at: ${dataPathInCloneUri.toFilePath()}');
    if (!await Directory.fromUri(dataPathInCloneUri).exists()) {
      throw Exception('Data directory not found at ${dataPathInCloneUri.toFilePath()}. Ensure eval.7z was extracted correctly.');
    }
    stdout.writeln('Adding data asset: package:libedax4dart/assets/data from ${dataPathInCloneUri.toFilePath()}');
    output.addAsset(DataAsset(
      id: 'package:libedax4dart/assets/data',
      path: AssetPath.directory(dataPathInCloneUri),
    ));

    stdout.writeln('Native assets preparation complete.');
  });
}

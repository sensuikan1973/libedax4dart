#!/bin/bash
# shellcheck disable=SC2154,SC2086
set -euxo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common build functions
source "$SCRIPT_DIR/build_libedax_common.sh"

# NOTE: require some environment variables.
# android_abi: Android ABI (arm64-v8a, armeabi-v7a, x86_64, x86)
# dst: output directory (e.g. build)
#
# example:
# android_abi="arm64-v8a" dst="." ./scripts/build_libedax_android.sh

if [ -z "${android_abi:-}" ]; then
    echo "Error: android_abi environment variable is required"
    exit 1
fi

echo "Building libedax for Android ABI: $android_abi"
echo "Output directory: ${dst:-.}"

# Setup platform-specific environment for Android
setup_platform_environment() {
  # Set up Android NDK toolchain
  export ANDROID_NDK_ROOT=$ANDROID_NDK_LATEST_HOME

  # Detect the correct prebuilt directory based on the host OS
  if [[ "$OSTYPE" == "darwin"* ]]; then
      export NDK_TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      export NDK_TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64
  else
      echo "Error: Unsupported OS type: $OSTYPE"
      exit 1
  fi

  # Set up compiler and flags based on architecture
  case "$android_abi" in
    "arm64-v8a")
      export CC=$NDK_TOOLCHAIN/bin/aarch64-linux-android21-clang
      export ARCH_FLAGS="-march=armv8-a"
      export OUTPUT_NAME="libedax-arm64-v8a.so"
      ;;
    "armeabi-v7a")
      export CC=$NDK_TOOLCHAIN/bin/armv7a-linux-androideabi21-clang
      export ARCH_FLAGS="-march=armv7-a -mfpu=neon"
      export OUTPUT_NAME="libedax-armeabi-v7a.so"
      ;;
    "x86_64")
      export CC=$NDK_TOOLCHAIN/bin/x86_64-linux-android21-clang
      export ARCH_FLAGS="-m64"
      export OUTPUT_NAME="libedax-x86_64.so"
      ;;
    "x86")
      export CC=$NDK_TOOLCHAIN/bin/i686-linux-android21-clang
      export ARCH_FLAGS="-m32"
      export OUTPUT_NAME="libedax-x86.so"
      ;;
    *)
      echo "Error: Unsupported android_abi: $android_abi"
      exit 1
      ;;
  esac
}

# No makefile patching needed for Android (uses direct compilation)
patch_makefile() {
  return 0
}

# Android-specific build implementation
build_platform_specific() {
  echo "Building Android shared library with $CC..."
  
  # Build libedax for Android
  mkdir -p bin
  cd src

  # Custom build command for Android SO file
  $CC -std=c99 -O3 -DNDEBUG -DLIB_BUILD -DANDROID -fPIC -shared $ARCH_FLAGS \
    all.c -o ../bin/$OUTPUT_NAME -lm -llog

  cd ..
}

# Android-specific setup of output directory and file copying
setup_output_directory_android() {
  # Setup output directory structure
  mkdir -p "${dst:-.}/android/$android_abi/bin"
  mkdir -p "${dst:-.}/android/$android_abi/data"

  # Copy built library and data
  cp "bin/$OUTPUT_NAME" "${dst:-.}/android/$android_abi/bin/"
  cp -r data/* "${dst:-.}/android/$android_abi/data/"

  echo "Android libedax build completed for $android_abi"
  echo "Output: ${dst:-.}/android/$android_abi/bin/$OUTPUT_NAME"
}

# Main execution
main() {
  # Run common preparation steps
  prepare_edax_reversi
  prepare_data_files
  
  # Setup platform environment
  setup_platform_environment
  
  # Enter build directory
  cd edax-reversi
  
  # Patch makefile (no-op for Android)
  patch_makefile
  
  # Build the library
  build_platform_specific
  
  # Go back to script directory and setup outputs
  cd ..
  cd edax-reversi
  setup_output_directory_android
}

# Execute main function
main

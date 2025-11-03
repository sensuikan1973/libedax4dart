#!/bin/bash
# shellcheck disable=SC2154,SC2086
set -euxo pipefail

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

# Clone and setup edax-reversi
rm -rf edax-reversi
git clone https://github.com/sensuikan1973/edax-reversi
cd edax-reversi
git remote update --prune
git switch libedax_sensuikan1973
git checkout "$(cat ../.libedax-version)"

# Download eval data
mkdir -p data
curl -OL https://github.com/abulmo/edax-reversi/releases/download/v4.4/eval.7z
7za x eval.7z -y

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

# Build libedax for Android
mkdir -p bin
cd src

# Custom build command for Android SO file
$CC -std=c99 -O3 -DNDEBUG -DLIB_BUILD -DANDROID -fPIC -shared $ARCH_FLAGS \
  all.c -o ../bin/$OUTPUT_NAME -lm -llog

cd ../../

# Setup output directory structure
mkdir -p "${dst:-.}/android/$android_abi/bin"
mkdir -p "${dst:-.}/android/$android_abi/data"

# Copy built library and data
cp "edax-reversi/bin/$OUTPUT_NAME" "${dst:-.}/android/$android_abi/bin/"
cp -r edax-reversi/data/* "${dst:-.}/android/$android_abi/data/"

echo "Android libedax build completed for $android_abi"
echo "Output: ${dst:-.}/android/$android_abi/bin/$OUTPUT_NAME"

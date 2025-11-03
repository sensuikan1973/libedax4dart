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

# プラットフォーム固有の設定
export PLATFORM_NAME="Android ($android_abi)"
export DEFAULT_DST="build_android"

# Android固有の環境設定
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

# プラットフォーム固有のビルド処理
build_platform_specific() {
    echo "Building libedax for Android ($android_abi)..."
    
    # Build libedax for Android (direct compilation)
    mkdir -p bin
    $CC -std=c99 -O3 -DNDEBUG -DLIB_BUILD -DANDROID -fPIC -shared $ARCH_FLAGS \
      all.c -o bin/$OUTPUT_NAME -lm -llog
}

# テスト用ファイルのクリーンアップ（Android特有の出力構造）
cleanup_test_files() {
    # Android builds don't need to copy to project root
    return 0
}

# 完了メッセージの表示
show_completion_message() {
    local output_dir="${dst:-$DEFAULT_DST}"
    echo "  - 共有ライブラリ: ${output_dir}/android/$android_abi/bin/$OUTPUT_NAME"
    echo "  - アーキテクチャ: $android_abi"
    echo "  - データファイル: ${output_dir}/android/$android_abi/data/"
}

# Android固有の出力ディレクトリ設定をオーバーライド
# shellcheck disable=SC2329  # Called indirectly by common script
setup_output_directory() {
    local output_dir="${dst:-$DEFAULT_DST}"
    
    echo "Setting up Android output directory: $output_dir"
    
    # Android固有のディレクトリ構造を作成
    mkdir -p "$output_dir/android/$android_abi/bin"
    mkdir -p "$output_dir/android/$android_abi/data"
    
    # ライブラリとデータをコピー
    cp "bin/$OUTPUT_NAME" "$output_dir/android/$android_abi/bin/"
    cp -r data/* "$output_dir/android/$android_abi/data/"
}

# 共通スクリプトの読み込みと実行
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build_libedax_common.sh
source "${SCRIPT_DIR}/build_libedax_common.sh"

# メイン処理の実行
main

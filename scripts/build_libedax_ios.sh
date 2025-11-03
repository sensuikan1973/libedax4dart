#!/bin/bash
# shellcheck disable=SC2154
set -euxo pipefail

# NOTE: iOS用のlibedax dylibを生成するスクリプト
# iOSシミュレータ（x86_64）とiOSデバイス（arm64）の両方に対応したユニバーサルライブラリを作成
#
# example:
# ./scripts/build_libedax_ios.sh

# プラットフォーム固有の設定
export PLATFORM_NAME="iOS"
export DEFAULT_DST="build_ios"

# プラットフォーム固有の環境設定
setup_platform_environment() {
    echo "Setting up iOS development environment..."
    export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
    export SDK_ROOT_SIM=$DEVELOPER_DIR/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
    export SDK_ROOT_IOS=$DEVELOPER_DIR/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
}

# Makefileの修正
patch_makefile() {
    echo "Patching Makefile for iOS..."
    sed -i.bak 's/-fuse-ld=gold//g' Makefile

    # iOS用のOS設定を追加
    cat >> Makefile << 'EOF'

# iOS specific settings
ifeq ($(OS),ios)
	# Remove macOS specific flags that conflict with iOS
	CFLAGS := $(filter-out -mmacosx-version-min=%,$(CFLAGS))
	CFLAGS := $(filter-out -mdynamic-no-pic,$(CFLAGS))
endif
EOF
}

# プラットフォーム固有のビルド処理
build_platform_specific() {
    # iOSシミュレータ用（x86_64）のdylibをビルド
    echo "Building for iOS Simulator (x86_64)..."
    make clean || true

    # 手動でライブラリをビルド（シミュレータ用）
    clang -arch x86_64 -isysroot "$SDK_ROOT_SIM" -mios-simulator-version-min=11.0 \
      -std=c99 -pedantic -W -Wall -D_GNU_SOURCE=1 -Wno-invalid-source-encoding \
      -O3 -flto -ffast-math -fomit-frame-pointer -DNDEBUG \
      -m64 -DUSE_GAS_X64 -DHAS_CPU_64 -DLIB_BUILD -fPIC \
      -dynamiclib -install_name @rpath/libedax.ios.dylib \
      all.c -o ../bin/libedax_sim.dylib -lm -lpthread

    # iOSデバイス用（arm64）のdylibをビルド
    echo "Building for iOS Device (arm64)..."
    make clean || true

    # 手動でライブラリをビルド（デバイス用）
    clang -arch arm64 -isysroot "$SDK_ROOT_IOS" -mios-version-min=11.0 \
      -std=c99 -pedantic -W -Wall -D_GNU_SOURCE=1 -Wno-invalid-source-encoding \
      -O3 -flto -ffast-math -fomit-frame-pointer -DNDEBUG \
      -DHAS_CPU_64 -DLIB_BUILD -fPIC \
      -dynamiclib -install_name @rpath/libedax.ios.dylib \
      all.c -o ../bin/libedax_device.dylib -lm -lpthread

    # ユニバーサルバイナリ（fat binary）を作成
    echo "Creating universal binary..."
    lipo -create ../bin/libedax_sim.dylib ../bin/libedax_device.dylib -output ../bin/libedax.ios.dylib

    # 作成されたライブラリの情報を表示
    echo "Universal library info:"
    lipo -info ../bin/libedax.ios.dylib
    file ../bin/libedax.ios.dylib
}

# テスト用ファイルのクリーンアップ
cleanup_test_files() {
    # iOS用のテストファイルは作成しない（シミュレータ/デバイス環境が必要）
    :
}

# 完了メッセージの表示
show_completion_message() {
    local output_dir="${dst:-$DEFAULT_DST}"
    echo "  - ユニバーサルライブラリ: ${output_dir}/bin/libedax.ios.dylib"
    echo "  - アーキテクチャ: x86_64 (シミュレータ) + arm64 (デバイス)"
    echo "  - データファイル: ${output_dir}/data/"
}

# 共通スクリプトの読み込みと実行
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/build_libedax_common.sh"

# メイン処理の実行
main

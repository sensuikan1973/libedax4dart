#!/bin/bash
# shellcheck disable=SC2154
set -euxo pipefail

# NOTE: iOS用のlibedax dylibを生成するスクリプト
# iOSシミュレータ（x86_64）とiOSデバイス（arm64）の両方に対応したユニバーサルライブラリを作成
#
# example:
# ./scripts/build_libedax_ios.sh

# クリーンアップ
rm -rf edax-reversi

# edax-reversiのクローン
git clone https://github.com/sensuikan1973/edax-reversi
cd edax-reversi
git remote update --prune
git switch libedax_sensuikan1973
git checkout "$(cat ../.libedax-version)"

# データファイルの準備
mkdir -p data
curl -OL https://github.com/abulmo/edax-reversi/releases/download/v4.4/eval.7z
7z x eval.7z -y

mkdir -p bin
cd src

# iOS向けのコンパイル設定
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export SDK_ROOT_SIM=$DEVELOPER_DIR/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
export SDK_ROOT_IOS=$DEVELOPER_DIR/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

# Makefileを修正してiOS用にLinux固有のオプションを削除し、iOS対応を追加
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

cd ../../

# 出力ディレクトリの準備
dst=${dst:-"build_ios"}
mkdir -p "${dst}"

rm -rf "${dst:?}/bin"
rm -rf "${dst:?}/data"

cp -r edax-reversi/bin "${dst}/bin"
cp -r edax-reversi/data "${dst}/data"

echo "iOS用libedaxライブラリの生成が完了しました："
echo "  - ユニバーサルライブラリ: ${dst}/bin/libedax.ios.dylib"
echo "  - アーキテクチャ: x86_64 (シミュレータ) + arm64 (デバイス)"
echo "  - データファイル: ${dst}/data/"

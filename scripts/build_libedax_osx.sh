#!/bin/bash
# shellcheck disable=SC2154
set -euxo pipefail

# NOTE: macOS用のlibedax動的ライブラリを生成するスクリプト
# ユニバーサルバイナリ（x86_64 + arm64）を作成
# dst: 出力ディレクトリ (e.g. build_macos)
#
# example:
# dst="." ./scripts/build_libedax_osx.sh

# プラットフォーム固有の設定
export PLATFORM_NAME="macOS"
export DEFAULT_DST="build_macos"

# プラットフォーム固有のビルド処理
build_platform_specific() {
    echo "Building libedax for macOS (universal binary)..."
    make universal_osx_libbuild
}

# テスト用ファイルのクリーンアップ
cleanup_test_files() {
    rm -f ./libedax.*.dylib
    cp "${dst:-$DEFAULT_DST}"/bin/* .
}

# 完了メッセージの表示
show_completion_message() {
    local output_dir="${dst:-$DEFAULT_DST}"
    echo "  - ユニバーサルライブラリ: ${output_dir}/bin/libedax.universal.dylib"
    echo "  - アーキテクチャ: x86_64 + arm64"
    echo "  - データファイル: ${output_dir}/data/"
}

# 共通スクリプトの読み込みと実行
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_SCRIPT="${SCRIPT_DIR}/build_libedax_common.sh"

# Check if common script exists
if [ ! -f "$COMMON_SCRIPT" ]; then
    echo "Error: Common script not found at $COMMON_SCRIPT"
    exit 1
fi

# shellcheck source=./build_libedax_common.sh
source "$COMMON_SCRIPT"

# メイン処理の実行
main

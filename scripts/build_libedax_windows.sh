#!/bin/bash
# shellcheck disable=SC2154
set -euxo pipefail

# NOTE: Windows用のlibedax動的ライブラリを生成するスクリプト
# MinGW-w64を使用してクロスコンパイル
# dst: 出力ディレクトリ (e.g. build_windows)
#
# example:
# dst="." ./scripts/build_libedax_windows.sh

# プラットフォーム固有の設定
export PLATFORM_NAME="Windows"
export DEFAULT_DST="build_windows"

# プラットフォーム固有のビルド処理
build_platform_specific() {
    echo "Building libedax for Windows..."
    make libbuild ARCH=x64 COMP=gcc OS=windows
}

# テスト用ファイルのクリーンアップ
cleanup_test_files() {
    rm -f ./libedax*.dll
    cp "${dst:-$DEFAULT_DST}"/bin/* .
}

# 完了メッセージの表示
show_completion_message() {
    local output_dir="${dst:-$DEFAULT_DST}"
    echo "  - 動的ライブラリ: ${output_dir}/bin/libedax-x64.dll"
    echo "  - アーキテクチャ: x64"
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

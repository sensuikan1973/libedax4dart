#!/bin/bash
# shellcheck disable=SC2154
set -euxo pipefail

# NOTE: Linux用のlibedax共有ライブラリを生成するスクリプト
# dst: 出力ディレクトリ (e.g. build_linux)
#
# example:
# dst="." ./scripts/build_libedax_linux.sh

# プラットフォーム固有の設定
export PLATFORM_NAME="Linux"
export DEFAULT_DST="build_linux"

# プラットフォーム固有のビルド処理
build_platform_specific() {
    echo "Building libedax for Linux..."
    make libbuild ARCH=x64 COMP=gcc OS=linux
}

# テスト用ファイルのクリーンアップ
cleanup_test_files() {
    rm -f ./libedax.so
    cp "${dst:-$DEFAULT_DST}"/bin/* .
}

# 完了メッセージの表示
show_completion_message() {
    local output_dir="${dst:-$DEFAULT_DST}"
    echo "  - 共有ライブラリ: ${output_dir}/bin/libedax.so"
    echo "  - アーキテクチャ: x64"
    echo "  - データファイル: ${output_dir}/data/"
}

# 共通スクリプトの読み込みと実行
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/build_libedax_common.sh"

# メイン処理の実行
main

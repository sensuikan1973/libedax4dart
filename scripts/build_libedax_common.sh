#!/bin/bash
# shellcheck disable=SC2154
set -euxo pipefail

# NOTE: libedaxビルドの共通処理
# 各プラットフォーム固有のスクリプトから呼び出される
#
# 必要な環境変数:
# - dst: 出力ディレクトリ
# - PLATFORM_NAME: プラットフォーム名（表示用）
# - DEFAULT_DST: デフォルトの出力ディレクトリ名
#
# 必要な関数:
# - build_platform_specific: プラットフォーム固有のビルド処理
# - cleanup_test_files: テスト用ファイルのクリーンアップ
# - show_completion_message: 完了メッセージの表示
# オプション関数:
# - setup_platform_environment: プラットフォーム固有の環境設定（オプション）
# - patch_makefile: Makefileの修正（オプション）

# edax-reversiリポジトリの準備
prepare_edax_reversi() {
    echo "Preparing edax-reversi repository..."
    rm -rf edax-reversi
    git clone https://github.com/sensuikan1973/edax-reversi
    cd edax-reversi
    git remote update --prune
    git switch libedax_sensuikan1973
    git checkout "$(cat ../.libedax-version)"
}

# データファイルの準備
prepare_data_files() {
    echo "Preparing data files..."
    mkdir -p data
    curl -OL https://github.com/abulmo/edax-reversi/releases/download/v4.4/eval.7z
    7z x eval.7z -y
    mkdir -p bin
}

# 出力ディレクトリの準備とファイルコピー
setup_output_directory() {
    local output_dir="${dst:-$DEFAULT_DST}"
    
    echo "Setting up output directory: $output_dir"
    cd ../../
    mkdir -p "$output_dir"

    rm -rf "${output_dir:?}/bin"
    rm -rf "${output_dir:?}/data"

    cp -r edax-reversi/bin "$output_dir/bin"
    cp -r edax-reversi/data "$output_dir/data"
}

# メイン処理
main() {
    # 環境変数の検証
    if [[ -z "${PLATFORM_NAME:-}" ]]; then
        echo "Error: PLATFORM_NAME environment variable is required"
        exit 1
    fi
    
    if [[ -z "${DEFAULT_DST:-}" ]]; then
        echo "Error: DEFAULT_DST environment variable is required"
        exit 1
    fi

    # 必要な関数の存在確認
    if ! declare -f build_platform_specific >/dev/null; then
        echo "Error: build_platform_specific function must be defined"
        exit 1
    fi
    
    if ! declare -f cleanup_test_files >/dev/null; then
        echo "Error: cleanup_test_files function must be defined"
        exit 1
    fi
    
    if ! declare -f show_completion_message >/dev/null; then
        echo "Error: show_completion_message function must be defined"
        exit 1
    fi

    # 共通処理の実行
    prepare_edax_reversi
    prepare_data_files
    
    # プラットフォーム固有の環境設定（オプション）
    if declare -f setup_platform_environment >/dev/null; then
        setup_platform_environment
    fi
    
    # Makefileの修正（オプション）
    if declare -f patch_makefile >/dev/null; then
        patch_makefile
    fi
    
    # プラットフォーム固有のビルド
    cd src
    build_platform_specific
    
    # 出力ディレクトリの準備
    setup_output_directory
    
    # テスト用ファイルのクリーンアップ
    cleanup_test_files
    
    # 完了メッセージの表示
    show_completion_message
    
    echo "✅ ${PLATFORM_NAME}用libedaxライブラリの生成が完了しました"
}

#!/bin/bash
# Test script for Android build (requires Android NDK to be installed locally)
set -euo pipefail

echo "Testing Android libedax build script..."

# Check if Android NDK is available
if [ -z "${ANDROID_NDK_ROOT:-}" ] && [ -z "${ANDROID_NDK_LATEST_HOME:-}" ]; then
    echo "ANDROID_NDK_ROOT or ANDROID_NDK_LATEST_HOME not set. Attempting to auto-detect..."
    
    # Try to find Android NDK in common locations
    POSSIBLE_NDK_PATHS=(
        "$HOME/Library/Android/sdk/ndk"
        "$HOME/Android/Sdk/ndk"
        "/usr/local/android-ndk"
        "/opt/android-ndk"
    )
    
    for ndk_base in "${POSSIBLE_NDK_PATHS[@]}"; do
        if [ -d "$ndk_base" ]; then
            # Find the latest version
            latest_ndk=$(find "$ndk_base" -maxdepth 1 -type d -name "*.*.*" | sort -V | tail -1)
            if [ -n "$latest_ndk" ] && [ -d "$latest_ndk" ]; then
                export ANDROID_NDK_LATEST_HOME="$latest_ndk"
                echo "Found Android NDK at: $ANDROID_NDK_LATEST_HOME"
                break
            fi
        fi
    done
    
    if [ -z "${ANDROID_NDK_LATEST_HOME:-}" ]; then
        echo "Error: Android NDK not found in common locations."
        echo "Please install Android NDK via Android Studio SDK Manager or download from:"
        echo "https://developer.android.com/ndk/downloads"
        echo ""
        echo "Or set the environment variable manually:"
        echo "export ANDROID_NDK_LATEST_HOME=/path/to/your/ndk"
        exit 1
    fi
fi

# Set ANDROID_NDK_LATEST_HOME if not set but ANDROID_NDK_ROOT is set
if [ -z "${ANDROID_NDK_LATEST_HOME:-}" ] && [ -n "${ANDROID_NDK_ROOT:-}" ]; then
    export ANDROID_NDK_LATEST_HOME="$ANDROID_NDK_ROOT"
fi

# Test building for arm64-v8a
echo "Building for arm64-v8a..."
android_abi="arm64-v8a" dst="test_output" ./scripts/build_libedax_android.sh

echo "Build successful! Check test_output/android/arm64-v8a/ for the generated files."
echo "Generated files:"
find test_output/android/arm64-v8a/ -name "*.so" -o -name "*.dat" | head -10

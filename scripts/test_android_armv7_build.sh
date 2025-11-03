#!/bin/bash
# Test script for armeabi-v7a build specifically
set -euo pipefail

echo "Testing Android libedax build for armeabi-v7a..."

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
        exit 1
    fi
fi

# Test building for armeabi-v7a specifically
echo "Building for armeabi-v7a..."
android_abi="armeabi-v7a" dst="test_output_armv7" ./scripts/build_libedax_android.sh

echo "Build successful! Check test_output_armv7/android/armeabi-v7a/ for the generated files."
echo "Generated files:"
find test_output_armv7/android/armeabi-v7a/ -name "*.so" -o -name "*.dat" | head -10

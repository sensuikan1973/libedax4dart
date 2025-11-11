#!/bin/bash

set -eux

# NOTE: This script is assumed to be run from the root of the repository.
#
# This script is a modified version of the following script:
# https://github.com/sensuikan1973/edax-reversi/blob/libedax_sensuikan1973/src/Makefile#L268-L272

# move to libedax directory
# shellcheck disable=SC2164
cd ./resources/libedax/src

# build for iOS devices (arm64)
xcrun -sdk iphoneos clang \
    -arch arm64 \
    -std=c99 -pedantic -W -Wall -Wextra -pipe -D_GNU_SOURCE=1 \
    -Ofast -flto -DNDEBUG \
    -m64 -DUSE_GAS_X64 -DPOPCOUNT \
    -DHAS_CPU_64 -DLIB_BUILD -fPIC -shared \
    all.c -o \
    ../../libedax.arm64.dylib \
    -lm -lpthread

# build for iOS simulator (x86_64)
xcrun -sdk iphonesimulator clang \
    -arch x86_64 \
    -std=c99 -pedantic -W -Wall -Wextra -pipe -D_GNU_SOURCE=1 \
    -Ofast -flto -DNDEBUG \
    -m64 -DUSE_GAS_X64 -DPOPCOUNT \
    -DHAS_CPU_64 -DLIB_BUILD -fPIC -shared \
    all.c -o \
    ../../libedax.x64.dylib \
    -lm -lpthread

# create universal binary
lipo -create -output ../../libedax.dylib ../../libedax.arm64.dylib ../../libedax.x64.dylib

# move to project root
# shellcheck disable=SC2164
cd ../../..

# create output directory
mkdir -p "$dst"

# move the dylib to the output directory
mv ./resources/libedax/libedax.dylib "$dst"

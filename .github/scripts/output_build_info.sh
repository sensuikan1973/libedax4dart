#!/bin/bash

# $1: dst
# $2: compiler

dst_file="$1/env.txt"
compiler="$2"

touch "$dst_file"

{
  echo "=== libedax4dart sha ==="
  echo "$GITHUB_SHA"

  echo "=== libedax sha ==="
  cat .libedax-version

  echo "=== os image ==="
  # shellcheck disable=SC2154
  echo "$ImageOS"

  echo "=== dart version ==="
  dart --version 2>&1

  echo "=== $compiler version ==="
  $compiler --version
} >> "$dst_file"

#!/bin/bash
set -euxo pipefail

# $1: dst

dst_file="$1/.env.txt"

touch "$dst_file"

{
  echo "=== libedax4dart sha ==="
  echo "$GITHUB_SHA"

  echo "=== libedax sha ==="
  cat .libedax-version

  echo "=== os image ==="
  # shellcheck disable=SC2154
  echo "$ImageOS"

  echo "=== gcc version ==="
  gcc --version
} >> "$dst_file"

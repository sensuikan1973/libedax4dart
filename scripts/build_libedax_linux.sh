#!/bin/bash
# shellcheck disable=SC2154
set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common build functions
# shellcheck source=build_libedax_common.sh
source "$SCRIPT_DIR/build_libedax_common.sh"

echo "Building libedax for Linux"
echo "Output directory: ${dst:-.}"

# Setup platform-specific environment for Linux
setup_platform_environment() {
  export CC="gcc"
  export OUTPUT_NAME="libedax.so"
}

# Patch makefile for Linux-specific settings
patch_makefile() {
  # Linux doesn't need special patching for this build
  return 0
}

# Linux-specific build implementation
build_platform_specific() {
  echo "Building Linux shared library..."
  make libbuild ARCH=x64 COMP=gcc OS=linux
}

# Main execution
main() {
  # Run common preparation steps
  prepare_edax_reversi
  prepare_data_files
  
  # Setup platform environment
  setup_platform_environment
  
  # Enter build directory
  cd edax-reversi
  
  # Patch makefile
  patch_makefile
  
  # Build the library
  build_platform_specific
  
  # Go back to script directory and setup outputs
  cd ..
  setup_output_directory
  
  # Copy test file for compatibility
  rm -f ./libedax.so
  cp "${dst:-.}"/bin/* .
  
  echo "Linux libedax build completed"
  echo "Output: ${dst:-.}/bin/$OUTPUT_NAME"
}

# Execute main function
main

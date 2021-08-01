# NOTE: require some environment variables.
# libedax_build_command (e.g. make libbuild ARCH=x64-modern COMP=gcc OS=osx)
# dst: (e.g. build)
#
# example:
# libedax_build_command="make libbuild ARCH=x64-modern COMP=gcc OS=osx" dst="." ./scripts/build_libedax.sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
source "$SCRIPT_DIR/scripts/fetch_libedax.sh"

mkdir -p data
curl -OL https://github.com/abulmo/edax-reversi/releases/download/v4.4/eval.7z
7z x eval.7z -y

mkdir -p bin
cd src
$libedax_build_command

cd ../../
mkdir -p ${dst:-.}

rm -rf ${dst:-.}/bin
rm -rf ${dst:-.}/data

cp -r edax-reversi/bin ${dst:-.}/bin
cp -r edax-reversi/data ${dst:-.}/data

# for test
cp ${dst:-.}/bin/* .

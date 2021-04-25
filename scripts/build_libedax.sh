# NOTE: require some environment variables.
# libedax_build_command (e.g. make libbuild ARCH=x64-modern COMP=gcc OS=osx)
# dst: (e.g. build)
#
# example:
# libedax_build_command="make libbuild ARCH=x64-modern COMP=gcc OS=osx" dst="." ./scripts/build_libedax.sh

git clone https://github.com/sensuikan1973/edax-reversi
cd edax-reversi
git switch libedax_sensuikan1973
git checkout $(cat ../libedax-version)

mkdir -p data
curl -OL https://github.com/abulmo/edax-reversi/releases/download/v4.4/eval.7z
7z x eval.7z -y

mkdir -p bin
cd src
$libedax_build_command

cd ../../
mkdir -p $dst

cp -r edax-reversi/bin $dst/bin
cp -r edax-reversi/data $dst/data

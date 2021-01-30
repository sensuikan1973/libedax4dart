# NOTE: require some environment variables.
# libedax_build_command (e.g. make libbuild ARCH=x64-modern COMP=gcc OS=osx)
# dst: (e.g. build)

git clone https://github.com/lavox/edax-reversi
cd edax-reversi
git switch libedax
git checkout 985ef418833a4bf7a9a59f4d6104c91c39b7c83e

mkdir -p data
curl -OL https://github.com/abulmo/edax-reversi/releases/download/v4.4/eval.7z
7z x eval.7z -y

mkdir -p bin
cd src
$libedax_build_command

cd ../../
rm -rf $dst
mkdir -p $dst

cp -r edax-reversi/bin $dst/bin
cp -r edax-reversi/data $dst/data

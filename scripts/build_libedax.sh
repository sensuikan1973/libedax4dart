# NOTE: require some environment variables.
# libedax_build_command (e.g. make libbuild ARCH=x64-modern COMP=gcc OS=osx)
# dst: (e.g. build)

# TODO: https://github.com/lavox/edax-reversi/pull/2 がマージされたら参照先を変える
git clone https://github.com/sensuikan1973/edax-reversi
cd edax-reversi
git switch fix_broken_so_or_dll
# git checkout 50ff6d9bffdf9661707a98decbd7152f254a848a

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

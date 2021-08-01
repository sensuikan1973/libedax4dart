git clone https://github.com/sensuikan1973/edax-reversi
cd edax-reversi
git remote update --prune

git checkout .

git switch libedax_sensuikan1973
git pull
git checkout $(cat ../.libedax-version)

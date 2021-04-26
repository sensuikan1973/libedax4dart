# $1: dst
# $2: compiler

dst_file="$1/env.txt"

touch $dst_file

echo "=== libedax4dart sha ===" >> $dst_file
echo $GITHUB_SHA >> $dst_file

echo "=== libedax sha ===" >> $dst_file
cat .libedax-version >> $dst_file

echo "=== os image ===" >> $dst_file
echo $ImageOS >> $dst_file

echo "=== dart version ===" >> $dst_file
dart --version >> $dst_file 2>&1

echo "=== $2 version ===" >> $dst_file
$2 --version >> $dst_file

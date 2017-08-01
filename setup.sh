#!/bin/sh

set -eu
name=${1:?slide名を引数に実行してください}

mkdir $name

LINK="https://vividmuimui.github.io/slides/$name/slides"
if ! grep -e "$LINK" README.md > /dev/null
then
    echo "- [$name]($LINK)" >> README.md
fi

cd $name

cp ../config.yml ./
echo "title: ${name}" >> config.yml

mkdir slides
touch slide.md
reveal-ck generate -f slide.md -d slides
cp -r ../css ./

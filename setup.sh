#!/bin/sh

set -eu
name=${1:?slide名を引数に実行してください}

mkdir $name
cd $_

cp ../config.yml ./
echo "title: ${name}" >> config.yml
cp -r ../css ./

touch slide.md

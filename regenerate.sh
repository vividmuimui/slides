#!/bin/sh

set -eu
name=${1:?slide名を引数に実行してください}

mv $name/slide.md ./ # 退避
rm -rf $name
./setup.sh $name
mv -f slide.md $name/
./generate.sh $name

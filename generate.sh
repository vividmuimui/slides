#!/bin/sh

set -eu

name=${1:?slide名を引数に実行してください}

reveal-ck generate -f $name/slide.md -d $name

LINK="https://vividmuimui.github.io/slides/$name"
if ! grep -e "$LINK" README.md > /dev/null
then
    echo "- [$name]($LINK)" >> README.md
fi

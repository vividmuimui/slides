#!/bin/sh

set -eu

name=${1:?slide名を引数に実行してください}

reveal-ck serve -f $name/slide.md -d $name

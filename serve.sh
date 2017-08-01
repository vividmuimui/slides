#!/bin/sh

set -eu

name=${1:?slide名を引数に実行してください}

cd $name
reveal-ck server -f slide.md -d slides

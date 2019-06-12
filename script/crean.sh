#!/bin/bash

set -eu

PACKAGEDIR="$(git rev-parse --show-toplevel)/package/"
DIRECTORIES=(
  'pkg'
  'src'
)
FILES=(
  'Packages'
)
FILE_EXTENSIONS=(
  'deb'
  '*.tar.*'
  'ttf'
  'zip'
  '7z'
)

cd ${PACKAGEDIR}

for dir in ${DIRECTORIES[@]}; do
  rm -rf */${dir}/
  rm -rf AUR/*/${dir}/
done

for file in ${FILES[@]}; do
  rm -rf */${file}
  rm -rf AUR/*/${file}
done

for file_extension in ${FILE_EXTENSIONS[@]}; do
  rm -rf */*.${file_extension}
  rm -rf AUR/*/*.${file_extension}
done

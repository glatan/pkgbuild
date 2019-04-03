#!/bin/bash

set -eu

PACKAGEDIR="$(git rev-parse --show-toplevel)/package/"

cd ${PACKAGEDIR}

rm -rf */pkg/ */src/
rm */*.pkg.*\
  */*.tar.*\
  */*.ttf\
  */*.zip\
  */*.7z

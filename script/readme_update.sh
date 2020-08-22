#!/usr/bin/env bash

set -u

# Update README.md(## Packages)
# Remove old list
sed -i -z 's/|.*|\n//g'  README.md
# copy latest local db
cp -f release/glarch.db release/sync/glarch.db
packages="$(pacman -S -b release/ -l glarch | awk '{printf "|%s|%s|\\n", $2, $3}')"
# Write new list
sed -i -z "s/## Packages\n\n/## Packages\n\n|Name|Version|\n|-|-|\n${packages}/g" README.md

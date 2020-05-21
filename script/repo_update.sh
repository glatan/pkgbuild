#!/usr/bin/env bash

set -u

declare -r REPOSITORY_NAME='glarch'

git lfs pull

repo-add -R -p -n release/${REPOSITORY_NAME}.db.tar.zst release/*.pkg.tar.zst
mv -f release/${REPOSITORY_NAME}.db.tar.zst release/${REPOSITORY_NAME}.db
mv -f release/${REPOSITORY_NAME}.files.tar.zst release/${REPOSITORY_NAME}.files
rm release/${REPOSITORY_NAME}.*.old

git lfs track release/*.pkg.tar.zst

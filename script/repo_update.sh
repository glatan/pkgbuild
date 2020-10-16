#!/usr/bin/env bash

set -u

declare -r REPOSITORY_NAME='glarch'

git lfs pull

repo-add -R -p -n release/${REPOSITORY_NAME}.db.tar.zst release/*.pkg.tar.zst
# ${REPONAME}.{db,files}.tar.{SOMETYPES} => ${REPONAME}.{db,files}
mv -f release/${REPOSITORY_NAME}.db.tar.zst release/${REPOSITORY_NAME}.db
mv -f release/${REPOSITORY_NAME}.files.tar.zst release/${REPOSITORY_NAME}.files
for oldfile in release/"${REPOSITORY_NAME}".{db,files}.*.old; do
    [[ -e "${oldfile}" ]] && rm "${oldfile}"
done

for oldpkg in $(git status -s ./release/ | grep -E '^\sD' | awk '{print $2}'); do
    # untrack old pkgfile
    git lfs untrack "${oldpkg}"
done
for newpkg in $(git status -s ./release/ | grep -E '^\?\?' | awk '{print $2}'); do
    # track new pkgfile
    git lfs track "${newpkg}"
    git add "${newpkg}"
done

sort .gitattributes > tmpfile && mv tmpfile .gitattributes

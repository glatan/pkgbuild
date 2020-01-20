#!/usr/bin/env bash

set -u

if [[ ! -d "package/${1}" ]]; then
    mkdir "package/${1}"
    cp '/usr/share/pacman/PKGBUILD.proto' "package/${1}/PKGBUILD"
    # Replace md5sums to sha512sums and b2sums.
    sed -i -e "s/md5sums=()/sha512sums=()\\nb2sums=()/g" "package/${1}/PKGBUILD"
else
    echo "Cannot create directory '${1}': File exists"
fi

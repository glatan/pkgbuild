#!/usr/bin/env bash

set -u

declare -r PATH_ROOT="$(pwd)"
declare -r PATH_PACKAGE_ROOT="$(pwd)/package"
declare -r CLEAN_SCRIPT="${PATH_ROOT}/script/clean.sh"
declare -a TARGET_PACKAGE          # build target packages
declare -i FLAG_REBUILD='0'        # 0: build, 1: rebuild
declare -i FLAG_UPDPKGSUMS='0'     # 0: skip updpkgsums, 1: run updpkgsums and exit

while (( $# > 0 )); do
    case "${1}" in
        --rebuild)        FLAG_REBUILD='1'; shift ;;
        --updpkgsums)     FLAG_UPDPKGSUMS='1'; shift ;;
        -*)               exit ;;
        *)                TARGET_PACKAGE+=("${1}"); shift ;;
    esac
done

if [[ "${FLAG_UPDPKGSUMS}" -eq '0' ]]; then
    curl 'https://www.archlinux.org/mirrorlist/?country=JP&use_mirror_status=on' | sed 's/#Server/Server/' > /etc/pacman.d/mirrorlist
    pacman -Syy
fi

for package in "${TARGET_PACKAGE[@]}"; do
    if [[ -d "${PATH_PACKAGE_ROOT}/${package}" ]]; then
        if [[ "${FLAG_UPDPKGSUMS}" -eq '1' ]]; then
            # Update checksum in makepkg
            cd "${PATH_PACKAGE_ROOT}/${package}" || exit
            su makepkg -c 'updpkgsums'
            break
        fi
        # build and packaging
        cd "${PATH_PACKAGE_ROOT}/${package}" || exit
        su makepkg -c 'makepkg -s --noconfirm'
    fi
done

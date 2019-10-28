#!/usr/bin/env bash

set -u

declare -r REPOSITORY_PATH='/makepkg'
declare -r PACKAGE_ROOT_PATH="${REPOSITORY_PATH}/package"
declare -r CLEAN_SCRIPT="${REPOSITORY_PATH}/script/clean.sh"
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
    pacman -Sy
fi
for package in "${TARGET_PACKAGE[@]}"; do
    if [[ -d "${PACKAGE_ROOT_PATH}/${package}" ]]; then
        if [[ "${FLAG_UPDPKGSUMS}" -eq '1' ]]; then
            # Update checksum in makepkg
            cd "${PACKAGE_ROOT_PATH}/${package}" || exit
            su makepkg -c 'updpkgsums'
            break
        fi
        # Clean cache before build
        if [[ "${FLAG_REBUILD}" -eq '1' ]]; then
            cd "${REPOSITORY_PATH}" || exit
            ${CLEAN_SCRIPT} --remove "${package}"
        fi
        # build and packaging
        cd "${PACKAGE_ROOT_PATH}/${package}" || exit
        su makepkg -c 'makepkg -s --noconfirm'
    fi
done

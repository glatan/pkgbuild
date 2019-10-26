#!/usr/bin/env bash

set -u

declare -r REPOSITORY_PATH='/makepkg'
declare -r PACKAGE_ROOT_PATH="${REPOSITORY_PATH}/package"
declare -r CLEAN_SCRIPT="${REPOSITORY_PATH}/script/clean.sh"
declare -a TARGET_PACKAGE     # build target packages
declare -i REBUILD='0'        # 0: build, 1: rebuild

while (( $# > 0 )); do
    case "${1}" in
        --rebuild)     REBUILD='1'; shift ;;
        -*)            exit ;;
        *)             TARGET_PACKAGE+=("${1}"); shift ;;
    esac
done

pacman -Sy

for package in "${TARGET_PACKAGE[@]}"; do
    cd "${PACKAGE_ROOT_PATH}" || exit
    if [[ -d "${package}" ]]; then
        # Clean cache before build
        if [[ "${REBUILD}" -eq '1' ]]; then
            ${CLEAN_SCRIPT} --remove "${package}"
        fi
        cd "${package}" || exit
        su makepkg -c 'makepkg -s --noconfirm'
    fi
done

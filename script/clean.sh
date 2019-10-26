#!/usr/bin/env bash

set -u

declare -r REPOSITORY_PATH='/makepkg'
declare DRYRUN='echo'                                           # echo(default): dry-run, rm -r: remove
declare -r ALL_CACHE='*/*/* */*/.*'                             # all makepkg's cache
declare -r BUILD_CACHE='*/*/pkg */*/src */*/.* */*/*.pkg.*'     # makepkg's build cache
declare REMOVE_TARGET="${BUILD_CACHE}"                          # meta val
declare -a TARGET_PACKAGE                                       # remove target package
declare ALL_PACKAGES='0'                                        # 0: all packages, 1: choosed package

while (( $# > 0 )); do
    case "${1}" in
        --remove)           DRYRUN='rm -r'; shift ;;
        --all-cache)        REMOVE_TARGET="${ALL_CACHE}"; shift ;;
        --all-packages)     ALL_PACKAGES='1'; shift ;;
        -*)                 exit ;;
        *)                  TARGET_PACKAGE+=("${1}"); shift ;;
    esac
done

# build directory
cd "${REPOSITORY_PATH}" || exit

# Clear cache
# All packages
if [[ "${ALL_PACKAGES}" -eq '1' ]]; then
    REMOVE_FILES=("$(git check-ignore ${REMOVE_TARGET})")
    if [[ -n "${REMOVE_FILES[*]}" ]]; then
        ${DRYRUN} ${REMOVE_FILES[@]}
    fi
# Choosed packages
else
    for package in "${TARGET_PACKAGE[@]}"; do
        if [[ -d "package/${package}/" ]]; then
            REMOVE_FILES=("$(git check-ignore ${REMOVE_TARGET} | grep "package/${package}/")")
            if [[ -n "${REMOVE_FILES[*]}" ]]; then
                ${DRYRUN} ${REMOVE_FILES[@]}
            fi
        fi
    done
fi

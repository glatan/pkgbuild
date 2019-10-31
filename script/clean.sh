#!/usr/bin/env bash

set -u

declare DRYRUN='echo'                                           # echo(default): dry-run, rm -r: remove
declare -r ALL_CACHE='*/*/* */*/.*'                             # all makepkg's cache
declare -r BUILD_CACHE='*/*/pkg */*/src */*/.* */*/*.pkg.* */AUR/*/pkg */AUR/*/src */AUR/*/.* */AUR/*/*.pkg.*'     # makepkg's build cache
declare REMOVE_MODE="${BUILD_CACHE}"                            # meta val
declare -a TARGET_PACKAGE                                       # remove target package
declare ALL_PACKAGES='0'                                        # 0: all packages, 1: choosed package

while (( $# > 0 )); do
    case "${1}" in
        --remove)           DRYRUN='rm -r'; shift ;;
        --all-cache)        REMOVE_MODE="${ALL_CACHE}"; shift ;;
        --all-packages)     ALL_PACKAGES='1'; shift ;;
        -*)                 exit ;;
        *)                  TARGET_PACKAGE+=("${1}"); shift ;;
    esac
done

# Clear cache
# All packages
if [[ "${ALL_PACKAGES}" -eq '1' ]]; then
    REMOVE_TARGET=("$(git check-ignore ${REMOVE_MODE})")
    if [[ -n "${REMOVE_TARGET[*]}" ]]; then
        ${DRYRUN} ${REMOVE_TARGET[@]}
    fi
# Choosed packages
else
    for package in "${TARGET_PACKAGE[@]}"; do
        if [[ -d "package/${package}/" ]]; then
            REMOVE_TARGET=("$(git check-ignore ${REMOVE_MODE} | grep "package/${package}/")")
            if [[ -n "${REMOVE_TARGET[*]}" ]]; then
                ${DRYRUN} ${REMOVE_TARGET[@]}
            fi
        fi
    done
fi

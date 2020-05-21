#!/usr/bin/env bash

set -u

declare EXIT_CODE='0'

# Input: array
# Output: string
compare_versions() {
    IFS=" " read -r -a versions <<< "$(</dev/stdin)"
    _result=${versions[0]}
    for version in "${versions[@]}"; do
        [[ $(vercmp "${version}" "${_result}") -eq '1' ]] && _result="${version}"
    done
    echo -n "${_result}"
}

# $1: pkgname, $2: remote_pkgver, $3: latest_pkgver $4
print_ressult() {
    eval "printf \"${ESC}[m%-${MAX_PKGNAME_LENGTH}s${ESC}[m\t\" $1"
    eval "printf \"${ESC}[m%-${MAX_REPOPKG_VERSION_LENGTH}s${ESC}[m\t\" $2"
    eval "printf \"${ESC}[${FONT_WIDTH}%s${ESC}[m\n\" $3"
}

declare -r REPOSITORY_NAME='glarch'
declare -A REMOTE_REPOSITORY # Key: pkgname, Value: pkgver

declare MAX_PKGNAME_LENGTH='7' # echo -n 'package' | wc -m
declare MAX_REPOPKG_VERSION_LENGTH='10' # echo -n 'repository' | wc -m
pacman -Sy --noconfirm -b release/
for pkg in $(pacman -Sl ${REPOSITORY_NAME} -b release | awk '{printf "%s:%s\n", $2, $3}'); do
    _pkgname="$(echo "${pkg}" | awk -F ':' '{print $1}')"
    _repopkg_version="$(echo "${pkg}" | awk -F ':' '{print $2}' | awk -F '-' '{print $1}')"
    _pkgname_length="$(echo -n "${_pkgname}" | wc -m)"
    _repopkg_version_length="$(echo -n "${_repopkg_version}" | wc -m)"
    [[ "${_pkgname_length}" -gt "${MAX_PKGNAME_LENGTH}" ]] && MAX_PKGNAME_LENGTH="${_pkgname_length}"
    [[ "${_repopkg_version_length}" -gt "${MAX_REPOPKG_VERSION_LENGTH}" ]] && MAX_REPOPKG_VERSION_LENGTH="${_repopkg_version_length}"
    REMOTE_REPOSITORY["${_pkgname}"]="${_repopkg_version}"
done

cd package/ || exit

declare -r NEEDS_UPDATE='32;1m' # 太字・緑
declare -r INVALID_VERSION='31;1m' # 太字・赤
declare -r DEFAULT_TEXT='0m' # 変更なし
declare FONT_WIDTH="${DEFAULT_TEXT}"
declare ESC && ESC=$(printf '\033')

eval "printf \"%-${MAX_PKGNAME_LENGTH}s\t%-${MAX_REPOPKG_VERSION_LENGTH}s\t%s\n\" 'Package' 'Repository' 'Latest' "
for pkg in *; do
    [[ -e "${pkg}/.checkupdate" ]] || continue
    cd "${pkg}" || exit
    source '.checkupdate'
    _remote_version="${REMOTE_REPOSITORY["${pkg}"]}"
    _latest_version="$(latest_version)"
    case "$(vercmp "${_remote_version}" "${_latest_version}")" in
        '1' ) FONT_WIDTH="${INVALID_VERSION}"; EXIT_CODE='1' ;; # greater than
        '0' ) FONT_WIDTH="${DEFAULT_TEXT}" ;; # equal
        '-1') FONT_WIDTH="${NEEDS_UPDATE}"; EXIT_CODE='1' ;; # less than
        * ) exit ;;
    esac
    print_ressult "${pkg}" "${_remote_version}" "${_latest_version}"
    cd ../ || exit
done

exit "${EXIT_CODE}"

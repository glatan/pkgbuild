#!/usr/bin/env bash

set -u

cd "package/${1}" || exit

# Japan, Use mirror status
curl 'https://archlinux.org/mirrorlist/?country=JP&use_mirror_status=on' | sed 's/#Server/Server/' > /etc/pacman.d/mirrorlist
pacman -Syy

chown -R makepkg ./

if su makepkg -c 'makepkg -C -f -s --noconfirm'; then
    source PKGBUILD
    chown root:root "${1}-${pkgver}-${pkgrel}-${arch}.pkg.tar.zst"
    mv "${1}-${pkgver}-${pkgrel}-${arch}.pkg.tar.zst" ../../release
fi

chown -R root ./

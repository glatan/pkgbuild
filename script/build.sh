#!/usr/bin/env bash

set -u

cd "package/${1}" || exit

# Japan, Use mirror status
curl 'https://archlinux.org/mirrorlist/?country=JP&use_mirror_status=on' | sed 's/#Server/Server/' > /etc/pacman.d/mirrorlist
pacman -Syy

chown -R makepkg ./

if su makepkg -c 'makepkg -f -s --noconfirm'; then
    source PKGBUILD
    # "${1}-${pkgver}-${pkgrel}-${arch}.pkg.tar.zst"だと linux,
    # linux-headers, linux-docsみたいに複数パッケージを一括ビルド
    # する場合に対応できないためこうなっている。
    chown root:root ./*"${pkgver}-${pkgrel}-${arch}.pkg.tar.zst"
    mv ./*"${pkgver}-${pkgrel}-${arch}.pkg.tar.zst" ../../release
fi

chown -R root ./

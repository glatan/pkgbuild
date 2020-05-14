FROM archlinux/base:latest

RUN : \
    # Install packages for makepkg
    && pacman -Syyu --noconfirm \
    && pacman -S --noconfirm \
        base-devel \
        git \
        pacman-contrib \
    # Add user for makepkg
    && useradd -m -g users -s /usr/bin/bash makepkg \
    && echo 'makepkg ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers \
    # Add packager to makepkg.conf
    && sed -i -e "s/#PACKAGER=\"John Doe <john@doe.com>\"/PACKAGER='glatan <glatan.edu@gmail.com>'/g" /etc/makepkg.conf \
    # Change package compression alogolithm
    # zstd is faster than xz
    && sed -i -e "s/pkg.tar.xz/pkg.tar.zst/g" /etc/makepkg.conf \
    # Proxy
    && echo 'Defaults env_keep="http_proxy https_proxy"' >> /etc/sudoers \
    # Clear cache
    && rm -rf \
        /usr/share/doc/* \
        /usr/share/man/* \
        /var/cache/pacman/pkg/* \
        /var/lib/pacman/sync/*

CMD ["/usr/bin/bash"]

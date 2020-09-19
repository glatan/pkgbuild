FROM archlinux/base:latest

RUN : \
    # Install packages for makepkg
    && pacman -Syyu --noconfirm \
    && pacman -S --noconfirm \
        base-devel \
        git \
        git-lfs \
        jq \
        pacman-contrib \
        rsync \
    # Add user for makepkg
    && useradd -m -g users -s /usr/bin/bash makepkg \
    && echo 'makepkg ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers \
    # apply my dotfiles
    && curl 'https://dotfiles.glatan.vercel.app' > install.sh \
    && bash install.sh --apply-root \
    # Proxy
    && echo 'Defaults env_keep="http_proxy https_proxy"' >> /etc/sudoers \
    # Clear cache
    && rm -rf \
        /usr/share/doc/* \
        /usr/share/man/* \
        /var/cache/pacman/pkg/* \
        /var/lib/pacman/sync/*

CMD ["/usr/bin/bash"]

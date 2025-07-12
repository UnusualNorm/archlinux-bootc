FROM ghcr.io/archlinux/archlinux:base-devel AS builder
RUN pacman -Sy && \
    useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER builder
COPY makepkgs.sh /makepkgs.sh
COPY --chown=builder:builder PKGBUILDS /PKGBUILDS
RUN /makepkgs.sh -cs --noconfirm


FROM ghcr.io/archlinux/archlinux:base
COPY pre /
COPY --from=builder /PKGBUILDS /tmp/PKGBUILDS
RUN mv /var/lib/pacman /usr/lib/pacman && \
    sed -i 's|^#\(DBPath\s*=\s*\).*|DBPath = /usr/lib/pacman|' /etc/pacman.conf && \
    pacman -Sy --noconfirm linux linux-firmware ostree && \
    pacman -U --noconfirm /tmp/PKGBUILDS/*.pkg.tar.zst && \
    pacman -Scc --noconfirm && \
    rm -rf /tmp/PKGBUILDS \
           /home /root /usr/local /srv \
           /boot/* /var/cache/* /var/db/* /var/lib/* /var/log/*
COPY post /
RUN bootc container lint
LABEL containers.bootc=1

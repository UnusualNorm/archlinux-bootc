FROM ghcr.io/archlinux/archlinux:base-devel AS builder
RUN pacman -Sy && \
    useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER builder
COPY makepkgs.sh /makepkgs.sh
COPY --chown=builder:builder PKGBUILDS /PKGBUILDS
RUN /makepkgs.sh -cs --noconfirm


FROM ghcr.io/archlinux/archlinux:base-devel AS bootstrapper
COPY --from=builder /PKGBUILDS /tmp/PKGBUILDS
COPY files /mnt
RUN pacman -Sy --noconfirm arch-install-scripts && \
    pacstrap /mnt --overwrite '*' base grub linux linux-firmware ostree && \
    pacstrap -U /mnt /tmp/PKGBUILDS/*.pkg.tar.zst && \
    mv /mnt/var/lib/pacman /mnt/usr/lib/pacman && \
    rm -r /mnt/var/cache/* /mnt/var/db/* /mnt/var/lib/* /mnt/var/log/*


FROM scratch
COPY --from=bootstrapper /mnt /
RUN bootc container lint
LABEL containers.bootc=1
ENTRYPOINT [ "/bin/bash" ]

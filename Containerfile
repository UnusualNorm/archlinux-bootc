FROM ghcr.io/archlinux/archlinux:base-devel AS builder
RUN pacman -Sy && \
    useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    install -d -o builder /bootc
USER builder
WORKDIR /bootc
COPY PKGBUILD .
RUN makepkg -cs --noconfirm


FROM ghcr.io/archlinux/archlinux:base-devel AS bootstrapper
COPY --from=builder /bootc/bootc-*.pkg.tar.zst /tmp
COPY files /mnt
RUN pacman -Sy --noconfirm arch-install-scripts && \
    pacstrap /mnt base linux linux-firmware dosfstools e2fsprogs btrfs-progs && \
    pacstrap -U /mnt /tmp/bootc-*.pkg.tar.zst && \
    mv /mnt/var/lib/pacman /mnt/usr/lib/pacman


FROM scratch
LABEL containers.bootc=1
COPY --from=bootstrapper /mnt /

# RUN pacman -S whois --noconfirm && \
#     usermod -p "$(echo "changeme" | mkpasswd -s)" root

RUN pacman -Scc --noconfirm && \
    # nonempty-boot
    rm -rf /boot/* && \
    # var-log
    rm -rf /var/log/* && \
    # var-tmpfiles
    rm -rf /var/cache/* /var/log/* /var/db/* /var/lib/* && \
    bootc container lint

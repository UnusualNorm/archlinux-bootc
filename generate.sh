truncate -s 10G image.raw
sudo podman run \
    --rm \
    --privileged \
    --pid=host \
    --security-opt label=type:unconfined_t \
    -v /dev:/dev \
    -v /var/lib/containers:/var/lib/containers \
    -v .:/output \
    archlinux-bootc \
    bootc install to-disk \
        --generic-image \
        --composefs-backend \
        --filesystem ext4 \
        --bootloader systemd \
        --via-loopback \
        --wipe \
        /output/image.raw

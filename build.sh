mkdir -p cache
sudo podman build \
    --volume $(pwd)/cache:/mnt/var/cache/pacman/pkg \
    --cap-add sys_admin \
    -t archlinux-bootc \
    .

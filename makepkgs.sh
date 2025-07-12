set -e
for dir in PKGBUILDS/*; do
  cd "$dir"
  makepkg $@
  cp *.pkg.tar.zst ../
  cd ../../
done

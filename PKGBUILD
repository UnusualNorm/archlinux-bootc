pkgname=bootc
pkgver=1.10.0
pkgrel=1
pkgdesc="Boot and upgrade via container images"
arch=('x86_64' 'aarch64')
url="https://github.com/containers/bootc"
license=('Apache-2.0' 'MIT')
depends=('composefs' 'ostree' 'skopeo' 'podman')
makedepends=('make' 'openssl' 'systemd' 'cargo')
source=("bootc-${pkgver}.tar.zstd::${url}/releases/download/v${pkgver}/bootc-${pkgver}.tar.zstd"
  "bootc-${pkgver}-vendor.tar.zstd::${url}/releases/download/v${pkgver}/bootc-${pkgver}-vendor.tar.zstd")
sha256sums=('SKIP' 'SKIP')

prepare() {
  cd "${pkgname}-${pkgver}"
  cargo fetch --locked
}

build() {
  cd "${pkgname}-${pkgver}"
  make bin
}

package() {
  cd "${pkgname}-${pkgver}"
  make install-all install-initramfs-dracut DESTDIR="$pkgdir"
}

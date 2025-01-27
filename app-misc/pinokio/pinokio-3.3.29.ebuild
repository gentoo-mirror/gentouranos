# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AI Browser"
HOMEPAGE="https://github.com/pinokiocomputer/pinokio"
SRC_URI="https://github.com/pinokiocomputer/pinokio/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
    dev-lang/python
    dev-util/cmake
    sys-devel/gcc
    x11-libs/qtcore
    x11-libs/qtgui
    x11-libs/qtnetwork
"
RDEPEND="
    ${DEPEND}
"

S=${WORKDIR}/${PN}-${PV}

src_configure() {
    cmake . -B build \
        -DCMAKE_INSTALL_PREFIX=/usr || die "cmake configuration failed"
}

src_compile() {
    cmake --build build || die "Build failed"
}

src_install() {
    cmake --install build --prefix="${D}/usr" || die "Install failed"

    # Install desktop entry and icon
    insinto /usr/share/applications
    echo "[Desktop Entry]" > pinokio.desktop
    echo "Type=Application" >> pinokio.desktop
    echo "Name=Pinokio" >> pinokio.desktop
    echo "Exec=/usr/bin/pinokio" >> pinokio.desktop
    echo "Icon=/usr/share/icons/hicolor/256x256/apps/pinokio.png" >> pinokio.desktop
    echo "Categories=Utility;" >> pinokio.desktop
    doins pinokio.desktop

    # Optionally install the icon (if available)
    insinto /usr/share/icons/hicolor/256x256/apps
    newins "${FILESDIR}/icon.png" pinokio.png
}

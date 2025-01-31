# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The next-generation collaborative knowledge base for teams"
HOMEPAGE="https://affine.pro/"
SRC_URI="https://github.com/toeverything/AFFiNE/archive/refs/tags/v${PV}.tar.gz \
         mirror://local/affine-deps.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
    dev-lang/node
    dev-util/yarn
    net-libs/nodejs
    sys-apps/bubblewrap
    "
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="dev-lang/node dev-util/yarn"

S="${WORKDIR}/AFFiNE-${PV}"

src_unpack() {
    default
    cd "${S}" || die "Failed to enter source directory"
    tar xzf "${DISTDIR}/affine-deps.tar.gz" -C "${S}" || die "Failed to extract dependencies"
}

src_prepare() {
    default
}

src_compile() {
    yarn build --offline || die "Build failed"
}

src_install() {
    dodir /opt/affine
    cp -r "${S}/dist" "${D}/opt/affine/" || die
    
    dosym /opt/affine/dist/affine /usr/bin/affine
    
    make_desktop_entry affine "AFFiNE" "affine" "Office;"
}


# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The next-generation collaborative knowledge base for teams"
HOMEPAGE="https://affine.pro/"
SRC_URI="https://github.com/toeverything/AFFiNE/archive/refs/tags/v${PV}.tar.gz \
         https://github.com/OuraN2O/gentouranos/releases/download/affine/affine-deps.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
    dev-util/yarn
    net-libs/nodejs
    sys-apps/bubblewrap
    "
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="net-libs/nodejs dev-util/yarn"

S="${WORKDIR}/AFFiNE-${PV}"

src_unpack() {
    default
    cd "${S}" || die "Failed to enter source directory"
    tar xzf "${DISTDIR}/affine-deps.tar.gz" -C "${S}" || die "Failed to extract dependencies"
}

src_prepare() {
    default
    rm -f "${S}/yarn.lock" || die "Failed to remove yarn.lock"

    echo 'enableNetwork: false' > "${S}/.yarnrc.yml" || die "Failed to create .yarnrc.yml"
}

src_compile() {
    yarn install --offline || die "Dependency installation failed"
    yarn build || die "Build failed"
}

src_install() {
    dodir /opt/affine
    cp -r "${S}/dist" "${D}/opt/affine/" || die
    
    dosym /opt/affine/dist/affine /usr/bin/affine
    
    make_desktop_entry affine "AFFiNE" "affine" "Office;"
}


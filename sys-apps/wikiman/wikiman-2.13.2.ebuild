# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wikiman is an offline search engine for manual pages, Arch Wiki, Gentoo Wiki and other documentation."
HOMEPAGE="https://github.com/filiparag/wikiman".
SRC_URI="https://github.com/filiparag/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-shells/fzf
	virtual/w3m
	sys-apps/coreutils
	sys-apps/findutils
	sys-apps/man-db
	sys-apps/mawk
	sys-apps/ripgrep
	sys-process/parallel
	"
RDEPEND="${DEPEND}"
BDEPEND="dev-build/make"

src_prepare() {
    default
    sed -i 's|/usr/local|/usr|' Makefile || die "Failed to patch Makefile"
}

src_install() {
    emake all || die "emake install failed"
}

pkg_postinst() {
    elog "Run 'wikiman -u' to update the database. 
	See 'https://github.com/filiparag/wikiman?tab=readme-ov-file#additional-documentation-sources' to install 
	additional sources"
}

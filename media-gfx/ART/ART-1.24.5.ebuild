# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ART (Another RawTherapee) - A free, open-source, cross-platform raw image processing program"
HOMEPAGE="https://art.pixls.us/"
SRC_URI="https://github.com/artpixls/ART/releases/download/${PV}/${P}-linux64.tar.xz"
S="${WORKDIR}/${P}-linux64"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="imageio jpegxl openmp tcmalloc"

RDEPEND="
	dev-cpp/glibmm
	dev-cpp/gtkmm:3.0
	dev-libs/mimalloc
	dev-util/desktop-file-utils
	llvm-runtimes/openmp
	media-gfx/exiv2
	media-libs/ctl
	media-libs/exiftool
	media-libs/lcms:2
	media-libs/lensfun
	media-libs/libcanberra
	media-libs/libiptcdata
	media-libs/libraw
	media-libs/opencolorio
	media-libs/openexr
	sci-libs/fftw
	x11-libs/gtk+:3
	imageio? ( media-libs/openimageio )
	jpegxl? ( media-libs/libjxl:= )
	tcmalloc? ( dev-util/google-perftools )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# upstream tested that "fast-math" give wrong results, so filter it
	# https://bugs.gentoo.org/show_bug.cgi?id=606896#c2
	filter-flags -ffast-math
	# -Ofast enable "fast-math" both in gcc and clang
	replace-flags -Ofast -O3
	# In case we add an ebuild for klt we can (i)use that one,
	# see http://cecas.clemson.edu/~stb/klt/
	local mycmakeargs=(
		-DOPTION_OMP=$(usex openmp)
		-DDOCDIR=/usr/share/doc/${PF}
		-DCREDITSDIR=/usr/share/${PN}
		-DLICENCEDIR=/usr/share/${PN}
		-DCACHE_NAME_SUFFIX=""
		-DWITH_SYSTEM_KLT="off"
		-DWITH_SYSTEM_LIBRAW="on"
		-DENABLE_TCMALLOC=$(usex tcmalloc)
		-DWITH_JXL=$(usex jpegxl)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}


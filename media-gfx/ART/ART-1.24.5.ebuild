# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ART (Another RawTherapee) - A free, open-source, cross-platform raw image processing program"
HOMEPAGE="https://art.pixls.us/"
SRC_URI="https://github.com/artpixls/ART/releases/download/${PV}/${P}.tar.xz"


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


pkg_setup() {
	if use openmp; then
		echo "OpenMP is enabled"
	fi
}

src_configure() {
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
	cmake -B build -S "${S}" "${mycmakeargs[@]}" || die "CMake configuration failed"
}

src_compile() {
	emake -C build || die "Compilation failed"
}

src_install() {
	emake -C build install DESTDIR="${D}" || die "Installation failed"
	domenu "${S}/data/art.desktop"
	insinto /usr/share/icons/hicolor/scalable/apps
	doins "${S}/data/art.svg"
}

pkg_postinst() {
	xdg-icon-resource forceupdate --theme hicolor
	update-desktop-database -q
}

pkg_postrm() {
	xdg-icon-resource forceupdate --theme hicolor
	update-desktop-database -q
}

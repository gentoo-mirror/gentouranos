# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Self-hosted music player for your local audio files"
HOMEPAGE="https://swingmx.com/"
SRC_URI="
    https://github.com/swingmx/swingmusic/releases/download/v${PV}/swingmusic_linux_amd64 -> swingmusic_linux_amd64-${PV}
    https://raw.githubusercontent.com/swingmx/swingmusic/refs/tags/v${PV}/LICENSE -> LICENSE-${PV}
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror bindist strip"
IUSE=""

DEPEND=""
RDEPEND="
    media-video/ffmpeg
    dev-libs/libev
    ${DEPEND}
    "
BDEPEND=""

S="${WORKDIR}"

src_install() {

    exeinto /usr/bin
    newexe "${DISTDIR}/swingmusic_linux_amd64-${PV}" swingmusic

    # licence
    dodir /usr/share/licenses/${PN}
    cp "${DISTDIR}/LICENSE-${PV}" "${ED}/usr/share/licenses/${PN}/LICENSE" || die

    # Icône 
    insinto /usr/share/icons/hicolor/256x256/apps
    newins "${FILESDIR}/swingmusic.png" swingmusic.png

    # Fichier .desktop
    cat > "${T}/swingmusic.desktop" <<-EOF
        [Desktop Entry]
        Name=Swing Music
        Comment=Self-hosted music player
        Exec=/usr/bin/swingmusic
        Icon=swingmusic
        Terminal=false
        Type=Application
        Categories=AudioVideo;Player;
    EOF

    domenu "${T}/swingmusic.desktop" 
}
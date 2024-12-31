# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="gstreamer1-plugins-sndio-${PV}"

inherit toolchain-funcs

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/BSDKaffee/gstreamer1-plugins-sndio/archive/refs/tags/v${PV}.tar.gz
	-> ${MY_P}.tar.gz
"

DESCRIPTION="Sndio audio sink and source for GStreamer"
HOMEPAGE="https://github.com/BSDKaffee/gstreamer1-plugins-sndio"
LICENSE="ISC"
SLOT="0"
RDEPEND="
	media-libs/gst-plugins-base:1.0
	media-sound/sndio:=
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	tc-export CC
	default
}

src_install() {
	export BSD_INSTALL_LIB="install -m 444"
	default
}

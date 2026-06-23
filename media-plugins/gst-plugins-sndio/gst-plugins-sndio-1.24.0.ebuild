# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="gstreamer1-plugins-sndio-${PV}"

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"

CHKL_TIMESTAMPS=(
	"media-sound/sndio-9999"
)

inherit cflags-hardened chkl secure-version toolchain-funcs

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
IUSE="
ebuild_revision_23
"
RDEPEND="
	>=media-sound/sndio-${SNDIO_PV}:=
	media-libs/gst-plugins-base:=
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	gstreamer_multilib_src_configure
}

src_compile() {
	tc-export CC
	default
}

src_install() {
	export BSD_INSTALL_LIB="install -m 444"
	default
}

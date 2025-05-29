# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="SO"
GST_ORG_MODULE="gst-plugins-base"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
# Everything below is for building opusparse from gst-plugins-bad. Once it moves into -base, all below can be removed
SRC_URI+=" https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${PV}.tar.${GST_TARBALL_SUFFIX}"

DESCRIPTION="Opus audio parser plugin for GStreamer"
IUSE="
ebuild_revision_12
"
CDEPEND="
	>=media-libs/opus-0.9.4:=[${MULTILIB_USEDEP}]
"
RDEPEND="
	${CDEPEND}
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="
	${CDEPEND}
"

src_prepare() {
	default
	gstreamer_system_package audio_dep:gstreamer-audio \
		pbutils_dep:gstreamer-pbutils \
		tag_dep:gstreamer-tag
}

in_bdir() {
	pushd "${BUILD_DIR}" || die
	"$@"
	popd || die
}

src_configure() {
	cflags-hardened_append
	S="${WORKDIR}/gst-plugins-base-${PV}" \
	multilib_foreach_abi gstreamer_multilib_src_configure
	S="${WORKDIR}/gst-plugins-bad-${PV}"  \
	multilib_foreach_abi gstreamer_multilib_src_configure
}

src_compile() {
	S="${WORKDIR}/gst-plugins-base-${PV}" \
	multilib_foreach_abi in_bdir gstreamer_multilib_src_compile
	S="${WORKDIR}/gst-plugins-bad-${PV}"  \
	multilib_foreach_abi in_bdir gstreamer_multilib_src_compile
}

src_install() {
	S="${WORKDIR}/gst-plugins-base-${PV}" \
	multilib_foreach_abi in_bdir gstreamer_multilib_src_install
	S="${WORKDIR}/gst-plugins-bad-${PV}"  \
	multilib_foreach_abi in_bdir gstreamer_multilib_src_install
}

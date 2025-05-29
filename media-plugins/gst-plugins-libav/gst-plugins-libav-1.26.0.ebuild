# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 58.60.60 - 6.1.x
# 57.59.59 - 5.1.x
# 56.58.58 - 4.4.x

MY_PN="gst-libav"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN}-${MY_PV}"

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_P}.tar.xz"

DESCRIPTION="A FFmpeg based GStreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
LICENSE="LGPL-2+"
SLOT="1.0"
IUSE="
ebuild_revision_12
"
RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	~media-libs/gstreamer-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	|| (
		media-video/ffmpeg:58.60.60[${MULTILIB_USEDEP}]
		media-video/ffmpeg:57.59.59[${MULTILIB_USEDEP}]
		media-video/ffmpeg:56.58.58[${MULTILIB_USEDEP}]
		<media-video/ffmpeg-7:0[${MULTILIB_USEDEP}]
	)
	media-video/ffmpeg:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

src_configure() {
	local prefix=""
	_configure() {
		cflags-hardened_append
		if has_version "media-video/ffmpeg:58.60.60" ; then # 6.1.x
einfo "Using ffmpeg 6.1.x multislot"
			prefix="usr/lib/ffmpeg/58.60.60"
		elif has_version "media-video/ffmpeg:57.59.59" ; then # 5.1.x
einfo "Using ffmpeg 5.1.x multislot"
			prefix="usr/lib/ffmpeg/57.59.59"
		elif has_version "media-video/ffmpeg:56.58.58" ; then # 4.4.x
einfo "Using ffmpeg 4.4.x multislot"
			prefix="usr/lib/ffmpeg/56.58.58"
		elif has_version "media-video/ffmpeg:0" ; then
einfo "Using ffmpeg monoslot"
			prefix="usr"
		fi
		export PKG_CONFIG_PATH="/${prefix}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH}"
		gstreamer_multilib_src_configure
	}
	multilib_foreach_abi _configure
}

src_install() {
	local prefix=""
	_install() {
		cd "${BUILD_DIR}" || die
		gstreamer_multilib_src_install
		if has_version "media-video/ffmpeg:58.60.60" ; then # 6.1.x
			prefix="usr/lib/ffmpeg/58.60.60"
		elif has_version "media-video/ffmpeg:57.59.59" ; then # 5.1.x
			prefix="usr/lib/ffmpeg/57.59.59"
		elif has_version "media-video/ffmpeg:56.58.58" ; then # 4.4.x
			prefix="usr/lib/ffmpeg/56.58.58"
		else
			prefix="usr"
		fi
		local x
		for x in $(ls "${ED}/usr/$(get_libdir)/gstreamer-1.0/"*".so"* ) ; do
			[[ -L "${x}" ]] && continue
einfo "Adding /${prefix} to rpath for ${x}"
			patchelf --add-rpath "/${prefix}/$(get_libdir)" "${x}" || die
		done
	}
	multilib_foreach_abi _install
}

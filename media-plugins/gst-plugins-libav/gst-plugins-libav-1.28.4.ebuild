# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 58.60.60 - 6.1.x
# 57.59.59 - 5.1.x
# 56.58.58 - 4.4.x

MY_PN="gst-libav"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN}-${MY_PV}"

CFLAGS_HARDENED_USE_CASES="plugin security-critical untrusted-data"

# Forced FFmpeg live for mitigation
CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"media-video/ffmpeg-9999"
	"media-video/ffmpeg-9999m"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_P}.tar.xz"

DESCRIPTION="A FFmpeg based GStreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
LICENSE="LGPL-2+"
SLOT="1.0"
IUSE+="
ebuild_revision_28
"
RDEPEND="
	>=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}]
	~media-libs/gstreamer-${MY_PV}:=[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${MY_PV}:=[${MULTILIB_USEDEP}]
	media-video/ffmpeg:=
	|| (
		~media-video/ffmpeg-9999[${MULTILIB_USEDEP}]
		~media-video/ffmpeg-9999m[${MULTILIB_USEDEP}]

		~media-video/ffmpeg-8.1.2[${MULTILIB_USEDEP}]
		~media-video/ffmpeg-8.1.2m[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

src_configure() {
	chkl_check_many_timestamps
	local prefix=""
	_configure() {
		cflags-hardened_append
		if has_version "media-video/ffmpeg:60.62.62" ; then # 8.x
einfo "Using FFmpeg multislot"
			prefix="usr/lib/ffmpeg/58.60.60"
		elif has_version "media-video/ffmpeg:0" ; then
einfo "Using FFmpeg monoslot"
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
		if has_version "media-video/ffmpeg:60.62.62" ; then # 8.x
			prefix="usr/lib/ffmpeg/60.62.62"
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

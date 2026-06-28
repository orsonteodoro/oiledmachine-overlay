# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#
# Supported FFmpeg versions supported for this ebuild:
#
# 61.63.63 - live
# 60.62.62 - 8.0 (U26), 8.1 (F44)
# 59.61.61 - 7.1 (D13, F43)
# 0 - 7.1, 8.0, 8.1, live
#
# Support is based on CI testing and security updates.
#

# For version see:  https://github.com/GStreamer/gstreamer/blob/1.28.4/subprojects/FFmpeg.wrap

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
	$(secure-version_gen_ffmpeg_depends '7.1-' '[${MULTILIB_USEDEP}]')
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

get_ffmpeg_prefix() {
	local L=(
		"61.63.63" # live
		"60.62.62" # 8.0, 8.1
		"59.61.61" # 7.1, same slot used by upstream
		"0" # monoslot
	)
	prefix=""
	local x
	for x in "${L[@]}" ; do
		if has_version "media-video/ffmpeg:${x}" ; then # 8.x
			if [[ "${x}" == "0" ]] ; then
einfo "Using FFmpeg monoslot"
				prefix="usr"
			else
einfo "Using FFmpeg multislot"
				prefix="usr/lib/ffmpeg/${x}"
			fi
			break
		fi
	done
	[[ -z "${prefix}" ]] && die "You must install >= ffmpeg 7.1"
	echo "${prefix}"
}

src_configure() {
	chkl_check_many_timestamps
	local prefix=""
	_configure() {
		cflags-hardened_append
		prefix=$(get_ffmpeg_prefix)
		if [[ "${prefix}" == "usr" ]] && has_version "<media-video/ffmpeg-7.1:0" ; then
eerror "Monoslotted FFmpeg < 7.1 is not supported.  Emerge a FFmpeg 7.1 or"
eerror "later multislot or update the FFmpeg monoslot to >= 7.1."
			die
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
		prefix=$(get_ffmpeg_prefix)
		local x
		for x in $(ls "${ED}/usr/$(get_libdir)/gstreamer-1.0/"*".so"* ) ; do
			[[ -L "${x}" ]] && continue
einfo "Adding /${prefix} to rpath for ${x}"
			patchelf --add-rpath "/${prefix}/$(get_libdir)" "${x}" || die
		done
	}
	multilib_foreach_abi _install
}

# Copyright 2022 Orson Teodoro
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild is just an extension of libva ebuild-package.  The libva package
# makes no effort to sort out drivers.  I do not prefer to maintain a ebuild
# fork of libva.

EAPI=8

inherit multilib-build

DESCRIPTION="A metapackage for libva drivers"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux" # Same as libva
SLOT="0"

IUSE_VAAPI="
video_cards_amdgpu
video_cards_intel
video_cards_iris
video_cards_i965
video_cards_nouveau
video_cards_nvidia
video_cards_r600
video_cards_radeonsi
"

IUSE+="
${IUSE_VAAPI}
custom
"

REQUIRED_USE+="
	!custom? (
		video_cards_amdgpu? (
			!video_cards_r600
			!video_cards_radeonsi
		)
		video_cards_r600? (
			!video_cards_amdgpu
			!video_cards_radeonsi
		)
		video_cards_radeonsi? (
			!video_cards_amdgpu
			!video_cards_r600
		)
		|| ( ${IUSE_VAAPI} )
	)
"

FFMPEG_PV="3.4.2"
LIBVA_PV="2.1.0"
MESA_PV="18"
RDEPEND_DRIVERS="
	|| (
		video_cards_amdgpu? (
			media-libs/mesa:=[${MULTILIB_USEDEP},vaapi,video_cards_radeonsi]
		)
		video_cards_i965? (
			|| (
				x11-libs/libva-intel-media-driver
				x11-libs/libva-intel-driver[${MULTILIB_USEDEP}]
			)
		)
		video_cards_intel? (
			|| (
				x11-libs/libva-intel-media-driver
				x11-libs/libva-intel-driver[${MULTILIB_USEDEP}]
			)
		)
		video_cards_iris? (
			x11-libs/libva-intel-media-driver
		)
		video_cards_nouveau? (
			media-libs/mesa:=[${MULTILIB_USEDEP},video_cards_nouveau]
			|| (
				media-libs/mesa:=[vaapi,video_cards_nouveau,${MULTILIB_USEDEP}]
				>=x11-libs/libva-vdpau-driver-0.7.4-r3[${MULTILIB_USEDEP}]
			)
		)
		video_cards_nvidia? (
			>=x11-libs/libva-vdpau-driver-0.7.4-r1[${MULTILIB_USEDEP}]
			x11-drivers/nvidia-drivers
		)
		video_cards_r600? (
			media-libs/mesa:=[${MULTILIB_USEDEP},vaapi,video_cards_r600]
		)
		video_cards_radeonsi? (
			media-libs/mesa:=[${MULTILIB_USEDEP},vaapi,video_cards_radeonsi]
		)
	)

"

RDEPEND+="
	>=media-libs/libva-${LIBVA_PV}
	!custom? (
		${RDEPEND_DRIVERS}
	)
"
PDEPEND="
	!custom? (
		>=media-video/ffmpeg-${FFMPEG_PV}[${MULTILIB_USEDEP},vaapi]
	)
"

pkg_postinst() {
	if has_version "x11-libs/libva-intel-driver" ; then
ewarn
ewarn "x11-libs/libva-intel-driver is the older vaapi driver but intended for"
ewarn "select hardware.  See also x11-libs/libva-intel-media-driver package"
ewarn "to access more vaapi accelerated encoders if driver support overlaps."
ewarn
	fi

	if use vaapi ; then
		if \
			   use video_cards_intel \
			|| use video_cards_i965 \
			|| use video_cards_iris ; then
einfo
einfo "Intel Quick Sync Video is required for hardware accelerated H.264 VA-API"
einfo "encode."
einfo
einfo "For hardware support, see the AVC row at"
einfo "https://en.wikipedia.org/wiki/Intel_Quick_Sync_Video#Hardware_decoding_and_encoding"
einfo
einfo "Driver ebuild packages for their corresponding hardware can be found at:"
einfo
einfo "x11-libs/libva-intel-driver:"
einfo "https://github.com/intel/intel-vaapi-driver/blob/master/NEWS"
einfo
einfo "x11-libs/libva-intel-media-driver:"
einfo "https://github.com/intel/media-driver#decodingencoding-features"
einfo
		fi
		if use video_cards_amdgpu \
			|| use video_cards_r600 \
			|| use video_cards_radeonsi  ; then
einfo
einfo "You need VCE (Video Code Engine) or VCN (Video Core Next) for"
einfo "hardware accelerated H.264 VA-API encode."
einfo
einfo "For details see"
einfo
einfo "  https://en.wikipedia.org/wiki/Video_Coding_Engine#Feature_overview"
einfo
einfo "or"
einfo
einfo "  https://www.x.org/wiki/RadeonFeature/"
einfo
einfo "The r600 driver only supports ARUBA for VCE encode."
einfo "For newer hardware, try a newer free driver like"
einfo "the radeonsi driver or closed drivers."
einfo
		fi
einfo
einfo "Some drivers may require firmware for proper VA-API support."
einfo
einfo "The user must be part of the video group to use VAAPI support."
einfo
einfo "The LIBVA_DRIVER_NAME envvar may need to be changed if both open"
einfo "and closed drivers are installed to one of the following"
einfo
		has_version "x11-libs/libva-intel-driver" \
			&& einfo "  LIBVA_DRIVER_NAME=\"i965\""
		has_version "x11-libs/libva-intel-media-driver" \
			&& einfo "  LIBVA_DRIVER_NAME=\"iHD\""
		use video_cards_r600 \
			&& einfo "  LIBVA_DRIVER_NAME=\"r600\""
		( use video_cards_radeonsi || use video_cards_amdgpu ) \
			&& einfo "  LIBVA_DRIVER_NAME=\"radeonsi\""
einfo
einfo "to your ~/.bashrc or ~/.xinitrc and relogging."
einfo
	fi
}

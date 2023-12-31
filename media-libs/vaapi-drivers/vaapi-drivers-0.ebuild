# Copyright 2022 Orson Teodoro
# Copyright 1999-2023 Gentoo Authors
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
		|| ( ${IUSE_VAAPI} )
	)
"

RDEPEND_DRIVERS="
	|| (
		video_cards_amdgpu? (
			media-libs/mesa:=[${MULTILIB_USEDEP},vaapi,video_cards_radeonsi]
		)
		video_cards_intel? (
			|| (
				media-libs/libva-intel-media-driver
				media-libs/libva-intel-driver[${MULTILIB_USEDEP}]
			)
		)
		video_cards_nouveau? (
			|| (
				(
					media-libs/mesa:=[${MULTILIB_USEDEP},vaapi,video_cards_nouveau]
				)
				(
					>=media-libs/libva-vdpau-driver-0.7.4-r3[${MULTILIB_USEDEP}]
					media-libs/mesa:=[${MULTILIB_USEDEP},vdpau,video_cards_nouveau]
				)
			)
		)
		video_cards_nvidia? (
			|| (
				>=media-libs/libva-vdpau-driver-0.7.4-r1[${MULTILIB_USEDEP}]
				media-plugins/nvidia-vaapi-driver
			)
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
	media-libs/libva
	!custom? (
		${RDEPEND_DRIVERS}
	)
"

pkg_postinst() {
	if has_version "media-libs/libva-intel-driver" ; then
ewarn
ewarn "media-libs/libva-intel-driver is the older VA-API driver but intended for"
ewarn "Gen 4 and earlier.  See also media-libs/libva-intel-media-driver package"
ewarn "for Gen 5 or later to access more VA-API accelerated encoders if driver"
ewarn "support overlaps."
ewarn
	fi
einfo
einfo "See the metadata.xml or epkginfo -x ${CATEGORY}/${PN} for hardware"
einfo "requirements."
ewarn
ewarn "Some drivers may require firmware packages installed."
ewarn
ewarn "The user must be part of the video group to use VA-API support."
ewarn
einfo "The LIBVA_DRIVER_NAME environment variable may need to be changed if"
einfo "multiple VA-API drivers are installed to one of the following to to your"
einfo "~/.bashrc or ~/.xinitrc and relogging:"
einfo
einfo "  media-libs/libva-intel-driver:        LIBVA_DRIVER_NAME=\"i965\""
einfo "  media-libs/libva-intel-media-driver:  LIBVA_DRIVER_NAME=\"iHD\""
einfo "  USE=video_cards_r600:                 LIBVA_DRIVER_NAME=\"r600\""
einfo "  USE=video_cards_radeonsi:             LIBVA_DRIVER_NAME=\"radeonsi\""
einfo "  USE=video_cards_amdgpu:               LIBVA_DRIVER_NAME=\"radeonsi\""
einfo
}

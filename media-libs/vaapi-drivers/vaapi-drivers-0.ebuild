# Copyright 2022 Orson Teodoro
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild is just an extension of libva ebuild-package.  The libva package
# makes no effort to sort out drivers.  I do not prefer to maintain a ebuild
# fork of libva.

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Metapackage for to libva drivers"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux" # Same as libva
SLOT="0"

IUSE_VAAPI="
video_cards_amdgpu
video_cards_intel
video_cards_iris
video_cards_i965
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
	)
"

FFMPEG_PV="3.4.2"
LIBVA_PV="2.1.0"
MESA_PV="18"
RDEPEND_DRIVERS="
	|| (
		video_cards_amdgpu? (
			>=media-libs/mesa-${MESA_PV}[vaapi,video_cards_radeonsi]
		)
		video_cards_i965? (
			|| (
				x11-libs/libva-intel-media-driver
				x11-libs/libva-intel-driver
			)
		)
		video_cards_intel? (
			|| (
				x11-libs/libva-intel-media-driver
				x11-libs/libva-intel-driver
			)
		)
		video_cards_iris? (
			x11-libs/libva-intel-media-driver
		)
		video_cards_r600? (
			>=media-libs/mesa-${MESA_PV}[vaapi,video_cards_r600]
		)
		video_cards_radeonsi? (
			>=media-libs/mesa-${MESA_PV}[vaapi,video_cards_radeonsi]
		)
	)
"

RDEPEND+="
	>=media-libs/libva-${LIBVA_PV}
	!custom? (
		${RDEPEND_DRIVERS}
		>=media-video/ffmpeg-${FFMPEG_PV}[vaapi]
	)
"

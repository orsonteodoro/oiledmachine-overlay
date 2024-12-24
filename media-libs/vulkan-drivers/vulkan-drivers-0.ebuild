# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

S="${WORKDIR}"
VIDEO_DRIVERS=(
	video_cards_amdgpu
	video_cards_intel
	video_cards_nouveau
	video_cards_nvidia
	video_cards_nvk
)

DESCRIPTION="Vulkan drivers"
LICENSE="
	metapackage
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${VIDEO_DRIVERS[@]}
amdvlk radv
"
REQUIRED_USE="
	|| (
		${VIDEO_DRIVERS[@]}
	)
	amdvlk? (
		video_cards_amdgpu
	)
	radv? (
		video_cards_amdgpu
	)
	video_cards_amdgpu? (
		|| (
			amdvlk
			radv
		)
	)
"
RDEPEND+="
	video_cards_amdgpu? (
		amdvlk? (
			|| (
				media-libs/amdvlk[${MULTILIB_USEDEP}]
				media-libs/amdvlk-bin[${MULTILIB_USEDEP}]
			)
		)
		radv? (
			media-libs/mesa[${MULTILIB_USEDEP},video_cards_amdgpu,vulkan]
		)
	)
	video_cards_intel? (
		media-libs/mesa[${MULTILIB_USEDEP},video_cards_intel,vulkan]
	)
	video_cards_nouveau? (
		media-libs/mesa[${MULTILIB_USEDEP},video_cards_nouveau,vulkan]
	)
	video_cards_nvk? (
		media-libs/mesa[${MULTILIB_USEDEP},video_cards_nvk,vulkan]
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers[${MULTILIB_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

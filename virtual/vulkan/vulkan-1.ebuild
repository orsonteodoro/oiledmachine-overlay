# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17 # LTS
_VIDEO_CARDS=(
	"video_cards_intel"
	"video_cards_lavapipe"
	"video_cards_nouveau"
	"video_cards_nvidia"
	"video_cards_nvk"
	"video_cards_radeonsi"
	"video_cards_vmware"
	"video_cards_zink"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)

inherit libcxx-slot libstdcxx-slot

KEYWORDS="~amd64"
S="${WORKDIR}"

DESCRIPTION="A virtual ebuild for Vulkan drivers"
HOMEPAGE="
"
LICENSE="
	metapackage
"
RESTRICT="mirror"
SLOT="0/1" # 0/API_MAJOR
IUSE+="
${_VIDEO_CARDS[@]}
amdvlk radv
"
REQUIRED_USE="
	video_cards_nvk? (
		video_cards_nouveau
	)
	video_cards_nouveau? (
		video_cards_nvk
	)
	video_cards_radeonsi? (
		|| (
			amdvlk
			radv
		)
	)
"
RDEPEND+="
	dev-util/vulkan-headers:=
	media-libs/vulkan-loader
	video_cards_intel? (
		media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},vulkan,video_cards_intel]
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers
	)
	video_cards_lavapipe? (
		media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},vulkan,video_cards_lavapipe]
	)
	video_cards_nvk? (
		media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},vulkan,video_cards_nvk]
	)
	video_cards_radeonsi? (
		amdvlk? (
			media-libs/amdvlk
		)
		radv? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},vulkan,video_cards_radeonsi]
		)
	)
	video_cards_vmware? (
		media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},vulkan,video_cards_vmware]
	)
	video_cards_zink? (
		media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},vulkan,video_cards_zink]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

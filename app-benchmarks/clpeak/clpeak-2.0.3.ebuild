# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild has been created with the help of AI inference.

CXX_STANDARD=11
LIBOPENCL_STUB="c34834a65f89ca5e7115395d6e86892eaf2bba38"

_VIDEO_CARDS=(
	"video_cards_freedreno"
	"video_cards_intel"
	"video_cards_lavapipe"
	"video_cards_nouveau"
	"video_cards_nvidia"
	"video_cards_nvk"
	"video_cards_panfrost"
	"video_cards_r600"
	"video_cards_radeonsi"
	"video_cards_v3d"
	"video_cards_vc4"
	"video_cards_virgl"
	"video_cards_vivante"
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

inherit cmake dep-prepare libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/krrishnarraj/clpeak.git"
	FALLBACK_COMMIT="f846511fe2c99a5fa255c85cb4b40091b9e63bb0" # May 8, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/krrishnarraj/clpeak/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/krrishnarraj/libopencl-stub/archive/${LIBOPENCL_STUB}.tar.gz
	-> libopencl-stub-${LIBOPENCL_STUB:0:7}.tar.gz
	"
fi

DESCRIPTION="A synthetic micro-benchmark that measures the peak achievable performance of GPU compute devices"
HOMEPAGE="
	https://github.com/krrishnarraj/clpeak
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${_VIDEO_CARDS[@]}
amdvlk clover cpu cuda metal neo pocl opencl radv rocm rocm_6_4 rocm_7_0 rusticl vulkan
ebuild_revision_2
"
REQUIRED_USE="
	!kernel_Darwin? (
		!metal
	)
	cpu? (
		opencl
		pocl
	)
	rocm? (
		rocm_6_4? (
			^^ (
				gcc_slot_12_5
				gcc_slot_13_4
			)
		)
		rocm_7_0? (
			^^ (
				gcc_slot_12_5
				gcc_slot_13_4
			)
		)
		^^ (
			rocm_6_4
			rocm_7_0
		)
	)

	video_cards_freedreno? (
		opencl? (
			rusticl
		)
		|| (
			opencl
		)
	)
	video_cards_intel? (
		opencl? (
			|| (
				rusticl
				neo
			)
		)
		|| (
			opencl
			vulkan
		)
	)
	video_cards_lavapipe? (
		opencl? (
			rusticl? (
				video_cards_zink
			)
			video_cards_zink? (
				rusticl
			)
		)
		vulkan
	)

	video_cards_nvk? (
		video_cards_nouveau
	)
	video_cards_nouveau? (
		video_cards_nvk
		opencl? (
			rusticl
		)
		|| (
			opencl
			vulkan
		)
	)
	video_cards_nvidia? (
		|| (
			cuda
			opencl
		)
	)
	video_cards_panfrost? (
		opencl? (
			rusticl
		)
	)
	video_cards_r600? (
		opencl? (
			clover
		)
		|| (
			opencl
		)
	)
	video_cards_radeonsi? (
		opencl? (
			|| (
				rusticl
				rocm
			)
		)
		vulkan? (
			|| (
				amdvlk
				radv
			)
		)
	)
	video_cards_v3d? (
		opencl? (
			rusticl
		)
	)
	video_cards_vc4? (
		opencl? (
			rusticl
		)
	)
	video_cards_vivante? (
		opencl
	)
	video_cards_vmware? (
		opencl? (
			clover
		)
		|| (
			opencl
			vulkan
		)
	)
	|| (
		cuda
		metal
		opencl
		vulkan
	)
"
CUDA_3_2="
	(
		=dev-util/nvidia-cuda-toolkit-13.2*
		>=x11-drivers/nvidia-drivers-595.45.04
	)
"
RDEPEND+="
	opencl? (
		pocl? (
			dev-libs/pocl[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
		video_cards_intel? (
			rusticl? (
				media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_intel]
			)
			neo? (
				dev-libs/intel-compute-runtime
			)
		)
		video_cards_nouveau? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_nouveau]
		)
		video_cards_nvk? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_nvk]
		)
		video_cards_nvidia? (
			x11-drivers/nvidia-drivers
		)
		video_cards_panfrost? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_panfrost]
		)
		video_cards_r600? (
			clover? (
				<media-libs/mesa-25.2.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_r600]
			)
		)
		video_cards_radeonsi? (
			rusticl? (
				media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_radeonsi]
			)
			rocm? (
				rocm_6_4? (
					dev-libs/rocm-opencl-runtime:0/6.4[${LIBSTDCXX_USEDEP}]
				)
				rocm_7_0? (
					dev-libs/rocm-opencl-runtime:0/7.0[${LIBSTDCXX_USEDEP}]
				)
			)
		)
		video_cards_v3d? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_v3d]
		)
		video_cards_vc4? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_vc4]
		)
		video_cards_vivante? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_vivante]
		)
		video_cards_virgl? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_virgl]
		)
		video_cards_vmware? (
			clover? (
				<media-libs/mesa-25.2.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_vvmware]
			)
		)
		video_cards_zink? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl,video_cards_zink]
		)
	)
	cuda? (
		|| (
			${CUDA_3_2}
		)
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers:=
	)
	vulkan? (
		media-libs/vulkan-loader
		video_cards_intel? (
			media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},vulkan,video_cards_intel]
		)
		video_cards_nvidia? (
			x11-drivers/nvidia-drivers
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
	)
"
DEPEND+="
	${RDEPEND}
	vulkan? (
		dev-util/vulkan-headers
	)
"
BDEPEND+="
	>=dev-build/cmake-3.20
"
DOCS=( "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	dep_prepare_mv "${WORKDIR}/libopencl-stub-${LIBOPENCL_STUB}" "${S}/android/app/src/main/cpp/libopencl-stub"
}

src_configure() {
	local mycmakeargs=(
		-DCLPEAK_ENABLE_CUDA=$(usex cuda)
		-DCLPEAK_ENABLE_METAL=$(usex metal)
		-DCLPEAK_ENABLE_VULKAN=$(usex vulkan)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

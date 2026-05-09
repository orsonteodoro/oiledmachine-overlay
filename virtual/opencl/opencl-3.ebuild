# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild and metadata.xml contains data obtained by AI inference.

CXX_STANDARD=17 # LTS
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

inherit libcxx-slot libstdcxx-slot multilib-build

KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DESCRIPTION="A virtual for OpenCL 3.0 drivers"
LICENSE="
	metapackage
"
SLOT="0/3" # 0/API_VERSION
IUSE+="
${_VIDEO_CARDS[@]}
clover cpu iocl neo neo-legacy pocl opencl orca rocm rocm_6_4 rocm_7_0
rusticl vulkan
ebuild_revision_3
"
REQUIRED_USE="
	cpu? (
		|| (
			iocl
			pocl
		)
	)
"
RDEPEND+="
	>=dev-libs/opencl-icd-loader-2023.02.06[${MULTILIB_USEDEP}]
	dev-cpp/clhpp:=
	clover? (
		<media-libs/mesa-25.2.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},opencl]
	)
	iocl? (
		dev-util/intel-ocl-sdk
	)
	pocl? (
		dev-libs/pocl[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	rusticl? (
		media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},llvm,opencl]
	)
	video_cards_intel? (
		rusticl? (
			media-libs/mesa[video_cards_intel]
		)
		neo? (
			>=dev-libs/intel-compute-runtime-25.05.32567.12
		)
		neo-legacy? (
			<dev-libs/intel-compute-runtime-25.05.32567.12
		)
	)
	video_cards_nouveau? (
		media-libs/mesa[video_cards_nouveau]
	)
	video_cards_nvk? (
		media-libs/mesa[video_cards_nvk]
	)
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers
	)
	video_cards_panfrost? (
		media-libs/mesa[video_cards_panfrost]
	)
	video_cards_r600? (
		clover? (
			<media-libs/mesa-25.2.0[video_cards_r600]
		)
		orca? (
			dev-libs/amdgpu-pro-opencl-legacy[gcc_slot_11_5]
			media-libs/mesa[-opencl]
		)
	)
	video_cards_radeonsi? (
		orca? (
			dev-libs/amdgpu-pro-opencl-legacy[gcc_slot_11_5]
			media-libs/mesa[-opencl]
		)
		rusticl? (
			media-libs/mesa[video_cards_radeonsi]
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
		media-libs/mesa[video_cards_v3d]
	)
	video_cards_vc4? (
		media-libs/mesa[video_cards_vc4]
	)
	video_cards_vivante? (
		media-libs/mesa[video_cards_vivante]
	)
	video_cards_virgl? (
		media-libs/mesa[video_cards_virgl]
	)
	video_cards_vmware? (
		clover? (
			<media-libs/mesa-25.2.0[video_cards_vvmware]
		)
	)
	video_cards_zink? (
		media-libs/mesa[video_cards_zink]
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

src_configure() {
	if use neo ; then
einfo "You are enabling the actively supported Neo for Gen 12 or newer."
	fi
	if use neo-legacy ; then
einfo "You are enabling the legacy supported Neo for Gen8 to Gen11."
	fi
}

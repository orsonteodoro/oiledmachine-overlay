# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="audio"

CXX_STANDARD=17
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

AMDGPU_TARGETS_COMPAT=(
	"gfx803"
	"gfx900"
	"gfx906"
	"gfx908"
)

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_6[@]}"
	"${FFMPEG_COMPAT_SLOTS_5[@]}"
	"${FFMPEG_COMPAT_SLOTS_4[@]}"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit hip-versions
ROCM_VERSIONS=(
	"${HIP_7_2_VERSION}"
)

gen_rocm_iuse() {
	local x
	for x in "${ROCM_VERSIONS[@]}" ; do
		local t="${x%.*}"
		echo "rocm_${t/./_}"
	done
}
ROCM_IUSE=$(gen_rocm_iuse)

inherit distutils-r1 fix-rpath ffmpeg libcxx-slot libstdcxx-slot pypi secure-version rocm

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/pytorch/audio/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
HOMEPAGE="
	https://github.com/pytorch/audio
	https://pypi.org/project/torchaudio
"
LICENSE="
	BSD-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${ROCM_IUSE}
cuda rocm rccl roctracer
ebuild_revision_9
"
REQUIRED_USE="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	rocm? (
		llvm_slot_22
		^^ (
			python_single_target_python3_10
			python_single_target_python3_12
		)
	)
"

gen_rocm_depend() {
	local pv
	for pv in "${ROCM_VERSIONS[@]}" ; do
		local s="0/"$(ver_cut "1-2" "${pv}")
		local u=$(ver_cut "1-2" "${pv}")
		local ROCM_SLOT="${u}"
		u="rocm_${u/./_}"
		echo "
			${u}? (
				~dev-libs/rocm-comgr-${pv}:=[${LIBSTDCXX_USEDEP}]
				~dev-libs/rocm-device-libs-${pv}:=
				~dev-libs/rocr-runtime-${pv}:=[${LIBSTDCXX_USEDEP}]
				~dev-util/hip-${pv}:=[${LIBSTDCXX_USEDEP},rocm]
				~sci-libs/hipCUB-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPCUB),rocm]
				~sci-libs/hipRAND-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPRAND),rocm]
				~sci-libs/hipSPARSE-${pv}:=[${LIBSTDCXX_USEDEP},rocm]
				~sci-libs/hipFFT-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPFFT),rocm]
				~sci-libs/miopen-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep MIOPEN)]
				~sci-libs/rocBLAS-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCBLAS)]
				~sci-libs/rocFFT-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCFFT)]
				~sci-libs/rocRAND-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCRAND)]
				~sci-libs/rocPRIM-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCPRIM)]
				~sci-libs/rocThrust-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCTHRUST)]
				rccl? (
					~dev-libs/rccl-${pv}:=[${LIBSTDCXX_USEDEP},$(get_rocm_usedep RCCL)]
				)
				roctracer? (
					~dev-util/roctracer-${pv}:=[${LIBSTDCXX_USEDEP}]
				)
			)
		"
	done
}

CUDA_12_6_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.6*[profiler]
		>=x11-drivers/nvidia-drivers-560.35
		virtual/cuda-compiler:0/12.6[${LIBSTDCXX_USEDEP}]
	)
"
TRASH="
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/kaldi-io[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
	')
	>=media-sound/sox-14.4.2:=
	$(secure-version_gen_ffmpeg_depends '4.4-61')
	=sci-ml/pytorch-${PV%.*}*:=[${PYTHON_SINGLE_USEDEP}]
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers:=
		virtual/cuda-compiler:=
		|| (
			${CUDA_12_6_RDEPEND}
		)
	)
	rocm? (
		$(gen_rocm_depend)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.5.1-system-libs.patch"
)

pkg_setup() {
	python_setup
	if use rocm_7_2 ; then
		export LLVM_SLOT="${HIP_7_2_LLVM_SLOT}"
		export ROCM_SLOT="7.2"
		rocm_pkg_setup
	else
		local s
		for s in "${LLVM_COMPAT[@]}" ; do
			if use "llvm_slot_${s}" ; then
				export LLVM_SLOT="${s}"
				break
			fi
		done
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

python_configure() {
	export USE_CUDA=$(usex cuda 1 0)
	export USE_ROCM=$(usex rocm 1 0)
	export USE_SYSTEM_SOX=1
	if use cuda ; then
		export CUDA_HOME="/opt/cuda"
	fi
	if use rocm ; then
		export ROCM_PATH="/opt/rocm"
	fi

	RPATH_APPEND=(
		"/usr/lib/${EPYTHON}/site-packages/torio/lib"
	)
	ffmpeg_python_configure
	local ffmpeg_slot=$(ffmpeg_get_slot)
	local ffmpeg_major_version=$(ffmpeg_get_major_version)
	if [[ -n "${ffmpeg_slot}" ]] ; then
einfo "Using multislot FFmpeg ${ffmpeg_major_version}"
		RPATH_APPEND=(
			"/usr/lib/ffmpeg/${ffmpeg_slot}/$(get_libdir)"
		)
		export FFMPEG_ROOT="/usr/lib/ffmpeg/${ffmpeg_slot}"
	else
einfo "Using monoslot FFmpeg"
		export FFMPEG_ROOT="/usr"
	fi
	fix-rpath_src_configure
}

src_install() {
	distutils-r1_src_install
}

python_install_all() {
	distutils-r1_python_install_all
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="audio"

CXX_STANDARD=17
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} )

AMDGPU_TARGETS_COMPAT=(
	"gfx803"
	"gfx900"
	"gfx906"
	"gfx908"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
	19
)

inherit hip-versions
ROCM_SLOTS=(
	"${HIP_6_4_VERSION}"
)

gen_rocm_iuse() {
	local x
	for x in ${ROCM_SLOTS[@]} ; do
		local t="${x%.*}"
		echo "rocm_${t/./_}"
	done
}
ROCM_IUSE=$(gen_rocm_iuse)

inherit distutils-r1 fix-rpath libcxx-slot libstdcxx-slot pypi rocm

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
ebuild_revision_3
"
REQUIRED_USE="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	rocm? (
		llvm_slot_19
	)
"

gen_rocm_depend() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s="0/"$(ver_cut 1-2 ${pv})
		local u=$(ver_cut 1-2 ${pv})
		local ROCM_SLOT="${u}"
		u="${u/./_}"
		echo "
			rocm_${u}? (
				>=dev-libs/rocm-comgr-${pv}:${s}[${LIBSTDCXX_USEDEP}]
				dev-libs/rocm-comgr:=
				>=dev-libs/rocm-device-libs-${pv}:${s}
				dev-libs/rocm-device-libs:=
				>=dev-libs/rocr-runtime-${pv}:${s}[${LIBSTDCXX_USEDEP}]
				dev-libs/rocr-runtime:=
				>=dev-util/hip-${pv}:${s}[${LIBSTDCXX_USEDEP},rocm]
				dev-util/hip:=
				>=sci-libs/hipCUB-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPCUB),rocm]
				sci-libs/hipCUB:=
				>=sci-libs/hipRAND-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPRAND),rocm]
				sci-libs/hipRAND:=
				>=sci-libs/hipSPARSE-${pv}:${s}[${LIBSTDCXX_USEDEP},rocm]
				sci-libs/hipSPARSE:=
				>=sci-libs/hipFFT-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep HIPFFT),rocm]
				sci-libs/hipFFT:=
				>=sci-libs/miopen-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep MIOPEN)]
				sci-libs/miopen:=
				>=sci-libs/rocBLAS-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCBLAS)]
				sci-libs/rocBLAS:=
				>=sci-libs/rocFFT-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCFFT)]
				sci-libs/rocFFT:=
				>=sci-libs/rocRAND-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCRAND)]
				sci-libs/rocRAND:=
				>=sci-libs/rocPRIM-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCPRIM)]
				sci-libs/rocPRIM:=
				>=sci-libs/rocThrust-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep ROCTHRUST)]
				sci-libs/rocThrust:=
				rccl? (
					>=dev-libs/rccl-${pv}:${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep RCCL)]
					dev-libs/rccl:=
				)
				roctracer? (
					>=dev-util/roctracer-${pv}:${s}[${LIBSTDCXX_USEDEP}]
					dev-util/roctracer:=
				)
			)
		"
	done
}

CUDA_12_6_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.6*[profiler]
		dev-util/nvidia-cuda-toolkit:=
		>=x11-drivers/nvidia-drivers-560.35
		virtual/cuda-compiler:0/12.6[${LIBSTDCXX_USEDEP}]
		virtual/cuda-compiler:=
	)
"
TRASH="
"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/kaldi-io[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
	')
	>=media-sound/sox-14.4.2
	|| (
		media-video/ffmpeg:58.60.60
		media-video/ffmpeg:57.59.59
		media-video/ffmpeg:56.58.58
		media-video/ffmpeg:0/58.60.60
		media-video/ffmpeg:0/57.59.59
		media-video/ffmpeg:0/56.58.58
	)
	media-video/ffmpeg:=
	=sci-ml/pytorch-${PV%.*}*[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch:=
	cuda? (
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
	if use rocm_6_4 ; then
		export ROCM_SLOT="6.4"
		export LLVM_SLOT=19
	else
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${s}" ; then
				export LLVM_SLOT="${s}"
				break
			fi
		done
	fi
	rocm_pkg_setup
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
	if has_version "media-video/ffmpeg:58.60.60" ; then # 6.x multislot
		export FFMPEG_ROOT="/usr/lib/ffmpeg/58.60.60"
	elif has_version "media-video/ffmpeg:57.59.59" ; then # 5.x multislot
		export FFMPEG_ROOT="/usr/lib/ffmpeg/57.59.59"
	elif has_version "media-video/ffmpeg:56.58.58" ; then # 4.x multislot
		export FFMPEG_ROOT="/usr/lib/ffmpeg/56.58.58"
	elif has_version "media-video/ffmpeg:0/58.58.58" ; then # 6.x unislot
		export FFMPEG_ROOT="/usr"
	elif has_version "media-video/ffmpeg:0/57.59.59" ; then # 5.x unislot
		export FFMPEG_ROOT="/usr"
	elif has_version "media-video/ffmpeg:0/56.58.58" ; then # 4.x unislot
		export FFMPEG_ROOT="/usr"
	fi
}

src_install() {
	distutils-r1_src_install
	local RPATH_FIXES=()
	local x
	for x in $(find "${ED}/usr/lib/${EPYTHON}/site-packages/torio" -name "*ffmpeg*.so*") ; do
		local path=$(ldd "${x}" | grep -q "libav" && echo "${x}")
		if [[ -z "${path}" ]] ; then
				:
		elif has_version "media-video/ffmpeg:58.60.60" ; then # 6.1.x
			RPATH_FIXES+=(
				"${x}:/usr/lib/ffmpeg/58.60.60/$(get_libdir)"
			)
		elif has_version "media-video/ffmpeg:57.59.59" ; then # 4.x
			RPATH_FIXES+=(
				"${x}:/usr/lib/ffmpeg/57.59.59/$(get_libdir)"
			)
		elif has_version "media-video/ffmpeg:56.58.58" ; then # 4.x
			RPATH_FIXES+=(
				"${x}:/usr/lib/ffmpeg/56.58.58/$(get_libdir)"
			)
		fi
	done
	RPATH_FIXES+=(
		"${ED}/usr/lib/${EPYTHON}/site-packages/torio/lib/_torio_ffmpeg.so:/usr/lib/${EPYTHON}/site-packages/torio/lib"
		"${ED}/usr/lib/${EPYTHON}/site-packages/torchaudio/lib/_torchaudio_sox.so:/usr/lib/${EPYTHON}/site-packages/torchaudio/lib"
	)
	fix-rpath_repair
}

python_install_all() {
	distutils-r1_python_install_all
	fix-rpath_verify
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

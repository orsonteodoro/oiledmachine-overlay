# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

# TODO package:
# move dev-python/einops to sci-libs/einops
# hydra-colorlog
# hydra-core

CXX_STANDARD=17
COMPOSABLE_KERNEL_COMMIT="e8709c24f403173ad21a2da907d1347957e324fb"
CUTLASS_COMMIT="dc4817921edda44a549197ff3a9dcf5df0636e7b"
#DISTUTILS_EXT=1 # TODO:  enable if required
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12

AMDGPU_TARGETS_COMPAT=(
	"gfx90a"
	"gfx950"
	"gfx942"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit hip-versions
ROCM_SLOTS=(
	# For RDEPEND
	"${HIP_6_4_VERSION}"
)

gen_rocm_iuse() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local u=$(ver_cut 1-2 "${pv}")
		u="${u/./_}"
		echo "rocm_${u}"
	done
}

ROCM_IUSE=(
	$(gen_rocm_iuse)
)

inherit dep-prepare distutils-r1 libcxx-slot libstdcxx-slot

#KEYWORDS="~amd64" # The ebuild is not install tested
S="${WORKDIR}/flash-attention-${PV}"
SRC_URI="
https://github.com/Dao-AILab/flash-attention/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	rocm? (
https://github.com/ROCm/composable_kernel/archive/${COMPOSABLE_KERNEL_COMMIT}.tar.gz
	-> composable_kernel-${COMPOSABLE_KERNEL_COMMIT:0:7}.tar.gz
	)
	cuda? (
https://github.com/NVIDIA/cutlass/archive/${CUTLASS_COMMIT}.tar.gz
	-> cutlass-${CUTLASS_COMMIT:0:7}.tar.gz
	)
"

DESCRIPTION="Fast and memory-efficient exact attention"
HOMEPAGE="
https://github.com/Dao-AILab/flash-attention
"
LICENSE="
	BSD
	cuda? (
		BSD
		MIT
	)
	rocm? (
		(
			all-rights-reserved
			MIT
		)
	)
"
# all-rights-reserved MIT - csrc/composable_kernel/LICENSE
# BSD - LICENSE
# BSD - csrc/cutlass/python/LICENSE.txt
# MIT - csrc/cutlass/python/docs/_static/scripts/furo.js.LICENSE.txt
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0"
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${ROCM_IUSE[@]}
cuda rocm training
ebuild_revision_3
"
REQUIRED_USE="
	cuda? (
		|| (
			gcc_slot_11_5
			gcc_slot_12_5
			gcc_slot_13_4
			gcc_slot_14_3
			llvm_slot_15
			llvm_slot_16
			llvm_slot_17
			llvm_slot_18
			llvm_slot_19
		)
	)
	rocm? (
		|| (
			gcc_slot_12_5
			gcc_slot_13_4
		)
	)
"
gen_rocm_required_use() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local u=$(ver_cut 1-2 "${pv}")
		u="${u/./_}"
		echo "
			rocm_${u}? (
				rocm
			)
		"
	done
}
gen_rocm_targets_required_use() {
	local g
	for g in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${g}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_required_use)
	$(gen_rocm_targets_required_use)
	^^ (
		cuda
		rocm
	)
	rocm? (
		^^ (
			${ROCM_IUSE[@]}
		)
	)
"
gen_rocm_rdepend() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
	# Check both the direct top and indirect bottom dependencies
		echo "
			rocm_${u}? (
				~dev-build/rocm-cmake-${pv}:${s}
				~dev-util/hip-${pv}:${s}[${LIBSTDCXX_USEDEP},rocm]
			)
		"
	done
}

CUDA_12_6_DEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.6*
		>=x11-drivers/nvidia-drivers-560.35
		virtual/cuda-compiler:0/12.6[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"

CUDA_12_8_DEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.8*
		>=x11-drivers/nvidia-drivers-570.124
		virtual/cuda-compiler:0/12.8[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"

CUDA_12_9_DEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.9*
		>=x11-drivers/nvidia-drivers-575.57
		virtual/cuda-compiler:0/12.9[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"

RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/einops[${PYTHON_USEDEP}]
	')
	(
		|| (
			=sci-ml/pytorch-2.9*[${PYTHON_SINGLE_USEDEP}]
			=sci-ml/pytorch-2.8*[${PYTHON_SINGLE_USEDEP}]
		)
		sci-ml/pytorch:=
	)
	cuda? (
		|| (
			${CUDA_12_6_DEPEND}
			${CUDA_12_8_DEPEND}
			${CUDA_12_9_DEPEND}
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	rocm? (
		$(gen_rocm_rdepend)
	)
	rocm_6_4? (
		|| (
			=sci-ml/pytorch-2.8*[${PYTHON_SINGLE_USEDEP},rocm_6_4]
			=sci-ml/pytorch-2.9*[${PYTHON_SINGLE_USEDEP},rocm_6_4]
		)
		sci-ml/pytorch:=
	)
	training? (
		$(python_gen_cond_dep '
			dev-python/einops[${PYTHON_USEDEP}]
			dev-python/hydra-colorlog[${PYTHON_USEDEP}]
			dev-python/hydra-core[${PYTHON_USEDEP}]
			dev-python/python-dotenv[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
		')
		dev-python/timm[${PYTHON_SINGLE_USEDEP}]
		dev-python/triton[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-build/ninja
	$(python_gen_cond_dep '
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		test? (
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
	test? (
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "AUTHORS" "usage.md" )

distutils_enable_tests "pytest"

pkg_setup() {
	python-single-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	distutils-r1_python_prepare_all
	if use cuda ; then
		dep_prepare_mv "${WORKDIR}/cutlass-${CUTLASS_COMMIT}" "${S}/csrc/cutlass"
		eapply "${FILESDIR}/${PN}-2.6.3-cutlass-hardcoded-paths.patch"
	fi
	if use rocm ; then
		dep_prepare_mv "${WORKDIR}/composable_kernel-${COMPOSABLE_KERNEL_COMMIT}" "${S}/csrc/composable_kernel"
		eapply "${FILESDIR}/${PN}-2.8.3-composable_kernel-hardcoded-paths.patch"
		local ROCM_VERSION
		if use rocm_6_4 ; then
			ROCM_VERSION="${HIP_6_4_VERSION}"
		fi
	fi
}

python_configure() {
	if use cuda ; then
		export BUILD_TARGET="cuda"
	elif use rocm ; then
		export BUILD_TARGET="rocm"
		local list=""
		for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
			if use "amdgpu_targets_${x}" ; then
				list+=";${x}"
			fi
		done
		list="${list:1}"
		export GPU_ARCHS="${list}"
	fi
}

src_install() {
	distutils-r1_src_install
# TODO:  enable if not installed
#	if use training ; then
#		insinto "/usr/share/${PN}"
#		doins -r "${S}/training"
#	fi
}

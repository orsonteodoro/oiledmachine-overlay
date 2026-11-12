# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20

# TODO package:
# move dev-python/einops to sci-libs/einops
# hydra-colorlog
# hydra-core

MY_PV="2.8.3.post2"

CXX_STANDARD=17
COMPOSABLE_KERNEL_COMMIT="e8709c24f403173ad21a2da907d1347957e324fb"
CUTLASS_COMMIT="dc4817921edda44a549197ff3a9dcf5df0636e7b"
#DISTUTILS_EXT=1 # TODO:  enable if required
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} ) # Lists up to 3.13

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	#${LIBCXX_COMPAT_CXX17_CUDA_12[@]/llvm_slot_} # 19
	#${LIBCXX_COMPAT_CXX17_CUDA_13[@]/llvm_slot_} # 19, 21, 22
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_} # 19, 21, 22
	${LIBCXX_COMPAT_ROCM_PYTHON[@]/llvm_slot_} # 14.  Slot for Python use only.
)

inherit dep-prepare distutils-r1 libcxx-slot libstdcxx-slot secure-version rocm-r1

KEYWORDS="~amd64" # The ebuild is not install tested
S="${WORKDIR}/flash-attention-${MY_PV}"
SRC_URI="
https://github.com/Dao-AILab/flash-attention/archive/refs/tags/v${MY_PV}.tar.gz
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
${GCC_COMPAT[@]/#/gcc_slot_}
${LLVM_COMPAT[@]/#/llvm_slot_}
cuda rocm training
ebuild_revision_3
"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	^^ (
		${GCC_COMPAT[@]/#/gcc_slot_}
	)
	cuda? (
		^^ (
			${LIBSTDCXX_COMPAT_STDCXX17[@]}
		)
		^^ (
			${LIBCXX_COMPAT_STDCXX17[@]}
		)
	)
	rocm? (
		llvm_slot_${ROCM_LLVM_SLOT}
	)
"
REQUIRED_USE="
	^^ (
		cuda
		rocm
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
		virtual/cuda:=
		|| (
			virtual/cuda:12[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			virtual/cuda:13[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
	)
	rocm? (
		>=sci-ml/therock-${THEROCK_PV}:=
	)
	rocm? (
		sci-ml/pytorch:=
		|| (
			=sci-ml/pytorch-2.13*[${PYTHON_SINGLE_USEDEP},rocm]
			=sci-ml/pytorch-2.12*[${PYTHON_SINGLE_USEDEP},rocm]
			=sci-ml/pytorch-2.11*[${PYTHON_SINGLE_USEDEP},rocm]
		)
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
	if use rocm ; then
		LLVM_SLOT="${ROCM_LLVM_SLOT}"
		rocm-r1_pkg_setup
	fi
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
	fi
}

python_configure() {
	if use cuda ; then
		export BUILD_TARGET="cuda"
		_gpu_check_llvm "CUDA" "12.6" 18
		_gpu_check_llvm "CUDA" "12.8" {18,19}
		_gpu_check_llvm "CUDA" "12.9" {18,19}
	elif use rocm ; then
		export BUILD_TARGET="rocm"
		export GPU_ARCHS="${ROCM_TARGETS}"
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

# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is the python portion of the package.

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
)
CUDA_TARGETS_COMPAT=(
# Builds for all cards
	auto

# Observed:
	sm_35
	sm_50_plus_ptx
	sm_52
	sm_60
	sm_61
	sm_70
	sm_70_plus_ptx
	sm_75
	sm_80
	sm_86
)
AMDGPU_TARGETS_USEDEP=("${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}")
AMDGPU_TARGETS_USEDEP=("${AMDGPU_TARGETS_USEDEP[@]/%/?}")
AMDGPU_TARGETS_USEDEP="${AMDGPU_TARGETS_USEDEP[@]}"
AMDGPU_TARGETS_USEDEP="${AMDGPU_TARGETS_USEDEP// /,}"
CUDA_TARGETS_USEDEP=("${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}")
CUDA_TARGETS_USEDEP=("${CUDA_TARGETS_USEDEP[@]/%/?}")
CUDA_TARGETS_USEDEP="${CUDA_TARGETS_USEDEP[@]}"
CUDA_TARGETS_USEDEP="${CUDA_TARGETS_USEDEP// /,}"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1

inherit distutils-r1 rocm

SRC_URI="
https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Tensors and Dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
cuda rocm
"
gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	${PYTHON_REQUIRED_USE}
"
ROCM_SLOTS=(
	"5.1.3"
	"5.3.3"
	"5.4.3"
	"5.5.1"
	"5.6.0"
)
gen_rocm_depends() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s="0/"$(ver_cut 1-2 ${pv})
		echo "
			(
				~dev-util/amd-rocm-meta-${pv}:${s}[rocm-dev,rocm-utils,rocm-libs]
				~dev-libs/rccl-${pv}:${s}
				~dev-util/rocprofiler-${pv}:${s}
				~dev-util/roctracer-${pv}:${s}
			)
		"
	done
}
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	~sci-libs/caffe2-${PV}[${AMDGPU_TARGETS_USEDEP},${CUDA_TARGETS_USEDEP},${PYTHON_SINGLE_USEDEP},cuda=,rocm=]
	cuda? (
		cuda_targets_auto? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10*:=
			)
		)
		cuda_targets_sm_35? (
			=dev-util/nvidia-cuda-toolkit-10*:=
		)
		cuda_targets_sm_50_plus_ptx? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_52? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_60? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_61? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_70? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_70_plus_ptx? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_75? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_80? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		cuda_targets_sm_86? (
			=dev-util/nvidia-cuda-toolkit-11*:=
		)
		dev-util/nvidia-cuda-toolkit[profiler]
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
			=dev-util/nvidia-cuda-toolkit-10*:=
		)
	)
	rocm? (
		|| (
			$(gen_rocm_depends)
		)
	)
"
DEPEND="
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	${RDEPEND}
"
BDEPEND="
"
RESTRICT="test"
_PATCHES=(
	"${FILESDIR}/0002-Don-t-build-libtorch-again-for-PyTorch-1.7.1.patch"
	"${FILESDIR}/pytorch-1.9.0-Change-library-directory-according-to-CMake-build.patch"
	"${FILESDIR}/${PN}-2.0.0-global-dlopen.patch"
	"${FILESDIR}/pytorch-1.7.1-torch_shm_manager.patch"
	"${FILESDIR}/${PN}-1.13.0-setup.patch"
	"${FILESDIR}/${PN}-2.0.0-emptyso.patch"
)

src_prepare() {
	eapply ${_PATCHES[@]}

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		tools/setup_helpers/env.py \
		|| die
	distutils-r1_src_prepare
}

src_compile() {
	# Python files only
	# For binaries/libs see caffe2
	local pyargs=(
		BUILD_DIR=
		CMAKE_BUILD_DIR="${BUILD_DIR}"
		PYTORCH_BUILD_VERSION="${PV}"
		PYTORCH_BUILD_NUMBER=0
		USE_SYSTEM_LIBS=ON
	)

	"${pyargs[@]}" \
	distutils-r1_src_compile develop sdist
}

src_install() {
	USE_SYSTEM_LIBS=ON \
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

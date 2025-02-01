# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is the python portion of the package.

# For requirements, see
# https://github.com/pytorch/pytorch/blob/v2.0.1/RELEASE.md?plain=1#L45

AMDGPU_TARGETS_COMPAT=(
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
AMDGPU_TARGETS_UNTESTED=(
	gfx700
	gfx701
	gfx801
	gfx802
	gfx803
	gfx900
	gfx902
	gfx904
#	gfx906
	gfx908
	gfx90a
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1013
	gfx1030
	gfx1031
	gfx1032
	gfx1033
	gfx1034
	gfx1035
)
CUDA_TARGETS_COMPAT=(
# Builds for all cards
	auto

# Observed:
	#sm_35 # Dropped based on RELEASE.md:  Release Compatibility Matrix
	compute_50
	compute_70
	sm_52
	sm_60
	sm_61
	sm_70
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
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Upstream only allows <= 3.10
inherit hip-versions
ROCM_SLOTS=(
# See https://github.com/pytorch/pytorch/blob/v1.13.1/.github/workflows/trunk.yml
	"${HIP_5_2_VERSION}"
)
gen_rocm_slots() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local s="${s%.*}"
		s="${s/./_}"
		echo "rocm_${s}"
	done
}
ROCM_SLOTS2=( $(gen_rocm_slots) )

inherit distutils-r1 flag-o-matic multibuild rocm

SRC_URI="
https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Tensors and dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
LICENSE="BSD"
RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${ROCM_IUSE}
${ROCM_SLOTS2[@]}
cuda rocm
ebuild_revision_1
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
	?? (
		cuda
		rocm
	)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		^^ (
			${ROCM_SLOTS2[@]}
		)
	)
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	~sci-libs/caffe2-${PV}[${AMDGPU_TARGETS_USEDEP},${CUDA_TARGETS_USEDEP},${PYTHON_SINGLE_USEDEP},cuda=,rocm=]
"
DEPEND="
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	${RDEPEND}
"
BDEPEND="
"
_PATCHES=(
	"${FILESDIR}/0002-Don-t-build-libtorch-again-for-PyTorch-1.7.1.patch"
	"${FILESDIR}/${PN}-1.9.0-Change-library-directory-according-to-CMake-build.patch"
	"${FILESDIR}/${P}-global-dlopen.patch"
	"${FILESDIR}/${PN}-1.7.1-torch_shm_manager.patch"
	"${FILESDIR}/${PN}-1.13.0-setup.patch"
	"${FILESDIR}/${P}-emptyso.patch"
	"${FILESDIR}/caffe2-1.13.1-cuda-hardcoded-paths.patch"
	"${FILESDIR}/caffe2-1.13.1-rocm-hardcoded-paths.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_TARGETS_UNTESTED[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

pkg_setup() {
	warn_untested_gpu
	python-single-r1_pkg_setup
	if use rocm_5_2 ; then
		export LLVM_SLOT="14"
		export ROCM_SLOT="5.2"
		export ROCM_VERSION="${HIP_5_2_VERSION}"
	fi
	if use rocm ; then
		rocm_pkg_setup
	fi
}

src_prepare() {
	eapply ${_PATCHES[@]}

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		"tools/setup_helpers/env.py" \
		|| die

	if [[ -n "${ROCM_VERSION}" ]] ; then
		sed -i -e "s|@ROCM_VERSION@|${ROCM_VERSION}|g" $(grep -r -l "@ROCM_VERSION@" "${WORKDIR}") || die
	else
		sed -i -e "s|@ROCM_VERSION@|${HIP_5_2_VERSION}|g" $(grep -r -l "@ROCM_VERSION@" "${WORKDIR}") || die
	fi

	distutils-r1_src_prepare
}

src_compile() {
	# Python files only
	# For binaries/libs see caffe2
	BUILD_DIR="" \
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	PYTORCH_BUILD_VERSION="${PV}" \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	distutils-r1_src_compile
}

src_install() {
	USE_SYSTEM_LIBS=ON \
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

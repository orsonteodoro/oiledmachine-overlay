# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is the Python portion of the package.

# For requirements, see
# https://github.com/pytorch/pytorch/blob/v2.9.0/RELEASE.md?plain=1#L49
 
# Obtained from caffe2 ebuild
AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
AMDGPU_TARGETS_UNTESTED=(
	gfx900
	#gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1200
	gfx1201
)
# See https://github.com/pytorch/pytorch/blob/v2.9.0/.ci/pytorch/windows/cuda126.bat ; min
# See https://github.com/pytorch/pytorch/blob/v2.9.0/.ci/pytorch/windows/cuda130.bat ; max
CUDA_TARGETS_COMPAT=(
# Builds for all cards
	auto

# Observed:
	sm_50
	sm_60
	sm_61
	sm_70
	sm_75
	sm_80
	sm_86
	sm_90
	sm_100
	sm_120

	compute_50
	compute_60
	compute_70
	compute_75
	compute_80
	compute_86
	compute_90
	compute_100
	compute_120
)
AMDGPU_TARGETS_USEDEP=("${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}")
AMDGPU_TARGETS_USEDEP=("${AMDGPU_TARGETS_USEDEP[@]/%/?}")
AMDGPU_TARGETS_USEDEP="${AMDGPU_TARGETS_USEDEP[@]}"
AMDGPU_TARGETS_USEDEP="${AMDGPU_TARGETS_USEDEP// /,}"
CUDA_TARGETS_USEDEP=("${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}")
CUDA_TARGETS_USEDEP=("${CUDA_TARGETS_USEDEP[@]/%/?}")
CUDA_TARGETS_USEDEP="${CUDA_TARGETS_USEDEP[@]}"
CUDA_TARGETS_USEDEP="${CUDA_TARGETS_USEDEP// /,}"

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..14} )

inherit distutils-r1 prefix

SRC_URI="
https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Tensors and dynamic neural networks in Python"
HOMEPAGE="https://pytorch.org/"
LICENSE="BSD"
RESTRICT="test"
SLOT="0"
#KEYWORDS="~amd64 ~arm64" # Unfinished ebuild
IUSE="
${AMDGPU_TARGETS_COMPAT[@]/#/amdgpu_targets_}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
cuda rocm
ebuild_revision_1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	~sci-ml/caffe2-${PV}[${AMDGPU_TARGETS_USEDEP},${CUDA_TARGETS_USEDEP},${PYTHON_SINGLE_USEDEP},cuda=,rocm=]
	sci-ml/caffe2:=
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
#	"${FILESDIR}/${PN}-2.5.1-dontbuildagain.patch"
#	"${FILESDIR}/${PN}-1.9.0-Change-library-directory-according-to-CMake-build.patch"
#	"${FILESDIR}/${PN}-2.4.0-global-dlopen.patch"
	"${FILESDIR}/${PN}-2.5.1-torch_shm_manager.patch"
#	"${FILESDIR}/${PN}-2.5.1-setup.patch"
#	"${FILESDIR}/${PN}-2.2.1-emptyso.patch"
	"${FILESDIR}/caffe2-2.9.0-cuda-hardcoded-paths.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	eapply ${_PATCHES[@]}

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		"tools/setup_helpers/env.py" \
		|| die
	distutils-r1_src_prepare

	hprefixify "tools/setup_helpers/env.py"
}

python_compile() {
	# Python files only
	# For binaries/libs see caffe2
	mkdir -p "${BUILD_DIR}" || die
	cd "${S}" || die
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	PYTORCH_BUILD_VERSION="${PV}" \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	distutils-r1_python_compile develop sdist
}

python_install() {
	USE_SYSTEM_LIBS=ON \
	distutils-r1_python_install
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

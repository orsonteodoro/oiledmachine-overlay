# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is the python portion of the package.

# For requirements, see
# https://github.com/pytorch/pytorch/blob/v2.8.0/RELEASE.md?plain=1#L49

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..12} ) # Upstream only allows <= 3.12

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
	~sci-ml/caffe2-${PV}[${PYTHON_SINGLE_USEDEP}]
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
	"${FILESDIR}/${PN}-2.5.1-dontbuildagain.patch"
	"${FILESDIR}/${PN}-1.9.0-Change-library-directory-according-to-CMake-build.patch"
	"${FILESDIR}/${PN}-2.4.0-global-dlopen.patch"
	"${FILESDIR}/${PN}-2.5.1-torch_shm_manager.patch"
	"${FILESDIR}/${PN}-2.5.1-setup.patch"
	"${FILESDIR}/${PN}-2.2.1-emptyso.patch"
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
	if use rocm_6_4 ; then
		export LLVM_SLOT="19"
		export ROCM_SLOT="6.4"
		export ROCM_VERSION="${HIP_6_4_VERSION}"
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

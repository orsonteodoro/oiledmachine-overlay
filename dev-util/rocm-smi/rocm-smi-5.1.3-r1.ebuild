# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=14
PYTHON_COMPAT=( "python3_"{9..10} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake python-r1 rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"
	SRC_URI="
https://github.com/RadeonOpenCompute/rocm_smi_lib/archive/rocm-${PV}.tar.gz
	-> rocm-smi-${PV}.tar.gz
	"
fi

DESCRIPTION="ROCm System Management Interface Library"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"
LICENSE="
	Apache-2.0
	BSD
	MIT
	NCSA-AMD
"
# Apache-2.0 - tests/rocm_smi_test/gtest/googlemock/scripts/generator/LICENSE
# BSD - tests/rocm_smi_test/gtest/googlemock/LICENSE
# MIT - third_party/shared_mutex/LICENSE
# NCSA-AMD - License.txt
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" ebuild_revision_8"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	sys-apps/hwdata
	|| (
		virtual/kfd:5.1
	)
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.6.3
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-gcc12-memcpy.patch"
	"${FILESDIR}/${PN}-5.1.3-hardcoded-paths.patch"
)

pkg_setup() {
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc
	local mycmakeargs=(
		-D_VERSION_MAJOR=$(ver_cut 1 "${PV}")
		-D_VERSION_MINOR=$(ver_cut 2 "${PV}")
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	python_foreach_impl \
		python_newscript \
			"python_smi_tools/rocm_smi.py" \
			"rocm-smi"
	python_foreach_impl \
		python_domodule \
			"python_smi_tools/rsmiBindings.py"
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

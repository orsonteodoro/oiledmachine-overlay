# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=16
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
MY_PN="amdsmi"

inherit cmake python-single-r1 rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_BRANCH="amd-staging"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/amdsmi/"
	FALLBACK_COMMIT="rocm-5.5.1"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm/amdsmi/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/ROCm/amdsmi"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
	NCSA-AMD
"
# MIT - LICENSE
# all-rights-reserved MIT - py-interface/amdsmi_exception.py
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="test" # Not tested
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" doc -esmi test ebuild_revision_1"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND="
	${PYTHON_DEPS}
	|| (
		virtual/kfd-ub:5.7
		virtual/kfd:5.6
		virtual/kfd:5.5
		virtual/kfd:5.4
		virtual/kfd-lb:5.3
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.11
	dev-python/pip
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.8.11
		app-text/texlive-core
		dev-texlive/texlive-latexextra
	)
	test? (
		>=dev-cpp/gtest-1.12.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.1-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-5.5.1-disable-docs.patch" # Causes error
)

pkg_setup() {
	python-single-r1_pkg_setup
	rocm_pkg_setup
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_INSTALL_LIBDIR=$(rocm_get_libdir)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_PREFIX_PATH="${ESYSROOT}${EROCM_PATH}"
		-DENABLE_ESMI_LIB=$(usex esmi)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

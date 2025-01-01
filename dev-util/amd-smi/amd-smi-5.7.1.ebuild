# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ESMI_COMMIT="ee3dce77933da98d70a2e8f7e2f7e4199b723dea" # Aug 28, 2023
LLVM_SLOT=17
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
MY_PN="amdsmi"

inherit cmake flag-o-matic python-single-r1 rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_BRANCH="amd-staging"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/amdsmi/"
	FALLBACK_COMMIT="rocm-5.7.1"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm/amdsmi/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	esmi? (
https://github.com/amd/esmi_ib_library/archive/${ESMI_COMMIT}.tar.gz
	-> esmi-${ESMI_COMMIT:0:7}.tar.gz
https://raw.githubusercontent.com/ROCm/ROCK-Kernel-Driver/rocm-5.7.1/arch/x86/include/uapi/asm/amd_hsmp.h
	-> ROCK-Kernel-Driver-${PV}-amd_hsmp.h
	)
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
	esmi? (
		GPL-2
		Linux-syscall-note
		UoI-NCSA
	)
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
		virtual/kfd-ub:6.1
		virtual/kfd:6.0
		virtual/kfd:5.7
		virtual/kfd:5.6
		virtual/kfd-lb:5.5
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.11
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.8.11
		app-text/texlive-core
		dev-texlive/texlive-latexextra
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
	test? (
		>=dev-cpp/gtest-1.12.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.6.1-hardcoded-paths.patch"
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
	if use esmi ; then
ewarn "You are using an approximate E-SMI snapshot, but the upstream uses an unknown commit.  Use at your own risk."
		ESMI_S_SRC="${WORKDIR}/esmi_ib_library-${ESMI_COMMIT}"
		ESMI_S_DEST="${S}/e_smi_library"
		rm -rf "${ESMI_S_DEST}" || die
		mv "${ESMI_S_SRC}" "${ESMI_S_DEST}" || die
		mkdir -p "${ESMI_S_DEST}/include/asm" || die
		cat \
			"${DISTDIR}/ROCK-Kernel-Driver-${PV}-amd_hsmp.h" \
			> \
			"${ESMI_S_DEST}/include/asm/amd_hsmp.h" \
			|| die
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

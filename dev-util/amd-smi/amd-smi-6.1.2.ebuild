# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Viewer URI:  https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/tree/arch/x86/include/uapi/asm/amd_hsmp.h?h=review-ilpo&id=54aa699e8094efb7d7675fefbc03dfce24f98456
AMD_HSMP_H_DATE="2024-01-03 11:46:22 +0100"
AMD_HSMP_H_COMMIT="54aa699e8094efb7d7675fefbc03dfce24f98456"
ESMI_PV="3.0.3"
LLVM_SLOT=17
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
MY_PN="amdsmi"

inherit cmake flag-o-matic python-single-r1 rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_BRANCH="amd-staging"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/amdsmi/"
	FALLBACK_COMMIT="rocm-6.1.2"
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
https://github.com/amd/esmi_ib_library/archive/refs/tags/esmi_pkg_ver-${ESMI_PV}.tar.gz
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/plain/arch/x86/include/uapi/asm/amd_hsmp.h?h=review-ilpo&id=${AMD_HSMP_H_COMMIT}
	-> pdx86-platform-drivers-x86-amd_hsmp.h.${AMD_HSMP_H_COMMIT:0:7}
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
IUSE+=" doc +esmi test ebuild_revision_1"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	esmi
"
RDEPEND="
	${PYTHON_DEPS}
	|| (
		virtual/kfd-ub:6.2
		virtual/kfd:6.1
		virtual/kfd:6.0
		virtual/kfd-lb:5.7
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.14
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.8.11
		app-text/texlive-core
		dev-texlive/texlive-latexextra
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.0.2-hardcoded-paths.patch"
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
		ESMI_S_SRC="${WORKDIR}/esmi_ib_library-esmi_pkg_ver-${ESMI_PV}"
		ESMI_S_DEST="${S}/esmi_ib_library"
		mv "${ESMI_S_SRC}" "${ESMI_S_DEST}" || die
		mkdir -p "${ESMI_S_DEST}/include/asm" || die
		cat \
			"${DISTDIR}/pdx86-platform-drivers-x86-amd_hsmp.h.${AMD_HSMP_H_COMMIT:0:7}" \
			> \
			"${ESMI_S_DEST}/include/asm/amd_hsmp.h"
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

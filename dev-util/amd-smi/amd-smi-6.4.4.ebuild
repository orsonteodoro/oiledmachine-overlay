# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Viewer URI:  https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/tree/arch/x86/include/uapi/asm/amd_hsmp.h?h=review-ilpo&id=54aa699e8094efb7d7675fefbc03dfce24f98456
#AMD_HSMP_H_DATE="2024-01-03 11:46:22 +0100"
#AMD_HSMP_H_COMMIT="54aa699e8094efb7d7675fefbc03dfce24f98456"
ESMI_PV="4.1.2"
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
MY_PN="amdsmi"

inherit check-compiler-switch cmake flag-o-matic python-single-r1 rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_BRANCH="amd-staging"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/amdsmi/"
	FALLBACK_COMMIT="rocm-${PV}"
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
SLOT="0/${ROCM_SLOT}"
IUSE+="
asan doc +esmi test
ebuild_revision_5
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	esmi
"
RDEPEND="
	${PYTHON_DEPS}
	|| (
		>=virtual/kfd-6.4:0/6.4
		>=virtual/kfd-6.3:0/6.3
		>=virtual/kfd-6.2:0/6.2
	)
	virtual/kfd:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.20
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
)

pkg_setup() {
	check-compiler-switch_start
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
		#cat \
		#	"${DISTDIR}/pdx86-platform-drivers-x86-amd_hsmp.h.${AMD_HSMP_H_COMMIT:0:7}" \
		#	> \
		#	"${ESMI_S_DEST}/include/asm/amd_hsmp.h"
	fi
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DADDRESS_SANITIZER=$(usex asan)
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

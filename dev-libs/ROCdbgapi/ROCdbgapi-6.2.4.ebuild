# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/ROCdbgapi-rocm-${PV}"
SRC_URI="
	https://github.com/ROCm-Developer-Tools/ROCdbgapi/archive/rocm-${PV}.tar.gz
		-> ${P}.tar.gz
"

DESCRIPTION="AMD Debugger API"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/ROCdbgapi"
LICENSE="
	MIT
	|| (
		(
			GPL-2.0
			Linux-syscall-note
		)
		MIT
	)
"
# || ( ( GPL-2.0 Linux-syscall-note ) MIT ) - src/linux/kfd_sysfs.h
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" ebuild_revision_8"
RDEPEND="
	!dev-libs/ROCdbgapi:0
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	|| (
		virtual/kfd-ub:6.2
		virtual/kfd:6.1
		virtual/kfd-lb:6.0
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.8
"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	local mycmakeargs=(
	)
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test

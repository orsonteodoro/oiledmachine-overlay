# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic rocm

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
SLOT="0/${ROCM_SLOT}"
IUSE=" ebuild_revision_10"
RDEPEND="
	>=dev-libs/rocm-comgr-${PV}:${SLOT}
	dev-libs/rocm-comgr:=
	>=dev-libs/rocr-runtime-${PV}:${SLOT}
	dev-libs/rocr-runtime:=
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
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.8
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
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
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test

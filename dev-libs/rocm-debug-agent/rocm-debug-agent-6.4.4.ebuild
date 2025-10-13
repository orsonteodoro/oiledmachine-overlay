# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CONFIG_CHECK="~HSA_AMD"
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic linux-info rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rocr_debug_agent-rocm-${PV}"
SRC_URI="
https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
LICENSE="NCSA-AMD"
RESTRICT="
	test
"
SLOT="0/${ROCM_SLOT}"
IUSE="test ebuild_revision_8"
RDEPEND="
	dev-libs/elfutils
	dev-debug/systemtap
	virtual/libelf
	>=dev-libs/ROCdbgapi-${PV}:${SLOT}
	dev-libs/ROCdbgapi:=
	>=dev-libs/rocr-runtime-${PV}:${SLOT}
	dev-libs/rocr-runtime:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.8.0
	test? (
		>=dev-util/hip-${PV}:${SLOT}
		dev-util/hip:=
	)
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	linux-info_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:enable_testing:#enable_testing:" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die
	sed \
		-e "s:add_subdirectory(test):#add_subdirectory(test):" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die

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

	append-flags -fno-stack-protector
	replace-flags -O0 -O1
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test

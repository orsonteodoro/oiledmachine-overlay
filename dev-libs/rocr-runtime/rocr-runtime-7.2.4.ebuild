# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_ROCM_7_2[@]}"
)

CXX_STANDARD=17
LLVM_SLOT=22 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-7.2.4/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

CHKL_TIMESTAMPS=(
	"dev-libs/elfutils-9999"
)

inherit check-compiler-switch chkl cmake flag-o-matic libstdcxx-slot secure-version rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/"
	S="${WORKDIR}/${P}/src"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCR-Runtime-rocm-${PV}"
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCR-Runtime/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Radeon Open Compute Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCR-Runtime"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	NCSA-AMD
"
# The distro's MIT license template does not contain All Rights Reserved.
RESTRICT="strip" # Fix issue with finding symbols
SLOT="0/${ROCM_SLOT}"
IUSE="
debug
ebuild_revision_22
"
RDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-libs/elfutils-${ELFUTILS_PV}:=
	virtual/kfd:=
	|| (
		>=virtual/kfd-7.2:0/7.2
		>=virtual/kfd-7.1:0/7.1
		>=virtual/kfd-7.0:0/7.0
	)
"
DEPEND="
	${RDEPEND}
	~dev-libs/rocm-device-libs-${PV}:=
"
# vim-core is needed for "xxd"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=app-editors/vim-core-9.0.1378
	>=dev-build/cmake-3.7
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	chkl_check_many_timestamps

	rocm_set_default_clang

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

	use debug || append-cxxflags "-DNDEBUG"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DINCLUDE_PATH_COMPATIBILITY=OFF
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  needs install test

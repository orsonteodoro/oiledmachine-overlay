# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="RELEASE"
LLVM_SLOT=19
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipfort/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Fortran interfaces for ROCm libraries"
HOMEPAGE="
https://rocm.docs.amd.com/projects/hipfort/en/latest/
https://github.com/ROCmSoftwarePlatform/hipfort
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not have all rights reserved.
SLOT="0/${ROCM_SLOT}"
IUSE="debug ebuild_revision_13"
RDEPEND="
	|| (
		${ROCM_GCC_DEPEND}
		dev-lang/flang
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-2.8.12
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
"
RESTRICT="test"
DOCS=( "README.md" )
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):#ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):" \
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

	local gcc_slot=""
	if has_version "dev-util/hip:${SLOT}[gcc_slot_12_5]" ; then
		gcc_slot="12"
	elif has_version "dev-util/hip:${SLOT}[gcc_slot_13_4]" ; then
		gcc_slot="13"
	else
eerror "Set the gcc_slot in dev-util/hip"
		die
	fi

	export FC="${CHOST}-gfortran-${gcc_slot}"
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "DEBUG" "RELEASE")
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	rocm_src_configure
}

src_install() {
        cmake_src_install
	dodoc "LICENSE"
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs install test

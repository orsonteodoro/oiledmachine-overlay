# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=18
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/RadeonOpenCompute/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/RadeonOpenCompute/rocm_bandwidth_test/commit/a58f9fd4cb5d1120b9ce58c912ca87fa14720f73.patch
	-> ${PN}-pr90-a58f9fd.patch
"
# a58f9fd - fix include for rocm 5.5.0

DESCRIPTION="Bandwidth test for ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_bandwidth_test"
LICENSE="NCSA-AMD"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" ebuild_revision_9"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${DEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.6.3
"
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
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

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
#	rm -rfv "${ED}/usr/share/doc/rocm-bandwidth-test"
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  needs install test

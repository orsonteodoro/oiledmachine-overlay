# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-6.0.2/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/"
	S="${WORKDIR}/${P}/src"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCR-Runtime-rocm-${PV}/src"
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
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	debug
	ebuild-revision-12
"
RDEPEND="
	${ROCM_CLANG_DEPEND}
	!dev-libs/rocr-runtime:0
	dev-libs/elfutils
	dev-libs/roct-thunk-interface:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
"
# vim-core is needed for "xxd"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=app-editors/vim-core-9.0.1378
	>=dev-build/cmake-3.7
"
PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-link-hsakmt.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	pushd "${WORKDIR}/ROCR-Runtime-rocm-${PV}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-5.3.3-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_clang

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

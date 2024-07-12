# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=15 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.3.3/llvm/CMakeLists.txt
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
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	debug
	ebuild-revision-10
"
CDEPEND="
	dev-libs/elfutils
"
RDEPEND="
	!dev-libs/rocr-runtime:0
	${CDEPEND}
	dev-libs/roct-thunk-interface:${ROCM_SLOT}
"
DEPEND="
	${CDEPEND}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
"
# vim-core is needed for "xxd"
BDEPEND="
	>=app-editors/vim-core-9.0.1378
	>=dev-build/cmake-3.7
	sys-devel/llvm-roc:=
	virtual/pkgconfig
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-link-hsakmt.patch"
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
	use debug || append-cxxflags "-DNDEBUG"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DINCLUDE_PATH_COMPATIBILITY=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

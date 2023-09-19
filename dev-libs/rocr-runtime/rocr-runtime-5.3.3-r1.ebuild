# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.3.3/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic llvm rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/"
	inherit git-r3
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCR-Runtime/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/ROCR-Runtime-rocm-${PV}/src"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCR-Runtime"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	+aqlprofile debug system-llvm
	r1
"
CDEPEND="
	dev-libs/elfutils
"
RDEPEND="
	!dev-libs/rocr-runtime:0
	${CDEPEND}
	dev-util/rocm-compiler[system-llvm=]
"
DEPEND="
	${CDEPEND}
	~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
"
# vim-core is needed for "xxd"
BDEPEND="
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
	>=dev-util/cmake-3.7
	>=app-editors/vim-core-9.0.1378
	virtual/pkgconfig
	system-llvm? (
		=sys-devel/lld-${LLVM_MAX_SLOT}*
		sys-devel/clang:${LLVM_MAX_SLOT}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-path-changes.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if ! use aqlprofile ; then
		eapply "${FILESDIR}/${PN}-4.3.0_no-aqlprofiler.patch"
	fi
	rocm_src_prepare
}

src_configure() {
	use debug || append-cxxflags "-DNDEBUG"
	local mycmakeargs=(
		-DINCLUDE_PATH_COMPATIBILITY=OFF
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

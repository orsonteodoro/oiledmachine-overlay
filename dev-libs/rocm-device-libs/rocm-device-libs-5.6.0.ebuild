# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.6.0/llvm/CMakeLists.txt

inherit cmake llvm rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/"
	inherit git-r3
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/ROCm-Device-Libs-rocm-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="test r4"
RDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.13.4
	sys-devel/clang:${LLVM_MAX_SLOT}
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
# https://github.com/RadeonOpenCompute/ROCm-Device-Libs/issues/94
	"${FILESDIR}/${PN}-5.5.1-llvm-link.patch"

	"${FILESDIR}/${PN}-5.3.3-path-changes.patch"
)
CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

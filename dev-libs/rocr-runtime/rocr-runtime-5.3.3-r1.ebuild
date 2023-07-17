# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.3.3/llvm/CMakeLists.txt
inherit cmake flag-o-matic llvm

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
SLOT="0/$(ver_cut 1-2)"
IUSE="debug"
CDEPEND="
	dev-libs/elfutils
"
RDEPEND="
	${CDEPEND}
"
DEPEND="
	${CDEPEND}
	=sys-devel/lld-${LLVM_MAX_SLOT}*
	sys-devel/clang:${LLVM_MAX_SLOT}
	~dev-libs/roct-thunk-interface-${PV}
	~dev-libs/rocm-device-libs-${PV}
"
# vim-core is needed for "xxd"
BDEPEND="
	>=dev-util/cmake-3.7
	>=app-editors/vim-core-9.0.1378
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.0_no-aqlprofiler.patch"
)

src_prepare() {
	# ... otherwise system llvm/clang is used ...
	local llvm_prefix=$(get_llvm_prefix ${LLVM_MAX_SLOT})
	sed \
		-e "/find_package(Clang REQUIRED HINTS /s:\${CMAKE_INSTALL_PREFIX}/llvm \${CMAKE_PREFIX_PATH}/llvm PATHS /opt/rocm/llvm:${llvm_prefix}:" \
		-i image/blit_src/CMakeLists.txt \
		|| die

	# The distro installs "*.bc" to "/usr/lib" instead of a "[path]/bitcode"
	# directory.
	sed \
		-e "s:-O2:--rocm-path=${EPREFIX}/usr/lib/ -O2:" \
		-i image/blit_src/CMakeLists.txt \
		|| die

	cmake_src_prepare
}

src_configure() {
	use debug || append-cxxflags "-DNDEBUG"
	local mycmakeargs=(
		-DINCLUDE_PATH_COMPATIBILITY=OFF
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

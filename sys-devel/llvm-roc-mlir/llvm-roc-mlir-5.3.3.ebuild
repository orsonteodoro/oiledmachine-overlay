# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LLVM_MAX_SLOT=15
inherit cmake flag-o-matic llvm

SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
"

DESCRIPTION="MLIR contained in the ROCm™ fork of the LLVM project"
HOMEPAGE="
	https://github.com/RadeonOpenCompute/llvm-project
"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	BSD
	rc
	public-domain
	UoI-NCSA
"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
RDEPEND="
	dev-libs/libxml2
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/cblas
	~sys-devel/llvm-roc-${PV}:${PV}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"
PATCHES=(
)
S="${WORKDIR}/llvm-project-rocm-${PV}/mlir"
CMAKE_BUILD_TYPE="RelWithDebInfo"

src_configure() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	filter-flags "-fuse-ld=*"
	strip-unsupported-flags
	replace-flags '-O0' '-O1'
	# Disallow newer clangs versions when producing .o files.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:/opt/rocm-${PV}/llvm/bin|g")
	einfo "PATH=${PATH} (after)"

	replace-flags '-O0' '-O1'
	PROJECTS="mlir;lld"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/opt/rocm-${PV}/llvm"
		-DLLVM_BUILD_TOOLS=ON
		-DLLVM_BUILD_UTILS=ON
		-DLLVM_ENABLE_ASSERTIONS=ON
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_ENABLE_ZSTD=OFF
		-DLLVM_ENABLE_ZLIB=OFF
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DMLIR_LINK_MLIR_DYLIB=ON
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	sed -i \
		-e "s|\"mlir-tblgen\"|\"/opt/rocm-${PV}/llvm/bin/mlir-tblgen\"|g" \
		"${ED}/opt/rocm-${PV}/llvm/lib/cmake/mlir/MLIRConfig.cmake" \
		|| die
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

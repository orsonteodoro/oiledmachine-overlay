# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LLVM_MAX_SLOT=15
inherit cmake flag-o-matic

SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
"

DESCRIPTION="The ROCm™ fork of the LLVM project"
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
IUSE="+mlir +runtime"
RDEPEND="
	dev-libs/libxml2
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/cblas
"
DEPEND="
	${RDEPEND}
"
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
PATCHES=(
)
CMAKE_BUILD_TYPE="RelWithDebInfo"

src_prepare() {
	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/opt/rocm-${PV}/llvm"
		-DLLVM_BUILD_DOCS=NO
		-DLLVM_ENABLE_ASSERTIONS=ON # For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_ZSTD=OFF # For mlir
		-DLLVM_ENABLE_ZLIB=OFF # For mlir
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)
	replace-flags '-O0' '-O1'

	PROJECTS="clang;lld"

	if use runtime ; then
		PROJECTS+=";compiler-rt"
	fi

	if use mlir ; then
		PROJECTS+=";mlir"
		mycmakeargs+=(
			-DLLVM_BUILD_TOOLS=ON
			-DLLVM_BUILD_UTILS=ON
			-DLLVM_INSTALL_UTILS=ON
			-DLLVM_LINK_LLVM_DYLIB=ON
			-DMLIR_LINK_MLIR_DYLIB=ON
		)
	fi

	mycmakeargs+=(
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

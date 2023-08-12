# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LLVM_MAX_SLOT=14
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
SLOT="${PV}"
IUSE="+runtime"
RDEPEND="
	dev-libs/libxml2
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/cblas
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"
PATCHES=(
)
S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"
CMAKE_BUILD_TYPE="RelWithDebInfo"

src_configure() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	filter-flags "-fuse-ld=*"
	strip-unsupported-flags
	replace-flags '-O0' '-O1'
	PROJECTS="llvm;clang;lld"
	if use runtime ; then
		PROJECTS+=";compiler-rt"
	fi
	local mycmakeargs=(
#		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/opt/rocm-${PV}/llvm"
		-DLLVM_BUILD_DOCS=NO
#		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_ENABLE_ASSERTIONS=ON # For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_ZSTD=OFF # For mlir
		-DLLVM_ENABLE_ZLIB=OFF # For mlir
		-DLLVM_INSTALL_UTILS=ON
#		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile \
		all \
		LLVMDemangle \
		LLVMSupport \
		LLVMTableGen \
		LLVMOffloadArch
}

src_install() {
	DESTDIR="${D}" \
	cmake_src_install \
		install-LLVMDemangle \
		install-LLVMSupport \
		install-LLVMTableGen \
		install-LLVMOffloadArch
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

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

get_distribution_components() {
	local sep=${1-;}

	local out=(
		# shared libs
		LLVM
		LTO
		Remarks

		# tools
		llvm-config

		# common stuff
		cmake-exports
		llvm-headers

		# libraries needed for mlir
		LLVMDemangle
		LLVMSupport
		LLVMTableGen

		# utilities
		llvm-tblgen
		FileCheck
		llvm-PerfectShuffle
		count
		not
		yaml-bench
		UnicodeNameMappingGenerator

		# tools
		bugpoint
		dsymutil
		llc
		lli
		lli-child-target
		llvm-addr2line
		llvm-ar
		llvm-as
		llvm-bcanalyzer
		llvm-bitcode-strip
		llvm-c-test
		llvm-cat
		llvm-cfi-verify
		llvm-config
		llvm-cov
		llvm-cvtres
		llvm-cxxdump
		llvm-cxxfilt
		llvm-cxxmap
		llvm-debuginfod
		llvm-debuginfod-find
		llvm-diff
		llvm-dis
		llvm-dlltool
		llvm-dwarfdump
		llvm-dwarfutil
		llvm-dwp
		llvm-exegesis
		llvm-extract
		llvm-gsymutil
		llvm-ifs
		llvm-install-name-tool
		llvm-jitlink
		llvm-jitlink-executor
		llvm-lib
		llvm-libtool-darwin
		llvm-link
		llvm-lipo
		llvm-lto
		llvm-lto2
		llvm-mc
		llvm-mca
		llvm-ml
		llvm-modextract
		llvm-mt
		llvm-nm
		llvm-objcopy
		llvm-objdump
		llvm-opt-report
		llvm-otool
		llvm-pdbutil
		llvm-profdata
		llvm-profgen
		llvm-ranlib
		llvm-rc
		llvm-readelf
		llvm-readobj
		llvm-reduce
		llvm-remark-size-diff
		llvm-rtdyld
		llvm-sim
		llvm-size
		llvm-split
		llvm-stress
		llvm-strings
		llvm-strip
		llvm-symbolizer
		llvm-tapi-diff
		llvm-tli-checker
		llvm-undname
		llvm-windres
		llvm-xray
		obj2yaml
		opt
		sancov
		sanstats
		split-file
		verify-uselistorder
		yaml2obj

		# python modules
		opt-viewer
	)

	printf "%s${sep}" "${out[@]}"
}

src_configure() {
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	filter-flags "-fuse-ld=*"
	strip-unsupported-flags
	replace-flags '-O0' '-O1'
	PROJECTS="clang;lld"
	if use runtime ; then
		PROJECTS+=";compiler-rt"
	fi
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/opt/rocm-${PV}/llvm"
		-DLLVM_BUILD_DOCS=NO
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)
		-DLLVM_ENABLE_ASSERTIONS=ON # For mlir
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_PROJECTS="${PROJECTS}"
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_ZSTD=OFF # For mlir
		-DLLVM_ENABLE_ZLIB=OFF # For mlir
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

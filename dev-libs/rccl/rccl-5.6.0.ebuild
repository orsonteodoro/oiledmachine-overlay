# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_OVERRIDE=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
LLVM_MAX_SLOT=16
ROCM_VERSION="${PV}"

inherit cmake edo flag-o-matic llvm rocm

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz
	-> rccl-${PV}.tar.gz
"
LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RDEPEND="
	~dev-libs/rocr-runtime-${PV}:${SLOT}
	~dev-util/hip-${PV}:${SLOT}
	~dev-util/rocm-smi-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-util/hipify-${PV}:${SLOT}
	~dev-util/rocm-cmake-${PV}:${SLOT}
	test? (
		>=dev-cpp/gtest-1.11
	)
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/rccl-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.1-remove-chrpath.patch"
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	which hipify-perl || die

	export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
	einfo "HIP_CLANG_PATH=${HIP_CLANG_PATH}"

# Fix error:
#1.	<eof> parser at end of file
#2.	Code generation
#3.	Running pass 'Function Pass Manager' on module '/var/tmp/portage/dev-libs/rccl-5.6.0/work/rccl-rocm-5.6.0_build/src/graph/search.cpp'.
#4.	Running pass 'XXXXXXXXX DAG->DAG Instruction Selection' on function '@_Z15ncclTopoComputeP14ncclTopoSystemP13ncclTopoGraph'
# #0 0x00007f535e6ac7b5 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) (/usr/lib/llvm/16/bin/../lib64/libLLVM-16.so+0xaac7b5)
# #1 0x00007f535e6accd6 PrintStackTraceSignalHandler(void*) Signals.cpp:0:0
# #2 0x00007f535e6aa605 llvm::sys::RunSignalHandlers() (/usr/lib/llvm/16/bin/../lib64/libLLVM-16.so+0xaaa605)

# XXXXXXXXXXX is omitted
	replace-flags '-O0' '-O1'

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DSKIP_RPATH=On
		-Wno-dev
	)

	CXX=hipcc \
	cmake_src_configure
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}" edob test/UnitTests
}

# OILEDMACHINE-OVERLAY-STATUS:  build-failure
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

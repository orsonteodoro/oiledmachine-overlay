# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
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
CHECKREQS_MEMORY=25G # Tested with 34.3G total memory
LLVM_SLOT=17
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-reqs cmake edo flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/rccl-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz
	-> rccl-${PV}.tar.gz
"

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	BSD
	MIT
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild-revision-5"
RDEPEND="
	!dev-libs/rccl:0
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
	~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.5
	~dev-util/HIPIFY-${PV}:${ROCM_SLOT}
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	test? (
		>=dev-cpp/gtest-1.11
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.1-remove-chrpath.patch"
	"${FILESDIR}/${PN}-5.7.0-customize-targets.patch"
	"${FILESDIR}/${PN}-5.7.1-hardcoded-paths.patch"
)

pkg_pretend() {
	# It randomly crashes at 20G total memory
ewarn "Set CHECKREQS_DONOTHING=1 to bypass build requirements not met check at your own risk"
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup

	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare

	# Prevent swapping
	sed -i -r -e "s|-parallel-jobs=[0-9]+||g" "CMakeLists.txt" || die
}

src_configure() {
	addpredict "/dev/kfd"
	addpredict "/dev/dri/"

	which hipify-perl || die

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

	rocm_set_default_hipcc

	export HIP_PLATFORM="amd"
	local amdgpu_targets=$(get_amdgpu_flags)
	local mycmakeargs=(
		-DAMDGPU_TARGETS="${amdgpu_targets}"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DGPU_TARGETS="${amdgpu_targets}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DROCM_PATH="${ESYSROOT}${EROCM_PATH}"
		-DSKIP_RPATH=ON
		-Wno-dev
	)

ewarn "It may hang when generating git_version.cpp.  Restart emerge if it happens."
	rocm_src_configure
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}" edob "./test/UnitTests"
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

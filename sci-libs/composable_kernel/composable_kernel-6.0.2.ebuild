# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/composable_kernel/blob/rocm-6.0.2/include/ck/ck.hpp#L48
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
)
AMDGPU_UNTESTED_TARGETS=(
	gfx803
	gfx900
	gfx906
	gfx1100
	gfx1102
)
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=17
ROCM_SLOT="5.7"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic rocm

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/composable_kernel.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/composable_kernel/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${PN}-rocm-${PV}.tar.gz
	"
fi

DESCRIPTION="Composable Kernel: Performance Portable Programming Model for Machine Learning Tensor Operators"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/composable_kernel"
LICENSE="MIT"
#RESTRICT="test"
SLOT="${ROCM_SLOT}/$(ver_cut 1-2)"
IUSE+="
test ebuild-revision-6
"
REQUIRED_USE="
"
RDEPEND="
	~dev-libs/rocm-opencl-runtime-${ROCM_VERSION}:${ROCM_SLOT}
	~dev-util/hip-${ROCM_VERSION}:${ROCM_SLOT}
	~sys-libs/llvm-roc-libomp-${ROCM_VERSION}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/binutils[gold]
	~dev-build/rocm-cmake-${ROCM_VERSION}:${ROCM_SLOT}
	~sys-devel/llvm-roc-${ROCM_VERSION}:${ROCM_SLOT}
	test? (
		dev-cpp/gtest
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.0_p9999-fix-missing-libstdcxx-expf.patch"
	"${FILESDIR}/${PN}-1.0.0_p9999-hip_runtime-header.patch"
	"${FILESDIR}/${PN}-1.0.0_p9999-fix-missing-libstdcxx-sqrtf.patch"
	"${FILESDIR}/${PN}-5.7.0-example-libs.patch"
)
if [[ "${EGIT_BRANCH}" == "develop" ]] ; then
	PATCHES+=(
		"${FILESDIR}/${PN}-1.0.0_p9999-optional-tests.patch"
	)
else
	PATCHES+=(
		"${FILESDIR}/${PN}-5.7.0-optional-tests.patch"
	)
fi

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNTESTED_TARGETS} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not tested upstream."
		fi
	done
}

pkg_setup() {
	rocm_pkg_setup
	warn_untested_gpu
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if [[ "${EGIT_BRANCH}" == "develop" ]] ; then
			use fallback-commit && EGIT_COMMIT="7a29f711d48198177a960ce095d9405cdd883dba" # develop
		else
			use fallback-commit && EGIT_COMMIT="4aefd6e1207615a066d556c66373bec8f7383129" # master
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare

	[[ -e "${ESYSROOT}/${EROCM_PATH}/$(rocm_get_libdir)/cmake/hip/hip-config.cmake" ]] || die "emerge hip"

#	hipconfig --help >/dev/null || die
	rocm_src_prepare
}

src_configure() {
	local llvm_slot="${LLVM_SLOT}"

	export CC="clang"
	export CXX="clang++"
	has_version "sys-devel/llvm-roc:${ROCM_SLOT}" \
		|| die "sys-devel/llvm-roc-${ROCM_SLOT} must be installed."

	# Prevent
	# error: Illegal instruction detected: Operand has incorrect register class.
	replace-flags '-O0' '-O1'

	filter-flags -Wl,--as-needed

	# Fix libhsa-runtime64.so: undefined reference to `hsaKmtWaitOnEvent_Ext'
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=gold

	einfo "USE=${USE}"
	local gpu_targets=$(echo "${USE}" \
		| tr " " "\n" \
		| grep -e "^amdgpu_targets_" \
		| tr "\n" ";" \
		| sed -e "s|amdgpu_targets_||g" \
		| sed -e "s|;$||g")
	einfo "GPU_TARGETS=${gpu_targets}"
	local mycmakeargs=(
		-DBUILD_TEST=$(use test)
		-DCMAKE_BUILD_TYPE=release
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DDOWNLOAD_GTEST=OFF
		-DGPU_TARGETS="${gpu_targets}"
		-DHIP_COMPILER_PATH="${ESYSROOT}/${EROCM_LLVM_PATH}"
	)

#
# The -fno-stack-protector fixes the following:
#
# fatal error: error in backend: Cannot select: 0x55fcbb9ee4b0: i64 = FrameIndex<0>
# In function: _ZN2ck42kernel_sparse_embeddings_forward_layernormINS_40GridwiseSparseEmbeddingsForwardLayernormIDF16_lDF16_DF16_fDF16_NS_16TensorDescriptorINS_5TupleIJNS_7UnMergeINS3_IJiiEEELb0EEEEEENS3_IJNS_8SequenceIJLi0EEEEEEENS3_IJNS8_IJLi1ELi2EEEEEEESB_lEENS_16tensor_operation12element_wise6AddAddELi256ELi1ELi256ELi1ELi256ELi1ELi1ELi3EEEDF16_lDF16_DF16_fDF16_SD_SG_Li3EEEvPT5_NS_5ArrayIPT0_XT8_EEENSK_IPT1_XT8_EEEPKT2_PKT3_T6_T4_T7_
# clang-16: error: clang frontend command failed with exit code 70 (use -v to see invocation)
# clang version 16.0.6
#

	append-flags \
		--rocm-path="${ESYSROOT}${EROCM_PATH}" \
		-fno-stack-protector
#		-mcumode -mno-wavefrontsize64

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test

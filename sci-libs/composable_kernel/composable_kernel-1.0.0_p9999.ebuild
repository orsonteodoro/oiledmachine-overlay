# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_OVERRIDE=(
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

CMAKE_MAKEFILE_GENERATOR="emake"
ROCM_VERSION="9999"
LLVM_MAX_SLOT=16
inherit cmake flag-o-matic llvm rocm

if [[ ${PV} =~ 9999 ]] ; then
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/composable_kernel.git"
	inherit git-r3
	IUSE+=" fallback-commit"
else
	SRC_URI="
	"
fi

DESCRIPTION="Composable Kernel: Performance Portable Programming Model for Machine Learning Tensor Operators"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/composable_kernel"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE+=" test r2"
RDEPEND="
	>=sys-libs/libomp-${LLVM_MAX_SLOT}
	|| (
		(
			~dev-util/hip-5.5.1
			~dev-util/rocm-cmake-5.5.1
		)
		(
			~dev-util/hip-5.6.0
			~dev-util/rocm-cmake-5.6.0
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	test? (
		dev-cpp/gtest
	)
"
#RESTRICT="test"
S="${WORKDIR}/${P}"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.0_p9999-fix-missing-libstdcxx-expf.patch"
	"${FILESDIR}/${PN}-1.0.0_p9999-hip_runtime-header.patch"
	"${FILESDIR}/${PN}-1.0.0_p9999-fix-missing-libstdcxx-sqrtf.patch"
)
if [[ "${EGIT_BRANCH}" == "develop" ]] ; then
	PATCHES+=(
		"${FILESDIR}/${PN}-1.0.0_p9999-optional-tests.patch"
	)
else
	PATCHES+=(
		"${FILESDIR}/${PN}-1.0.0_p9999-master-optional-tests.patch"
	)
fi

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
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

	# Disallow newer clang versions when producing .o files.
	local llvm_slot=$(grep -e "HIP_CLANG_ROOT.*/usr/lib/llvm" \
			"/usr/$(get_libdir)/cmake/hip/hip-config.cmake" \
		| grep -E -o -e  "[0-9]+")

	export HIP_CLANG_PATH=$(get_llvm_prefix ${llvm_slot})"/bin"
	einfo "HIP_CLANG_PATH=${HIP_CLANG_PATH}"

	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${llvm_slot}/bin|g")
	einfo "PATH=${PATH} (after)"

#	hipconfig --help >/dev/null || die
}

src_configure() {
	# Avoid ocml.bc': Unknown attribute kind (86) (Producer: 'LLVM16.0.6' Reader: 'LLVM 15.0.7') errors
	local llvm_slot=$(grep -e "HIP_CLANG_ROOT.*/usr/lib/llvm" \
			"/usr/$(get_libdir)/cmake/hip/hip-config.cmake" \
		| grep -E -o -e  "[0-9]+")

	export CC="${CHOST}-clang-${llvm_slot}"
	export CXX="${CHOST}-clang++-${llvm_slot}"

	has_version "sys-devel/llvm:${llvm_slot}" || die "llvm-${llvm_slot} must be installed"
	has_version "sys-devel/clang:${llvm_slot}" || die "clang-${llvm_slot} must be installed"

	# Prevent
	# error: Illegal instruction detected: Operand has incorrect register class.
	replace-flags '-O0' '-O1'

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
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DDOWNLOAD_GTEST=OFF
		-DGPU_TARGETS="${gpu_targets}"
		-DHIP_COMPILER_PATH="${ESYSROOT}/usr/lib/llvm/${llvm_slot}"
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
		--rocm-path="${ESYSROOT}/usr/lib" \
		-fno-stack-protector
#		-mcumode -mno-wavefrontsize64

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

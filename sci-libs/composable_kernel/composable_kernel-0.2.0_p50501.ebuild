# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
# Same as MIOpen's requirements.txt
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_MAX_SLOT=16
ROCM_SLOT="5.5"
ROCM_VERSION="5.5.1"
COMPOSABLE_KERNEL_COMMIT="eef009d001b928db1bb377a105c93b75e0dccc7b" # Same as MIOpen's requirements.txt
MY_PV=$(ver_cut 1-2)

inherit cmake flag-o-matic llvm rocm

if [[ ${PV} =~ 9999 ]] ; then
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/composable_kernel.git"
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/composable_kernel/archive/${COMPOSABLE_KERNEL_COMMIT}.tar.gz
	-> ${PN}-${MY_PV}-${COMPOSABLE_KERNEL_COMMIT:0:7}.tar.gz
	"
	S="${WORKDIR}/${PN}-${COMPOSABLE_KERNEL_COMMIT}"
fi

DESCRIPTION="Composable Kernel: Performance Portable Programming Model for Machine Learning Tensor Operators"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/composable_kernel"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/$(ver_cut 1-2)"
IUSE+="
system-llvm test r2
"
REQUIRED_USE="
"
RDEPEND="
	|| (
		(
			!system-llvm? (
				~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}
			)
			~dev-util/hip-${PV}:${ROCM_SLOT}
			system-llvm? (
				sys-libs/libomp:${LLVM_MAX_SLOT}
			)
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-cpp/gtest
	)
	dev-util/rocm-compiler[system-llvm=]
	|| (
		(
			!system-llvm? (
				~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
			)
			~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
			system-llvm? (
				sys-devel/clang:${LLVM_MAX_SLOT}
			)
		)
	)
"
#RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-0.2.0_p50601-fix-missing-libstdcxx-expf.patch"
	"${FILESDIR}/${PN}-1.0.0_p9999-hip_runtime-header.patch"
	"${FILESDIR}/${PN}-0.2.0_p50501-path-changes.patch"
)
if [[ "${EGIT_BRANCH}" == "develop" ]] ; then
	PATCHES+=(
		"${FILESDIR}/${PN}-1.0.0_p9999-optional-tests.patch"
	)
else
	PATCHES+=(
		"${FILESDIR}/${PN}-0.2.0_p50501-optional-tests.patch"
	)
fi

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	rocm_pkg_setup
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

	[[ -e "${ESYSROOT}/${EROCM_PATH}/$(get_libdir)/cmake/hip/hip-config.cmake" ]] || die "emerge hip"

#	hipconfig --help >/dev/null || die
	rocm_src_prepare
}

src_configure() {
	# Avoid ocml.bc': Unknown attribute kind (86) (Producer: 'LLVM16.0.6' Reader: 'LLVM 15.0.7') errors
	local llvm_slot=$(grep -e "HIP_CLANG_ROOT.*/lib/llvm" \
			"${ESYSROOT}${EROCM_PATH}/$(get_libdir)/cmake/hip/hip-config.cmake" \
		| grep -E -o -e  "[0-9]+")

	if use system-llvm ; then
		export CC="${CHOST}-clang-${llvm_slot}"
		export CXX="${CHOST}-clang++-${llvm_slot}"
		has_version "sys-devel/llvm:${llvm_slot}" \
			|| die "sys-devel/llvm-${llvm_slot} must be installed."
		has_version "sys-devel/clang:${llvm_slot}" \
			|| die "sys-devel/clang-${llvm_slot} must be installed."
	else
		export CC="clang"
		export CXX="clang++"
		has_version "sys-devel/llvm-roc:${ROCM_SLOT}" \
			|| die "sys-devel/llvm-roc-${ROCM_SLOT} must be installed."
	fi

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
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/${EROCM_PATH}"
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

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems

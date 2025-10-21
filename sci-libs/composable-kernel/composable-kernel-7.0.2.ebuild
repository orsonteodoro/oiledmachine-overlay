# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/composable_kernel/blob/rocm-7.0.2/include/ck/ck.hpp#L48
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
	gfx1152
	gfx1200
	gfx1201
)
AMDGPU_UNTESTED_TARGETS=(
	gfx803
	gfx900
	gfx906
	gfx1100
	gfx1102
)
inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_ROCM_7_0[@]}
)

CMAKE_MAKEFILE_GENERATOR="emake"
CXX_STANDARD=17
LLVM_SLOT=19
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"

inherit check-compiler-switch cmake dhms flag-o-matic libstdcxx-slot rocm

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/composable_kernel.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/composable_kernel/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${MY_PN}-rocm-${PV}.tar.gz
	"
fi

DESCRIPTION="Composable Kernel: Performance Portable Programming Model for Machine Learning Tensor Operators"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/composable_kernel"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain All rights reserved.
RESTRICT="test"
SLOT="0/${ROCM_SLOT}"
IUSE+="
test ebuild_revision_13
"
REQUIRED_USE="
"
RDEPEND="
	>=dev-libs/rocm-opencl-runtime-${ROCM_VERSION}:${SLOT}[${LIBSTDCXX_USEDEP}]
	dev-libs/rocm-opencl-runtime:=
	>=dev-util/hip-${ROCM_VERSION}:${SLOT}[${LIBSTDCXX_USEDEP}]
	dev-util/hip:=
	>=sys-libs/llvm-roc-libomp-${ROCM_VERSION}:${SLOT}[${LIBSTDCXX_USEDEP},${LLVM_ROC_LIBOMP_7_0_AMDGPU_USEDEP}]
	sys-libs/llvm-roc-libomp:=
"
DEPEND="
	${RDEPEND}
"
#	sys-devel/binutils[gold]
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/rocm-cmake-${ROCM_VERSION}:${SLOT}
	dev-build/rocm-cmake:=
	test? (
		dev-cpp/gtest[${LIBSTDCXX_USEDEP}]
		dev-cpp/gtest:=
	)
"
PATCHES=(
	"${FILESDIR}/${MY_PN}-6.1.2-fix-missing-libstdcxx-expf.patch"
	"${FILESDIR}/${MY_PN}-1.0.0_p9999-hip_runtime-header.patch"
	"${FILESDIR}/${MY_PN}-1.0.0_p9999-fix-missing-libstdcxx-sqrtf.patch"
	"${FILESDIR}/${MY_PN}-6.0.2-example-libs.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNTESTED_TARGETS[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not tested upstream."
		fi
	done
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	rocm_pkg_setup
	warn_untested_gpu
	libstdcxx-slot_verify
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

	rocm_set_default_clang

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	# Prevent
	# error: Illegal instruction detected: Operand has incorrect register class.
	replace-flags '-O0' '-O1'

	filter-flags -Wl,--as-needed

	# Fix libhsa-runtime64.so: undefined reference to `hsaKmtWaitOnEvent_Ext'
#	filter-flags '-fuse-ld=*'
#	append-ldflags -fuse-ld=gold

	einfo "USE=${USE}"
	local gpu_targets=$(echo "${USE}" \
		| tr " " "\n" \
		| grep -e "^amdgpu_targets_" \
		| tr "\n" ";" \
		| sed -e "s|amdgpu_targets_||g" \
		| sed -e "s|;$||g")
	einfo "GPU_TARGETS=${gpu_targets}"
	local mycmakeargs=(
		-DBUILD_TESTING=$(use test)
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
	dhms_end
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx940
	gfx941
	gfx942
)
LLVM_MAX_SLOT=17
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipTensor/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${PN}-${PV}.tar.gz
"

DESCRIPTION="AMD’s C++ library for accelerating tensor primitives"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipTensor"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
+rocm samples system-llvm test r1
"
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_required_use)
	${ROCM_REQUIRED_USE}
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	^^ (
		rocm
	)
"
RESTRICT="
	test
"
RDEPEND="
	dev-util/hip-compiler:${ROCM_SLOT}[system-llvm=]
	~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
	~sci-libs/composable_kernel-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.14
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
"
S="${WORKDIR}/${PN}-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	# For reduced memory usage during build.
	replace-flags '-O0' '-O2'
	replace-flags '-O0' '-O2'

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DHIPTENSOR_BUILD_TESTS=$(usex test ON OFF)
		-DHIPTENSOR_BUILD_SAMPLES=$(usex samples ON OFF)
	)

	if use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	rocm_src_configure
}

src_test() {
	check_amdgpu
	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test

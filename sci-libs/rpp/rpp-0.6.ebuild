# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  review the install prefix

inherit hip-versions

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
)
AMDGPU_UNTESTED_TARGETS=(
	gfx803
	gfx900
	gfx906
)
# See https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/blob/1.2.0/docs/release.md?plain=1#L18
LLVM_COMPAT=( 12 )
LLVM_SLOT=${LLVM_COMPAT[0]}
ROCM_SLOT="4.1"
ROCM_VERSION="${HIP_4_1_VERSION}"

inherit cmake flag-o-matic rocm toolchain-funcs

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
	SRC_URI="
https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="AMD ROCm Performance Primitives (RPP) library is a comprehensive \
high-performance computer vision library for AMD processors with HIP/OpenCL/CPU \
back-ends."
HOMEPAGE="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp"
LICENSE="MIT"
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
IUSE+="
${LLVM_COMPAT/#/llvm_slot_}
${ROCM_IUSE}
cpu opencl rocm test
ebuild_revision_12
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
	^^ (
		rocm
		opencl
		cpu
	)
"

RDEPEND="
	${HIPCC_DEPEND}
	${ROCM_CLANG_DEPEND}
	!sci-libs/rpp:0
	>=dev-libs/boost-1.72:=
	dev-libs/rocm-opencl-runtime:${ROCM_SLOT}
	~sys-libs/llvm-roc-libomp-${ROCM_VERSION}:${ROCM_SLOT}[${LLVM_ROC_LIBOMP_4_1_AMDGPU_USEDEP}]
	sys-libs/llvm-roc-libomp:=
	opencl? (
		virtual/opencl
	)
	rocm? (
		dev-libs/rocm-device-libs:${ROCM_SLOT}
		~dev-util/hip-${ROCM_VERSION}:${ROCM_SLOT}[rocm]
		dev-util/hip:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/half-1.12.0:=
"
BDEPEND="
	${HIPCC_DEPEND}
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.5
	test? (
		>=media-libs/libjpeg-turbo-2.0.6.1
		>=media-libs/opencv-3.4.0[jpeg]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.6-hardcoded-paths.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNTESTED_TARGETS[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

pkg_setup() {
	rocm_pkg_setup
	warn_untested_gpu
}

src_prepare() {
	cmake_src_prepare

	# Unbreak rocm builds:
	sed \
		-i \
		-e "s|-O3||g" \
		"CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "s|-Ofast||g" \
		"CMakeLists.txt" \
		|| die
#	sed \
#		-i \
#		-e "s|-DNDEBUG||g" \
#		"CMakeLists.txt" \
#		|| die
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang"
		-DCMAKE_CXX_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DROCM_PATH="${ESYSROOT}${EROCM_PATH}"
	)

	rocm_set_default_hipcc

ewarn
ewarn "If the build fails, use either -O0 or the systemwide optimization level."
ewarn

	if use opencl ; then
		mycmakeargs+=(
			-DBACKEND="OCL"
			-DOPENCL_ROOT="${EROCM_PATH}/opencl"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS=$(get_amdgpu_flags)
			-DBACKEND="HIP"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
		append-flags \
			--rocm-path="${ESYSROOT}${EROCM_PATH}" \
			--rocm-device-lib-path="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/amdgcn/bitcode"

		# Fix:
		# lld: error: undefined symbol: __stack_chk_guard
		append-flags \
			-fno-stack-protector
	elif use cpu ; then
		mycmakeargs+=(
			-DBACKEND="CPU"
		)
	fi

einfo "Using libomp"
	mycmakeargs+=(
		-DOpenMP_CXX_FLAGS="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp -Wno-unused-command-line-argument"
		-DOpenMP_CXX_LIB_NAMES="libomp"
		-DOpenMP_libomp_LIBRARY="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so"
	)

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

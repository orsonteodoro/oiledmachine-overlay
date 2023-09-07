# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx1030
)
LLVM_MAX_SLOT=16

inherit cmake flag-o-matic llvm rocm toolchain-funcs

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/"
	inherit git-r3
else
	SRC_URI="
https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="AMD ROCm Performance Primitives (RPP) library is a comprehensive \
high-performance computer vision library for AMD processors with HIP/OpenCL/CPU \
back-ends."
HOMEPAGE="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="
${ROCM_IUSE}
cpu opencl rocm test
r1
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

LLVM_SLOTS=( 16 15 14 )
gen_rdepend_llvm() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
				sys-libs/libomp:${s}
			)
		"
	done
}
RDEPEND="
	|| (
		$(gen_rdepend_llvm)
	)
	sys-devel/clang:=
	sys-devel/llvm:=
	>=dev-libs/boost-1.72:=
	opencl? (
		virtual/opencl
	)
	rocm? (
		>=dev-util/hip-5.4.3:=
		dev-libs/rocm-device-libs
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/half-1.12.0:=
"
BDEPEND="
	>=dev-util/cmake-3.5
	test? (
		>=media-libs/opencv-3.4.0[jpeg]
		>=media-libs/libjpeg-turbo-2.0.6.1
	)
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/rpp-1.2.0-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	IFS=$'\n'
	sed \
		-i \
		-e "s|half/half.hpp|half.hpp|g" \
		$(grep -l -r -e "half/half.hpp" "${S}") \
		|| die
	IFS=$' \t\n'

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
		-DCMAKE_C_COMPILER="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/bin/clang"
		-DCMAKE_CXX_COMPILER="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/bin/clang++"
		-DROCM_PATH="${ESYSROOT}/usr"
	)

#	export CC="${HIP_CC:-${CHOST}-clang-${LLVM_MAX_SLOT}}"
#	export CXX="${HIP_CXX:-${CHOST}-clang++-${LLVM_MAX_SLOT}}"
	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"

ewarn
ewarn "If the build fails, use either -O0 or the systemwide optimization level."
ewarn

	if use opencl ; then
		mycmakeargs+=(
			-DBACKEND="OCL"
		)
	elif use rocm ; then
		export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS=$(get_amdgpu_flags)
			-DBACKEND="HIP"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
		append-flags \
			--rocm-path="${ESYSROOT}/usr" \
			--rocm-device-lib-path="${ESYSROOT}/usr/$(get_libdir)/amdgcn/bitcode"

		# Fix:
		# lld: error: undefined symbol: __stack_chk_guard
		append-flags \
			-fno-stack-protector
	elif use cpu ; then
		mycmakeargs+=(
			-DBACKEND="CPU"
		)
	fi

	if [[ "${CC}" =~ (^|-)"g++" ]] ; then
einfo "Using libgomp"
		local gcc_slot=$(gcc-major-version)
		local gomp_abspath
		if [[ "${ABI}" =~ (amd64) && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so" ]] ; then
			gomp_abspath="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so"
		elif [[ "${ABI}" =~ (x86) && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/32/libgomp.so" ]] ; then
			gomp_abspath="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/32/libgomp.so"
		elif [[ -e "${GOMP_LIB_ABSPATH}" ]] ; then
			gomp_abspath="${GOMP_LIB_ABSPATH}"
		else
eerror
eerror "${ABI} is unknown.  Please set one of the following per-package"
eerror "environment variables:"
eerror
eerror "  GOMP_LIB_ABSPATH"
eerror
eerror "to point to the the absolute path to libgomp.so for GCC slot ${gcc_slot}"
eerror "corresponding to that ABI."
eerror
			die
		fi
		mycmakeargs+=(
			-DCMAKE_THREAD_LIBS_INIT="-lpthread"
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include -fopenmp"
			-DOpenMP_CXX_LIB_NAMES="libgomp"
			-DOpenMP_libgomp_LIBRARY="${gomp_abspath}"
		)
	else
einfo "Using libomp"
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/include -fopenmp=libomp -Wno-unused-command-line-argument"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/$(get_libdir)/libomp.so.${LLVM_MAX_SLOT}"
		)
	fi

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

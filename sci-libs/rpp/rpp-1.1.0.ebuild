# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  review the install prefix

inherit hip-versions

AMDGPU_TARGETS_COMPAT=(
# Based on commit 189c648
	gfx803
	gfx900
	gfx906
# See https://github.com/ROCm/rpp/blob/1.1.0/.jenkins/precheckin.groovy
	gfx908
)
AMDGPU_UNTESTED_TARGETS=(
	gfx803
	gfx900
)
# See https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/blob/1.2.0/docs/release.md?plain=1#L18
LLVM_COMPAT=( 16 )
LLVM_SLOT=${LLVM_COMPAT[0]}
ROCM_SLOT="5.6"
ROCM_VERSION="${HIP_5_6_VERSION}"

inherit cmake flag-o-matic rocm toolchain-funcs

if [[ ${PV} == *9999 ]] ; then
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
ebuild-revision-8
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
	${ROCM_CLANG_DEPEND}
	!sci-libs/rpp:0
	>=dev-libs/boost-1.72:=
	dev-libs/rocm-opencl-runtime:${ROCM_SLOT}
	~sys-libs/llvm-roc-libomp-${ROCM_VERSION}:${ROCM_SLOT}
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
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.5
	test? (
		>=media-libs/libjpeg-turbo-2.0.6.1
		>=media-libs/opencv-3.4.0[jpeg]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-hardcoded-paths.patch"
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
		-DCMAKE_C_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang"
		-DCMAKE_CXX_COMPILER="${ESYSROOT}${EROCM_LLVM_PATH}/bin/clang++"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DROCM_PATH="${ESYSROOT}${EROCM_PATH}"
	)

	rocm_set_default_clang

ewarn
ewarn "If the build fails, use either -O0 or the systemwide optimization level."
ewarn

	if use opencl ; then
		mycmakeargs+=(
			-DBACKEND="OCL"
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
			-DOpenMP_CXX_FLAGS="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp -Wno-unused-command-line-argument"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so"
		)
	fi

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO

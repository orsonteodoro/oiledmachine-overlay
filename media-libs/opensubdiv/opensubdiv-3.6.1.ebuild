# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# Some parts synced with opensubdiv-3.4.4-r2.

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)
CMAKE_MAKEFILE_GENERATOR="emake"
CUDA_TARGETS_COMPAT=(
	"sm_35"
	"sm_50"
)
MY_PV=$(ver_rs "1-3" '_')
ONETBB_SLOT="0"
PYTHON_COMPAT=( "python3_"{8..11} ) # U22 (3.10)

inherit check-compiler-switch cmake cuda flag-o-matic libstdcxx-slot python-any-r1 toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/OpenSubdiv-${MY_PV}"
SRC_URI="
https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A subdivision surface library"
HOMEPAGE="https://graphics.pixar.com/opensubdiv/docs/intro.html"
# Modfied Apache-2.0 license, where section 6 has been replaced.
# See for example CMakeLists.txt for details.
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
# cuda is default on upstream
# test is default on upstream
IUSE="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
cuda +doc +examples -glew +glfw +opencl +openmp +opengl +ptex +tbb test
+tutorials +X
ebuild_revision_5
"
gen_required_use_cuda_targets() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo  "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
REQUIRED_USE="
	$(gen_required_use_cuda_targets)
	cuda? (
		^^ (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	X? (
		glfw
	)
"
RDEPEND="
	${PYTHON_DEPS}
	cuda_targets_sm_35? (
		=dev-util/nvidia-cuda-toolkit-11*
		dev-util/nvidia-cuda-toolkit:=
	)
	cuda_targets_sm_50? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*
			=dev-util/nvidia-cuda-toolkit-12*
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	glew? (
		media-libs/glew:=
	)
	glfw? (
		>=media-libs/glfw-3.3.3
		media-libs/glfw:=
	)
	opencl? (
		virtual/opencl
	)
	ptex? (
		>=media-libs/ptex-2.4.2[${LIBSTDCXX_USEDEP}]
		media-libs/ptex:=
		>=sys-libs/zlib-1.2.13
	)
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXinerama
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXxf86vm
	)
"
DEPEND="
	${RDEPEND}
	tbb? (
		>=dev-cpp/tbb-2021.12.0:${ONETBB_SLOT}[${LIBSTDCXX_USEDEP}]
		dev-cpp/tbb:=
	)
"
BDEPEND="
	>=dev-build/cmake-3.14
	doc? (
		$(python_gen_any_dep '
			>=dev-python/docutils-0.21.2[${PYTHON_USEDEP}]
			>=dev-python/pygments-2.19[${PYTHON_USEDEP}]
		')
		>=app-text/doxygen-1.14.0
	)
	cuda? (
		=sys-devel/gcc-11*[cxx]
	)
"
PATCHES_=(
	"${FILESDIR}/${PN}-3.6.0-use-gnuinstalldirs.patch"
	"${FILESDIR}/${PN}-3.6.0-cudaflags.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	eapply ${PATCHES_[@]}
	cmake_src_prepare
	use cuda && cuda_src_prepare
}

src_configure() {
	# The tc-check-openmp does not print slot information.
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	if use cuda ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-gcc-11"
		export CPP="${CXX} -E"
		strip-unsupported-flags
	fi

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
	${CC} --version
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp

	# GLTESTS are disabled as portage is unable to open a display during test phase
	local mycmakeargs=(
		-DGLEW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DGLFW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DNO_CLEW=ON
		-DNO_GLEW=$(usex !glew)
		-DNO_GLFW=$(usex !glfw)
		-DNO_GLFW_X11=$(usex X)
		-DNO_CUDA=$(usex !cuda)
		-DNO_DOC=$(usex !doc)
		-DNO_EXAMPLES=$(usex !examples)
		-DNO_GLTESTS=ON
		-DNO_OMP=$(usex !openmp)
		-DNO_OPENCL=$(usex !opencl)
		-DNO_PTEX=$(usex !ptex)
		-DNO_REGRESSION=$(usex !test)
		-DNO_TBB=$(usex !tbb)
		-DNO_TESTS=$(usex !test)
		-DNO_TUTORIALS=$(usex !tutorials)
	)

	local cc_bin
	if use cuda ; then
		cc_bin="-ccbin "$(realpath "${ESYSROOT}/usr/bin/${CHOST}-gcc-11")
	fi

	if ! use cuda ; then
		:
	elif [[ -n "${OSD_CUDA_NVCC_FLAGS}" ]] ; then
		# See
		# https://github.com/PixarAnimationStudios/OpenSubdiv/issues/1299#issuecomment-1490813096
		# https://github.com/PixarAnimationStudios/OpenSubdiv/issues/965#issuecomment-380939742
		mycmakeargs+=(
			-DOSD_CUDA_NVCC_FLAGS="${cc_bin} ${OSD_CUDA_NVCC_FLAGS}"
		)
	elif has_version "=dev-util/nvidia-cuda-toolkit-12*" ; then
		mycmakeargs+=(
			-DOSD_CUDA_NVCC_FLAGS="${cc_bin} --gpu-architecture compute_50"
		)
	elif has_version "=dev-util/nvidia-cuda-toolkit-11*" ; then
		mycmakeargs+=(
			-DOSD_CUDA_NVCC_FLAGS="${cc_bin}"
		)
	fi

	export LIBDIR=$(get_libdir)

	# fails with building cuda kernels when using multiple jobs
	export MAKEOPTS="-j1"
	cmake_src_configure
}

src_test() {
	# Version tested: 3.4.3
	# Results dated Wed Jun 30 07:27:52 PM PDT 2021 (1625106472)

#ctest -j 1 --test-load 999
#Test project /var/tmp/portage/media-libs/opensubdiv-3.4.3/work/opensubdiv-3.4.3_build
#    Start 1: far_regression
#1/2 Test #1: far_regression ...................   Passed    4.31 sec
#    Start 2: far_perf
#2/2 Test #2: far_perf .........................   Passed    4.40 sec
#
#100% tests passed, 0 tests failed out of 2
#
#Total Test time (real) =   8.73 sec
# * Tests succeeded.

	cmake_src_test
}

src_install() {
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb

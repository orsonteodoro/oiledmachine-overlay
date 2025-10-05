# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# expandvars
# openfx
# prettymethods - delete references?

# minizip-ng 3.0.10 causes
#error: user-defined literal in preprocessor expression
#  229 | #if MZ_VERSION_BUILD >= 040000
#      |     ^~~~~~~~~~~~~~~~

# For requirements, see
# https://github.com/AcademySoftwareFoundation/OpenColorIO/blob/v2.4.2/docs/quick_start/installation.rst#building-from-source
# https://github.com/AcademySoftwareFoundation/openexr/blob/v3.4.0/MODULE.bazel

# Works with older OIIO but need to force a version w/ OpenEXR 3

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 12.2; <=CUDA-12.9, <=CUDA-12.8
	"gcc_slot_13_4" # <=CUDA-12.6, <=CUDA-12.5, <=CUDA-12.4, <=CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, <=CUDA-11.8
)
CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512vl"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_sse"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_sse3"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_sse4"
	"cpu_flags_x86_sse4_2"
)
CMAKE_BUILD_TYPE="RelWithDebInfo"
OPENEXR_V3_PV=(
	# openexr:imath
	"3.3.5:3.1.12"
	"3.3.4:3.1.12"
	"3.3.3:3.1.12"
	"3.3.2:3.1.12"
	"3.3.1:3.1.12"
	"3.3.0:3.1.11"
	"3.2.4:3.1.10"
	"3.2.3:3.1.10"
	"3.2.2:3.1.9"
	"3.2.1:3.1.9"
	"3.2.0:3.1.9"
	"3.1.13:3.1.9"
	"3.1.12:3.1.9"
	"3.1.11:3.1.9"
	"3.1.10:3.1.9"
	"3.1.9:3.1.9"
	"3.1.8:3.1.8"
	"3.1.7:3.1.7"
	"3.1.6:3.1.4"
	"3.1.5:3.1.4"
	"3.1.4:3.1.4"
)
PYTHON_COMPAT=( "python3_"{8..11} )

inherit check-compiler-switch cmake flag-o-matic libstdcxx-slot python-single-r1 virtualx

gen_half_pairs_rdepend() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}[${LIBSTDCXX_USEDEP}]
				media-libs/openexr:=
				~dev-libs/imath-${imath_pv}[${LIBSTDCXX_USEDEP}]
				dev-libs/imath:=
			)
		"
	done
}

gen_imath_bdepend() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}[${LIBSTDCXX_USEDEP}]
				media-libs/openexr:=
				~dev-libs/imath-${imath_pv}[${LIBSTDCXX_USEDEP}]
				dev-libs/imath:=
			)
		"
	done
}

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/OpenColorIO-${PV}"
SRC_URI="
https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="
https://opencolorio.org
https://github.com/AcademySoftwareFoundation/OpenColorIO
"
LICENSE="BSD"
# compares floating point numbers for bit equality
# compares floating point number string representations for equality
# https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1361 Apr 4, 2021
# https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1784 Apr 3, 2023
RESTRICT="
	test
"
SLOT="0/$(ver_cut 1-2)"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
doc opengl python static-libs test
ebuild_revision_6
"
REQUIRED_USE="
	doc? (
		python
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
	cpu_flags_x86_sse2? (
		cpu_flags_x86_sse
	)
	cpu_flags_x86_sse3? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse3
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_ssse3
		cpu_flags_x86_sse4
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_sse4? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
	)
"
# Depends update: Aug 31, 2023
RDEPEND="
	>=dev-cpp/yaml-cpp-0.7.0[${LIBSTDCXX_USEDEP}]
	dev-cpp/yaml-cpp:=
	>=dev-cpp/pystring-1.1.3[${LIBSTDCXX_USEDEP}]
	dev-cpp/pystring:=
	>=dev-libs/expat-2.4.1
	>=sys-libs/minizip-ng-3.0.7
	>=sys-libs/zlib-1.2.13
	dev-libs/tinyxml[${LIBSTDCXX_USEDEP}]
	dev-libs/tinyxml:=
	dev-build/ninja
	opengl? (
		>=media-libs/openimageio-2.2.14[${LIBSTDCXX_USEDEP}]
		media-libs/openimageio:=
		>=media-libs/lcms-2.2:2
		media-libs/freeglut
		media-libs/glew[${LIBSTDCXX_USEDEP}]
		media-libs/glew:=
		virtual/opengl
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.9.2[${PYTHON_USEDEP}]
		')
	)
	|| (
		$(gen_half_pairs_rdepend)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.14
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		$(python_gen_cond_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/expandvars[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-press-theme[${PYTHON_USEDEP}]
			dev-python/sphinx-tabs[${PYTHON_USEDEP}]
			dev-python/testresources[${PYTHON_USEDEP}]
		')
	)
	python? (
		$(python_gen_cond_dep '
			>=dev-python/setuptools-42[${PYTHON_USEDEP}]
		')
	)
	test? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
		>=media-libs/osl-1.11
		|| (
			$(gen_imath_bdepend)
		)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.2.1-adjust-python-installation.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	cmake_src_prepare

	sed -i -e "s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)|g" \
		{"","src/bindings/python/","src/OpenColorIO/","src/libutils/oglapphelpers/"}"CMakeLists.txt" \
		|| die
	sed -i -e "s|ARCHIVE DESTINATION lib|ARCHIVE DESTINATION $(get_libdir)|g" \
		{"","src/bindings/python/","src/OpenColorIO/","src/libutils/oglapphelpers/"}"CMakeLists.txt" \
		|| die

	# Avoid automagic test dependency on OSL, bug #833933
	# Can cause problems during e.g. OpenEXR unsplitting migration
	cmake_run_in "tests" "cmake_comment_add_subdirectory" "osl"

	# No references or generator bug.
	touch "share/cmake/modules/FindZLIBNG.cmake" || die
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	#
	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	#
	# Notes:
	# - OpenImageIO is required for building ociodisplay and ocioconvert (USE opengl)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE opengl)
	#
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DOCIO_BUILD_APPS=$(usex opengl)
		-DOCIO_BUILD_DOCS=$(usex doc)
		-DOCIO_BUILD_FROZEN_DOCS=$(usex doc)
		-DOCIO_BUILD_GPU_TESTS=$(usex test)
		-DOCIO_BUILD_JAVA=OFF
		-DOCIO_BUILD_OPENFX=OFF # Not packaged yet
		-DOCIO_BUILD_PYTHON=$(usex python)
		-DOCIO_BUILD_STATIC=$(usex static-libs)
		-DOCIO_BUILD_TESTS=$(usex test)
		-DOCIO_INSTALL_EXT_PACKAGES=NONE
		-DOCIO_PYTHON_VERSION="${EPYTHON/python/}"
		-DOCIO_USE_AVX=$(usex cpu_flags_x86_avx)
		-DOCIO_USE_AVX2=$(usex cpu_flags_x86_avx2)
		-DOCIO_USE_AVX512=$(usex cpu_flags_x86_avx512f)
		-DOCIO_USE_F16C=$(usex cpu_flags_x86_f16c)
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse)
		-DOCIO_USE_SSE2=$(usex cpu_flags_x86_sse2)
		-DOCIO_USE_SSE3=$(usex cpu_flags_x86_sse3)
		-DOCIO_USE_SSSE3=$(usex cpu_flags_x86_ssse3)
		-DOCIO_USE_SSE4=$(usex cpu_flags_x86_sse4)
		-DOCIO_USE_SSE42=$(usex cpu_flags_x86_sse4_2)
	)
	if \
		   use cpu_flags_x86_sse \
		|| use cpu_flags_arm_neon \
	; then
		mycmakeargs+=(
			-DDOCIO_USE_SIMD=ON
		)
	else
		mycmakeargs+=(
			-DDOCIO_USE_SIMD=OFF
		)
	fi

	# We need this to work around asserts that can trigger even in proper use cases.
	# See https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1235
	append-flags -DNDEBUG

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		-j1
	)
	virtx cmake_src_test
}

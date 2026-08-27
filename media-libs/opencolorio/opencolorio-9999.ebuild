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
# https://github.com/AcademySoftwareFoundation/OpenColorIO/blob/v2.5.2/docs/quick_start/installation.rst#building-from-source
# https://github.com/AcademySoftwareFoundation/openexr/blob/v3.4.0/MODULE.bazel

# Works with older OIIO but need to force a version w/ OpenEXR 3

CMAKE_BUILD_TYPE="RelWithDebInfo"
CXX_STANDARD=17
PYTHON_COMPAT=( "python3_"{9..14} )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
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

CHKL_TIMESTAMPS=(
	"dev-cpp/yaml-cpp-9999"
	"dev-libs/expat-9999"
	"media-libs/lcms-9999"
	"media-libs/openexr-9999"
	"media-libs/openimageio-3.0.9999"
	"media-libs/openimageio-3.1.9999"
	"media-libs/osl-9999"
	"sys-libs/minizip-ng-9999"
)

inherit check-compiler-switch chkl cmake flag-o-matic libcxx-slot libstdcxx-slot
inherit secure-version virtualx python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_VERSION="2.6.0"
	SOVER=$(ver_cut "1-2" "${INTERNAL_VERSION}")
	FALLBACK_COMMIT="5a808fb57a94c7229640a97835c420c9a1fbd1fe"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/OpenColorIO-${PV}"
	EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/OpenColorIO.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOVER=$(ver_cut "1-2" "${PV}")
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

S="${WORKDIR}/OpenColorIO-${PV}"

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
SLOT="0/${SOVER}"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
doc minizip-ng opengl python static-libs test
ebuild_revision_8
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
# Depends update:  Sep 29, 2025
RDEPEND="
	>=dev-cpp/yaml-cpp-${YAML_CPP_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-cpp/pystring-${PYSTRING_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/expat-${EXPAT_PV}:=
	>=media-libs/openexr-${OPENEXR_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	!minizip-ng? (
		>=sys-libs/zlib-${ZLIB_PV}:=[minizip]
	)
	minizip-ng? (
		>=sys-libs/minizip-ng-${MINIZIP_NG_PV}:=
	)
	opengl? (
		media-libs/openimageio:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		|| (
			=media-libs/openimageio-${OPENIMAGEIO_3_0_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			=media-libs/openimageio-${OPENIMAGEIO_3_1_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		)
		>=media-libs/lcms-${LCMS_PV}:=
		>=media-libs/freeglut-${FREEGLUT_PV}:=
		media-libs/glew:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		virtual/opengl:*
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.9.2[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_cond_dep '
		doc? (
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/expandvars[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			<dev-python/sphinx-7.1.3[${PYTHON_USEDEP}]
			dev-python/sphinx-press-theme[${PYTHON_USEDEP}]
			dev-python/sphinx-tabs[${PYTHON_USEDEP}]
			dev-python/testresources[${PYTHON_USEDEP}]
			<dev-python/urllib3-3[${PYTHON_USEDEP}]
			>=dev-python/docutils-0.22.4[${PYTHON_USEDEP}]
			<dev-python/setuptools-83.0.0[${PYTHON_USEDEP}]
		)
		python? (
			>=dev-python/setuptools-82.0.1[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		)
		test? (
			virtual/numpy:=[${PYTHON_USEDEP}]
		)
	')
	>=dev-build/cmake-3.14
	dev-build/ninja
	virtual/pkgconfig
	doc? (
		app-text/doxygen
	)
	test? (
		>=media-libs/osl-${OSL_PV}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.2.1-adjust-python-installation.patch"
)
DOCS=( "CHANGELOG.md" "README.md" )

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
	if has_version "sys-libs/zlib[minizip]" && use minizip-ng ; then
eerror "Re-emerge sys-libs/zlib with minizip disabled to continue."
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -E -e " VERSION [.0-9]+" "${S}/CMakeLists.txt" \
		| head -n 1 \
		| grep -o -E -e "[.0-9]+" \
		| cut -f "1-2" -d ".")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update INTERNAL_VERSION or SOVER"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
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
	chkl_check_many_timestamps
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

src_install() {
	cmake_src_install
	use doc && einstalldocs
	docinto "licenses"
	dodoc "THIRD-PARTY.md"
	dodoc "LICENSE"
}

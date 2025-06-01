# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# expandvars
# openfx
# prettymethods - delete references?
# sphinx-press-theme

# For requirements, see
# https://github.com/AcademySoftwareFoundation/OpenColorIO/blob/v2.2.1/docs/quick_start/installation.rst#building-from-source

# Works with older OIIO but need to force a version w/ OpenEXR 3

CMAKE_BUILD_TYPE="RelWithDebInfo"
OPENEXR_V3_PV=(
	# openexr:imath
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

inherit check-compiler-switch cmake flag-o-matic python-single-r1

gen_half_pairs_rdepend() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}:=
				~dev-libs/imath-${imath_pv}:=
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
				~media-libs/openexr-${openexr_pv}:=
				~dev-libs/imath-${imath_pv}:=
			)
		"
	done
}

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/OpenColorIO-${PV}"
SRC_URI="
https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/AcademySoftwareFoundation/OpenColorIO/commit/bdc4cd124140f997cdec1c5d7db72b1550fe7eac.patch
	-> opencolorio-commit-bdc4cd1.patch
"
# bdc4cd1 - Add support for minizip-ng 4 API

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="
https://opencolorio.org
https://github.com/AcademySoftwareFoundation/OpenColorIO
"
LICENSE="BSD"
# Restricting tests, bugs #439790 and #447908
RESTRICT="
	test
"
SLOT="0/$(ver_cut 1-2)"
IUSE="cpu_flags_x86_sse2 doc opengl python static-libs test ebuild_revision_2"
REQUIRED_USE="
	doc? (
		python
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
"
# Depends update Jan 5, 2023
RDEPEND="
	~dev-cpp/yaml-cpp-0.7.0:=
	>=dev-cpp/pystring-1.1.3
	>=dev-libs/expat-2.4.1
	>=sys-libs/minizip-ng-3.0.7
	>=sys-libs/zlib-1.2.13
	dev-libs/tinyxml
	dev-build/ninja
	opengl? (
		>=media-libs/openimageio-2.3.12.0-r3:=
		>=media-libs/lcms-2.2:2
		media-libs/freeglut
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
	>=dev-build/cmake-3.13
	virtual/pkgconfig
	doc? (
		$(python_gen_cond_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/expandvars[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
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
	"${DISTDIR}/${PN}-commit-bdc4cd1.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -i -e "s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)|g" \
		{,src/bindings/python/,src/OpenColorIO/,src/libutils/oglapphelpers/}CMakeLists.txt \
		|| die
	sed -i -e "s|ARCHIVE DESTINATION lib|ARCHIVE DESTINATION $(get_libdir)|g" \
		{,src/bindings/python/,src/OpenColorIO/,src/libutils/oglapphelpers/}CMakeLists.txt \
		|| die

	# Avoid automagic test dependency on OSL, bug #833933
	# Can cause problems during e.g. OpenEXR unsplitting migration
	cmake_run_in tests cmake_comment_add_subdirectory osl

	# No references or generator bug.
	touch share/cmake/modules/FindZLIBNG.cmake || die
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
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse2)
	)

	# We need this to work around asserts that can trigger even in proper use cases.
	# See https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1235
	append-flags -DNDEBUG

	cmake_src_configure
}

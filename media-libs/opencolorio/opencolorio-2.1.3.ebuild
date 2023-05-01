# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="
https://opencolorio.org
https://github.com/AcademySoftwareFoundation/OpenColorIO
"
SRC_URI="
https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/OpenColorIO-${PV}"

LICENSE="BSD"
# TODO: drop .1 on next SONAME bump (2.1 -> 2.2?) as we needed to nudge it
# to force rebuild of consumers due to changing to openexr 3 changing API.
SLOT="0/$(ver_cut 1-2).1"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="cpu_flags_x86_sse2 doc opengl python static-libs test"
REQUIRED_USE="
	doc? (
		python
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
"

# Works with older OIIO but need to force a version w/ OpenEXR 3

OPENEXR_V2_PV="2.5.8 2.5.7"
OPENEXR_V3_PV="3.1.7 3.1.5 3.1.4"

gen_half_pairs() {
	local pv
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~dev-libs/imath-${pv}:=
			)
		"
	done
	for pv in ${OPENEXR_V2_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~media-libs/ilmbase-${pv}:=
			)
		"
	done
}

gen_imath() {
	local pv
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				~dev-libs/imath-${pv}:=
				~media-libs/openexr-${pv}:=
			)
		"
	done
}

# See https://github.com/AcademySoftwareFoundation/OpenColorIO/blob/v2.1.3/docs/quick_start/installation.rst#building-from-source
RDEPEND="
	>=dev-cpp/yaml-cpp-0.6.3:=
	>=dev-libs/expat-2.2.8
	>=dev-cpp/pystring-1.1.3
	>=sys-libs/zlib-1.2.13
	dev-libs/tinyxml
	dev-util/ninja
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
			>=dev-python/pybind11-2.6.1[${PYTHON_USEDEP}]
		')
	)
	|| (
		$(gen_half_pairs)
	)
"
DEPEND="
	${RDEPEND}
"
# TODO package:
# expandvars
# openfx
# prettymethods - delete references?
# sphinx-press-theme
BDEPEND="
	>=dev-util/cmake-3.12
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
		>=media-libs/osl-1.11
		|| (
			$(gen_imath)
		)
	)
"

# Restricting tests, bugs #439790 and #447908
RESTRICT="test"

CMAKE_BUILD_TYPE=RelWithDebInfo

PATCHES=(
	"${FILESDIR}/${PN}-2.1.1-gcc12.patch"
	"${FILESDIR}/${PN}-2.2.1-python-exact.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -i -e "s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)|g" \
		{,src/bindings/python/,src/OpenColorIO/,src/libutils/oiiohelpers/,src/libutils/oglapphelpers/}CMakeLists.txt \
		|| die
	sed -i -e "s|ARCHIVE DESTINATION lib|ARCHIVE DESTINATION $(get_libdir)|g" \
		{,src/bindings/python/,src/OpenColorIO/,src/libutils/oiiohelpers/,src/libutils/oglapphelpers/}CMakeLists.txt \
		|| die

	# Avoid automagic test dependency on OSL, bug #833933
	# Can cause problems during e.g. OpenEXR unsplitting migration
	cmake_run_in tests cmake_comment_add_subdirectory osl
}

src_configure() {
	#
	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	#
	# Notes:
	# - OpenImageIO is required for building ociodisplay and ocioconvert (USE opengl)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE opengl)
	#
	local has_imath
	if has_version "=dev-libs/imath-2*" ; then
		einfo "Found imath 2.x"
		has_imath=ON
	else
		einfo "imath 2.x NOT found"
		has_imath=OFF
	fi
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DOCIO_BUILD_APPS=$(usex opengl)
		-DOCIO_BUILD_DOCS=$(usex doc)
		-DOCIO_BUILD_FROZEN_DOCS=$(usex doc)
		-DOCIO_BUILD_GPU_TESTS=$(usex test)
		-DOCIO_BUILD_JAVA=OFF
		-DOCIO_BUILD_PYTHON=$(usex python)
		-DOCIO_BUILD_STATIC=$(usex static-libs)
		-DOCIO_BUILD_TESTS=$(usex test)
		-DOCIO_INSTALL_EXT_PACKAGES=NONE
		-DOCIO_PYTHON_VERSION="${EPYTHON/python/}"
		-DOCIO_USE_OPENEXR_HALF=${has_imath}
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse2)
	)

	# We need this to work around asserts that can trigger even in proper use cases.
	# See https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1235
	append-flags -DNDEBUG

	cmake_src_configure
}

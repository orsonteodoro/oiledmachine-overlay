# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cmake libstdcxx-slot python-single-r1

KEYWORDS="~amd64 ~arm64 ~arm64-macos ~amd64-linux"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/AcademySoftwareFoundation/${MY_PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Imath basic math package"
HOMEPAGE="https://imath.readthedocs.io"
LICENSE="BSD"
# For slotting, see https://github.com/AcademySoftwareFoundation/Imath/blob/v3.1.12/CMakeLists.txt#L41
SLOT_MAJOR="${PV%%.*}"
SO_VERSION="29"
SLOT="${SLOT_MAJOR}/${SO_VERSION}"
IUSE="doc large-stack python test"
REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
	)
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	sys-libs/zlib
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		$(python_gen_cond_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-press-theme[${PYTHON_USEDEP}]
		')
	)
	python? (
		${PYTHON_DEPS}
	)
"

DOCS=( "CHANGES.md" "CONTRIBUTORS.md" "README.md" "SECURITY.md" )

PATCHES=(
	"${FILESDIR}/${PN}-3.1.11-fix_cmake_module_export.patch"
	"${FILESDIR}/${PN}-3.1.11-use-correct-boost_python_version.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

src_configure() {
	local so_ver=$(grep -o -E "IMATH_LIBTOOL_CURRENT [0-9]+" "CMakeLists.txt" \
		| cut -f 2 -d " ")
einfo "SLOT:  ${SLOT}"
einfo "SO VERSION:  ${so_ver}"
	if ! grep -q -e "IMATH_LIBTOOL_CURRENT ${SLOT#*/}" "CMakeLists.txt" ; then
eerror "Bump subslot to ${so_ver}"
		die
	fi
	local mycmakeargs=(
		-DBUILD_WEBSITE="$(usex doc)"
		-DIMATH_ENABLE_LARGE_STACK="$(usex large-stack)"
		# the following options are at their default value
		-DIMATH_HALF_USE_LOOKUP_TABLE=ON
		-DIMATH_INSTALL_PKG_CONFIG=ON
		-DIMATH_USE_CLANG_TIDY=OFF
		-DIMATH_USE_DEFAULT_VISIBILITY=OFF
		-DIMATH_USE_NOEXCEPT=ON
	)
	if use python; then
		mycmakeargs+=(
			-DBoost_NO_BOOST_CMAKE=OFF
			-DPYTHON=ON
			-DPython3_EXECUTABLE="${PYTHON}"
			-DPython3_INCLUDE_DIR="$(python_get_includedir)"
			-DPython3_LIBRARY="$(python_get_library_path)"
		)
	fi
	cmake_src_configure
}

src_install() {
	use doc && HTML_DOCS=(
		"${BUILD_DIR}/website/sphinx/."
	)
	cmake_src_install
}

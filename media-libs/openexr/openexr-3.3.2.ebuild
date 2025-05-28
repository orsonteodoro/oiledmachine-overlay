# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OpenEXR"

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE HO IO UAF"
CPU_FLAGS_X86=(
	cpu_flags_x86_avx
)
OPENEXR_IMAGES_PV="1.0"

inherit cflags-hardened cmake flag-o-matic

KEYWORDS="~amd64 ~arm64 ~arm64-macos ~amd64-linux ~x86-linux"
SRC_URI="
https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
		utils? (
https://github.com/AcademySoftwareFoundation/openexr-images/archive/refs/tags/v${OPENEXR_IMAGES_PV}.tar.gz
	-> openexr-images-${OPENEXR_IMAGES_PV}.tar.gz
		)
	)
"

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://openexr.com/"
LICENSE="BSD"
# SLOT is based on SONAME.
# See https://github.com/AcademySoftwareFoundation/openexr/blob/v3.3.2/CMakeLists.txt#L46
SLOT="0/32"
IUSE="
${CPU_FLAGS_X86[@]}
doc examples -large-stack +utils test +threads
ebuild_revision_6
"
REQUIRED_USE="
	doc? (
		utils
	)
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	>=app-arch/libdeflate-1.21:=[zlib(+)]
	~dev-libs/imath-3.1.12:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		sys-apps/help2man
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-3.2.1-bintests-iff-utils.patch"
)
DOCS=(
	"CHANGES.md"
	"GOVERNANCE.md"
	"PATENTS"
	"README.md"
	"SECURITY.md"
)

src_prepare() {
	# Fix path for testsuite
	sed \
		-i \
		-e "s:/var/tmp/:${T}:" \
		"${S}/src/test/${MY_PN}Test/tmpDir.h" \
		|| die "failed to set temp path for tests"

	sed \
		-i \
		-e "s:if(INSTALL_DOCS):if(OPENEXR_INSTALL_DOCS):" \
		"docs/CMakeLists.txt" \
		|| die

	cmake_src_prepare

	if use test && use utils ; then
		local IMAGES=(
			"Beachball/multipart.0001.exr"
			"Beachball/singlepart.0001.exr"
			"Chromaticities/Rec709.exr"
			"Chromaticities/Rec709_YC.exr"
			"Chromaticities/XYZ.exr"
			"Chromaticities/XYZ_YC.exr"
			"LuminanceChroma/Flowers.exr"
			"LuminanceChroma/Garden.exr"
			"MultiResolution/ColorCodedLevels.exr"
			"MultiResolution/WavyLinesCube.exr"
			"MultiResolution/WavyLinesLatLong.exr"
			"MultiView/Adjuster.exr"
			"TestImages/GammaChart.exr"
			"TestImages/GrayRampsHorizontal.exr"
			"v2/LeftView/Balls.exr"
			"v2/Stereo/Trunks.exr"
		)

		mkdir -p "${BUILD_DIR}/src/test/bin" || die

		local image
		for image in "${IMAGES[@]}"; do
			mkdir -p "${BUILD_DIR}/src/test/bin/"$(dirname "${image}") || die
			cp -a \
				"${WORKDIR}/openexr-images-1.0/${image}" \
				"${BUILD_DIR}/src/test/bin/${image}" \
				|| die
		done
	fi

}

src_configure() {
	local so_ver=$(grep -o -E "OPENEXR_LIB_SOVERSION [0-9]+" "CMakeLists.txt" | cut -f 2 -d " ")
einfo "SOVER:  ${so_ver}"
	if ! grep -q -e "OPENEXR_LIB_SOVERSION ${SLOT#*/}" "CMakeLists.txt" ; then
einfo "Update SLOT to ${so_ver}"
		die
	fi
	if use x86 ; then
		replace-cpu-flags "native" "i686"
	fi

	cflags-hardened_append

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS="yes"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_WEBSITE="no"
		-DOPENEXR_BUILD_EXAMPLES="$(usex examples)"
		-DOPENEXR_BUILD_PYTHON="no"
		-DOPENEXR_BUILD_TOOLS="$(usex utils)"
		-DOPENEXR_CXX_STANDARD="17"
		-DOPENEXR_ENABLE_LARGE_STACK="$(usex large-stack)"
		-DOPENEXR_ENABLE_THREADING="$(usex threads)"
		-DOPENEXR_FORCE_INTERNAL_DEFLATE="no"
		-DOPENEXR_FORCE_INTERNAL_IMATH="no"
		-DOPENEXR_INSTALL="yes"
		-DOPENEXR_INSTALL_DOCS="$(usex doc)"
		-DOPENEXR_INSTALL_PKG_CONFIG="yes"
		-DOPENEXR_INSTALL_TOOLS="$(usex utils)"
		-DOPENEXR_USE_CLANG_TIDY="no" # don't look for clang-tidy
	)

	if use test; then
	# OPENEXR_RUN_FUZZ_TESTS depends on BUILD_TESTING, see
	#   - https://bugs.gentoo.org/925128
	#   - https://openexr.com/en/latest/install.html#component-options
	# NOTE: the fuzz tests are very slow

		mycmakeargs+=(
			-DOPENEXR_RUN_FUZZ_TESTS="ON"
		)
	fi

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=()
	use arm64 && CMAKE_SKIP_TESTS+=(
		# bug #922247
		'OpenEXRCore.testDWAACompression'
		'OpenEXRCore.testDWABCompression'
	)
	use x86 && CMAKE_SKIP_TESTS+=(
		'^OpenEXR.testDwaLookups$'
	)
	cmake_src_test
}

src_install() {
	use examples && docompress -x "/usr/share/doc/${PF}/examples"
	cmake_src_install
}

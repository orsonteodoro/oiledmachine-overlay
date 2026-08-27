# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OpenEXR"

# See also https://openexr.com/en/latest/install.html
# For imath version, see:
# https://github.com/AcademySoftwareFoundation/openexr/blob/main/.github/workflows/ci_workflow.yml#L83
# https://github.com/AcademySoftwareFoundation/openexr/blob/main/MODULE.bazel

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE HO IO UAF"
CXX_STANDARD=17
OPENEXR_IMAGES_PV="1.0"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
)

CHKL_TIMESTAMPS=(
	"dev-cpp/tbb-9999"
	"app-arch/libdeflate-9999"
)

inherit cflags-hardened chkl flag-o-matic libcxx-slot libstdcxx-slot secure-version cmake

if [[ "${PV}" =~ "9999" ]] ; then
	SOVER="99"
	FALLBACK_COMMIT="cfa2502daac8c41c0bcea78d5ca8ff53c8330e54"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/openexr.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOVER="33"
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
fi

CHKL_TIMESTAMPS=(
	"app-arch/libdeflate-9999"
	"dev-cpp/tbb-9999"
)

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://openexr.com/"
LICENSE="BSD"
# SLOT is based on SONAME.
# See https://github.com/AcademySoftwareFoundation/openexr/blob/main/CMakeLists.txt#L46
SLOT="0/${SOVER}"
IUSE+="
${CPU_FLAGS_X86[@]}
doc examples -large-stack +utils tbb test +threads
ebuild_revision_24
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
	>=app-arch/libdeflate-${LIBDEFLATE_PV}:=[zlib(+)]
	~dev-libs/imath-${IMATH_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=media-libs/openjph-${OPENJPH_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	tbb? (
		>=dev-cpp/tbb-${TBB_PV}:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>dev-build/cmake-3.14
	virtual/pkgconfig
	doc? (
		sys-apps/help2man
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-3.2.1-bintests-iff-utils.patch"
)
DOCS=( "CHANGES.md" "README.md" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
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
	local actual_sover=$(grep -e "OPENEXR_LIB_SOVERSION" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d " " | sed -e "s|)||g")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER"
eerror "Actual sover:  ${actual_sover}"
eerror "Expected sover:  ${expected_sover}"
		die
	fi
	local actual_imath_pv=$(grep -e "imath" "${S}/MODULE.bazel" | cut -f 6 -d " " | cut -f 2 -d '"' | cut -f 1-3 -d ".")
	local expected_imath_pv="${IMATH_PV}"
	if ver_test "${actual_imath_pv}" "-ne" "${expected_imath_pv}" ; then
eerror "QA:  Update IMATH_PV"
eerror "Actual imath pv:  ${actual_imath_pv}"
eerror "Expected imath pv:  ${expected_imath_pv}"
		die
	fi
}

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
	chkl_check_many_timestamps
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
		-DOPENEXR_FORCE_INTERNAL_OPENJPH="no"
		-DOPENEXR_INSTALL="yes"
		-DOPENEXR_INSTALL_DOCS="$(usex doc)"
		-DOPENEXR_INSTALL_PKG_CONFIG="yes"
		-DOPENEXR_INSTALL_TOOLS="$(usex utils)"
		-DOPENEXR_USE_CLANG_TIDY="no" # don't look for clang-tidy
		-DOPENEXR_USE_TBB="$(usex tbb)"
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
	docinto "licenses"
	dodoc "PATENTS"
}

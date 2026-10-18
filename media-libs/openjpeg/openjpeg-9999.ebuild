# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data security-critical"

MY_TESTDATA_COMMIT="39524bd3a601d90ed8e0177559400d23945f96a9"

CHKL_TIMESTAMPS=(
	"media-libs/lcms-9999"
	"media-libs/libpng-9999"
	"media-libs/tiff-9999"
)

inherit cflags-hardened chkl cmake-multilib flag-o-matic secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_VERSION="2.5.4"
	SOMAJOR=$(ver_cut "1" "${INTERNAL_VERSION}")
	FALLBACK_COMMIT="8314119b067c0fc77834731168daaebd379fdb12"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/uclouvain/openjpeg.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOMAJOR=$(ver_cut "1" "${PV}")
	SRC_URI="
https://github.com/uclouvain/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
https://github.com/uclouvain/openjpeg-data/archive/${MY_TESTDATA_COMMIT}.tar.gz -> ${PN}-data_20241113.tar.gz
	)
"
fi

# Make sure that test data are not newer than release;
# otherwise we will see "Found-But-No-Test" test failures!
#
# To update: Go to https://github.com/uclouvain/openjpeg-data and grab the hash
# of the latest possible commit whose commit date is older than the release
# date.

DESCRIPTION="Open-source JPEG 2000 library"
HOMEPAGE="https://www.openjpeg.org"
LICENSE="BSD-2"
SOVER="7"
SLOT="${SOMAJOR}/${SOVER}" # based on SONAME
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE+=" doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=media-libs/lcms-${LCMS_PV}:=
	>=media-libs/libpng-${LIBPNG_PV}:=
	>=media-libs/tiff-${TIFF_PV}:=
	>=virtual/zlib-${ZLIB_PV}:=
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

DOCS=( AUTHORS.md CHANGELOG.md NEWS.md README.md THANKS.md )

PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		unpack ${A}
	fi
	local pv_a=$(grep -o -E "OPENJPEG_VERSION_MAJOR [0-9]+" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d " ")
	local pv_b=$(grep -o -E "OPENJPEG_VERSION_MINOR [0-9]+" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d " ")
	local pv_c=$(grep -o -E "OPENJPEG_VERSION_BUILD [0-9]+" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d " ")
	local actual_somajor="${pv_a}"
	local expected_somajor="${SOMAJOR}"
	if ver_test "${actual_somajor}" "-ne" "${expected_somajor}" ; then
eerror "Bump INTERNAL_VERSION, PV"
eerror "Actual somajor:  ${actual_somajor}"
eerror "Expected somajor:  ${expected_somajor}"
		die
	fi
	local actual_sover=$(grep -o -E "OPENJPEG_SOVERSION [0-9]+" "${S}/CMakeLists.txt" | head -n 1 | cut -f 2 -d " ")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "Bump SOVER"
eerror "Actual sover:  ${actual_sover}"
eerror "Expected sover:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	if use test; then
		mv "${WORKDIR}"/openjpeg-data-${MY_TESTDATA_COMMIT} "${WORKDIR}"/data ||
			die "Failed to rename test data"
	fi

	rm -r thirdparty/lib* thirdparty/include || die
	cmake_src_prepare
}

multilib_src_configure() {
	chkl_check_many_timestamps
	append-lfs-flags
	cflags-hardened_append

	local mycmakeargs=(
		-DBUILD_TESTING="$(multilib_native_usex test)"
		-DBUILD_DOC=$(multilib_native_usex doc ON OFF)
		-DBUILD_CODEC=$(multilib_is_native_abi && echo ON || echo OFF)
		-DBUILD_STATIC_LIBS=OFF
		$(multilib_is_native_abi && echo -DBUILD_THIRDPARTY=OFF)
	)

	# Cheat a little bit and force disabling fixed point magic
	# The test suite is extremely fragile to small changes
	# bug #715130, bug #715422
	# https://github.com/uclouvain/openjpeg/issues/1017
	if multilib_is_native_abi && use test ; then
		append-cflags "-ffp-contract=off"
	fi

	cmake_src_configure
}

multilib_src_test() {
	if ! multilib_is_native_abi ; then
		elog "Cannot run tests for non-multilib abi."
		return 0
	fi

	pushd "${BUILD_DIR}" > /dev/null || die
	[[ -e CTestTestfile.cmake ]] || die "Test suite not available! Check source!"

	elog "Note: Upstream maintains a list of known test failures."
	elog "We collect all the known failures and skip them."
	elog

	local toskip=( "${S}"/tools/travis-ci/knownfailures-all.txt )
	if use amd64 ; then
		toskip+=( "${S}"/tools/travis-ci/knownfailures-*x86_64*.txt )
	elif use x86 || use arm || use arm64; then
		toskip+=( "${S}"/tools/travis-ci/knownfailures-*i386*.txt )
	fi
	if has_version "sys-libs/zlib-ng" ; then
		elog "Some tests will be skipped due to being known to fail with sys-libs/zlib-ng"
		elog
		toskip+=( "${FILESDIR}"/zlib-ng-knownfailures.txt )
	fi

	local exp=$(sort "${toskip[@]}" | uniq | tr '\n' '|'; assert)
	popd > /dev/null || die

	local myctestargs=()
	if [[ -n ${TEST_VERBOSE} ]]; then
		myctestargs+=( --extra-verbose --output-on-failure )
	fi
	myctestargs+=( -E "(${exp::-1})" )

	cmake_src_test
}

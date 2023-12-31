# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To find test archive version, see
# https://github.com/nlohmann/json/blob/develop/cmake/download_test_data.cmake
TEST_VERSION="3.1.0"

inherit cmake-multilib

SRC_URI="
https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz
test? (
https://github.com/nlohmann/json_test_data/archive/v${TEST_VERSION}.tar.gz
	-> ${PN}-testdata-${TEST_VERSION}.tar.gz
)
"
S="${WORKDIR}/json-${PV}"

DESCRIPTION="JSON for Modern C++"
HOMEPAGE="
	https://github.com/nlohmann/json
	https://nlohmann.github.io/json/
"
LICENSE="MIT"
RESTRICT="test"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc test"
# U 22.04
BDEPEND="
	>=dev-util/cmake-3.22.1
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.9.1
	)
"
DOCS=( ChangeLog.md README.md )

src_configure() {
	# Tests are built by default so we can't group the test logic below
	local mycmakeargs=(
		-DJSON_MultipleHeaders=ON
		-DJSON_BuildTests=$(usex test)
	)

	# Define test data directory here to avoid unused var QA warning, bug
	# #747826
	if use test ; then
		mycmakeargs+=( -DJSON_TestDataDirectory="${S}"/json_test_data )
	fi

	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile

	if use doc; then
		emake -C doc
		HTML_DOCS=( doc/html/. )
	fi
}

src_test() {
	cd "${BUILD_DIR}/test" || die

	# Skip certain tests needing git per upstream
	# https://github.com/nlohmann/json/issues/2189
	local myctestargs=(
		"-LE git_required"
	)

	cmake-multilib_src_test
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  bear

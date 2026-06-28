# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
#DOCS_BUILDER="mkdocs"
# Needs unpackaged plantuml-markdown too
# ... but plantuml (Python bindings anyway) need network access to generate bits at runtime.
#DOCS_DEPEND="dev-python/mkdocs-material-extensions dev-python/mkdocs-minify-plugin"
#DOCS_DIR="doc/mkdocs"

TEST_VERSION="3.1.0"

inherit cmake-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="c37f82e5630c6a36b37b995896e1523c1d1f0654"
	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/nlohmann/json.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${PN}-${PV}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/json-${PV}"
	SRC_URI="
https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
https://github.com/nlohmann/json_test_data/archive/v${TEST_VERSION}.tar.gz -> ${PN}-testdata-${TEST_VERSION}.tar.gz
	)
"

fi

# Check https://github.com/nlohmann/json/blob/develop/cmake/download_test_data.cmake to find test archive version
DESCRIPTION="JSON for Modern C++"
HOMEPAGE="https://github.com/nlohmann/json https://nlohmann.github.io/json/"

LICENSE="MIT"
SLOT="0"
IUSE+=" test"
RESTRICT="!test? ( test )"

DOCS=( ChangeLog.md README.md )

PATCHES=(
)

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
}

src_prepare() {
	if use test ; then
		ln -s "${WORKDIR}"/json_test_data-${TEST_VERSION} "${S}"/json_test_data || die
	fi

	cmake_src_prepare
}

src_configure() {
	# Tests are built by default so we can't group the test logic below
	local mycmakeargs=(
		-DJSON_MultipleHeaders=ON
		-DJSON_BuildTests=$(usex test)
	)

	# Define test data directory here to avoid unused var QA warning, bug #747826
	use test && mycmakeargs+=( -DJSON_TestDataDirectory="${S}"/json_test_data )

	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile
}

src_test() {
	cd "${BUILD_DIR}"/tests || die

	# git_required:
	# Skip certain tests needing git per upstream
	# https://github.com/nlohmann/json/issues/2189
	#
	# cmake_fetch_content_configure, cmake_fetch_content2_configure:
	# Needs network (bug #865027, bug #865105)
	local myctestargs=(
		-E "(git_required|cmake_fetch_content_configure|cmake_fetch_content2_configure|cmake_fetch_content_build|cmake_fetch_content2_build)"
	)

	cmake-multilib_src_test
}

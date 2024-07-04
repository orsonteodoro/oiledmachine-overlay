# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump every month

# Different date format used upstream.
RE2_VER="${PV#0.}"
RE2_VER="${RE2_VER//./-}"
SONAME="10"				# https://github.com/google/re2/blob/2023-03-01/CMakeLists.txt#L33

inherit cmake-multilib toolchain-funcs

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
S="${WORKDIR}/re2-${RE2_VER}"
SRC_URI="
https://github.com/google/re2/archive/${RE2_VER}.tar.gz
	-> re2-${RE2_VER}.tar.gz
"

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
LICENSE="BSD"
SLOT="0/${SONAME}"
IUSE="-debug icu test"
RDEPEND="
	icu? (
		dev-libs/icu:0=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	icu? (
		virtual/pkgconfig
	)
"
DOCS=( "AUTHORS" "CONTRIBUTORS" "README" "doc/syntax.txt" )
HTML_DOCS=( "doc/syntax.html" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DBUILD_SHARED_LIBS=ON
		-DRE2_BUILD_TESTING=$(usex debug)
		-DRE2_USE_ICU=$(usex icu)
	)
	cmake-multilib_src_configure
}

test_abi() {
	pushd "${WORKDIR}/${PN}-${RE2_VER}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
		local configuration=$(usex debug "Debug" "Release")
		ctest -C ${configuration} --output-on-failure -E 'dfa|exhaustive|random' || die
	popd
}

src_test() {
	multilib_foreach_abi test_abi
}

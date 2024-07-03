# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump every month

# Different date format used upstream.
RE2_VER="${PV#0.}"
RE2_VER="${RE2_VER//./-}"
SONAME="11" # https://github.com/google/re2/blob/2024-07-02/CMakeLists.txt#L33

inherit cmake-multilib toolchain-funcs

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
SRC_URI="https://github.com/google/re2/archive/${RE2_VER}.tar.gz -> re2-${RE2_VER}.tar.gz"
S="${WORKDIR}/re2-${RE2_VER}"

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
LICENSE="BSD"
SLOT="0/${SONAME}"
IUSE="-debug icu test"
BDEPEND="
	icu? (
		virtual/pkgconfig
	)
"
DEPEND="
	icu? (
		dev-libs/icu:0=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
"
DOCS=( README doc/syntax.txt )
HTML_DOCS=( doc/syntax.html )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DBUILD_SHARED_LIBS=ON
		-DRE2_BUILD_TESTING=$(usex debug)
		-DRE2_USE_ICU=$(usex icu)
	)
	cmake-multilib_src_configure
}

src_test() {
	local configuration=$(usex debug "Debug" "Release")
	ctest -C ${configuration} --output-on-failure -E 'dfa|exhaustive|random'
}

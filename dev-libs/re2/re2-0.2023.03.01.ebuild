# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump every month

GCC_COMPAT=(
	"gcc_slot_11_5" # Support -std=c++14
	"gcc_slot_12_5" # Support -std=c++14
	"gcc_slot_13_3" # Support -std=c++14
	"gcc_slot_14_3" # Support -std=c++14
)

RE2_VER="${PV#0.}"
RE2_VER="${RE2_VER//./-}"

# Different date format used upstream.
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_LANGS="cxx"
SONAME="10"				# https://github.com/google/re2/blob/2023-03-01/CMakeLists.txt#L33

inherit cflags-hardened cmake-multilib libstdcxx-slot toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/re2-${RE2_VER}"
SRC_URI="
https://github.com/google/re2/archive/${RE2_VER}.tar.gz
	-> re2-${RE2_VER}.tar.gz
"

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
LICENSE="BSD"
SLOT="0/${SONAME}"
IUSE="
-debug icu test
ebuild_revision_13
"
RDEPEND="
	icu? (
		dev-libs/icu:0[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-libs/icu:=
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

pkg_setup() {
	libstdcxx-slot_verify
}

src_configure() {
	cflags-hardened_append
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

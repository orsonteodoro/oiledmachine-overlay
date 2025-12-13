# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump every month

MY_PV="${PV#0.}"
MY_PV="${MY_PV//./-}"

ABSEIL_CPP_PV="20220623.0"		# Pre absl changes, based on gRPC 1.51
ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_LANGS="cxx"
CXX_STANDARD=14
SONAME="10"				# https://github.com/google/re2/blob/2023-03-01/CMakeLists.txt#L33

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX14[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX14[@]/llvm_slot_}"
)

inherit cflags-hardened cmake-multilib libcxx-slot libstdcxx-slot toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/re2-${MY_PV}"
SRC_URI="
https://github.com/google/re2/archive/${MY_PV}.tar.gz
	-> re2-${MY_PV}.tar.gz
"

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
LICENSE="BSD"
SLOT="${ABSEIL_CPP_SLOT}"
IUSE="
-debug icu test
ebuild_revision_18
"
RDEPEND="
	icu? (
		dev-libs/icu:0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
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
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DCMAKE_INSTALL_PREFIX="/usr/lib/re2/${SLOT}"
		-DBUILD_SHARED_LIBS=ON
		-DRE2_BUILD_TESTING=$(usex debug)
		-DRE2_USE_ICU=$(usex icu)
	)
	cmake-multilib_src_configure
}

test_abi() {
	pushd "${WORKDIR}/${PN}-${MY_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
		local configuration=$(usex debug "Debug" "Release")
		ctest -C "${configuration}" --output-on-failure -E 'dfa|exhaustive|random' || die
	popd
}

src_test() {
	multilib_foreach_abi test_abi
}

src_install() {
	cmake-multilib_src_install
	mv "${ED}/usr/share" "${ED}/usr/lib/re2/${SLOT}" || die
}

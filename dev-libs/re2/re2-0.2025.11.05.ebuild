# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump every month

MY_PV="${PV#0.}"
MY_PV="${MY_PV//./-}"

# Different date format used upstream.
ABSEIL_CPP_PV="20250512.1"		# https://github.com/google/re2/blob/2025-11-05/MODULE.bazel#L16
ABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%.*}"
CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_LANGS="asm cxx"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CXX_STANDARD=17
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
SONAME="11"				# https://github.com/google/re2/blob/2025-11-05/CMakeLists.txt#L33

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cflags-hardened cmake-multilib distutils-r1 libcxx-slot libstdcxx-slot
inherit toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/re2-${MY_PV}"
SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_PV}.tar.gz -> abseil-cpp-${ABSEIL_CPP_PV}.tar.gz
https://github.com/google/re2/archive/${MY_PV}.tar.gz
	-> re2-${MY_PV}.tar.gz
"

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
LICENSE="BSD"
SLOT="${ABSEIL_CPP_SLOT}"
IUSE="
-debug icu test
ebuild_revision_16
"
RDEPEND="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	icu? (
		dev-libs/icu:0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-libs/icu:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-cpp/benchmark-1.8.3
	>=dev-cpp/gtest-1.14.0
	icu? (
		virtual/pkgconfig
	)
"
DOCS=( "README.md" "doc/syntax.txt" )
HTML_DOCS=( "doc/syntax.html" )

pkg_setup() {
	python_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare
	multilib_copy_sources

	prepare_multilib_abseil() {
		mkdir -p "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
	}
	multilib_foreach_abi prepare_multilib_abseil
}

build_multilib_abseil() {
	pushd "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}"  >/dev/null 2>&1 || die
		mkdir -p build || die
		cd build || die
		append-flags -fPIC
		cmake \
			-DCMAKE_INSTALL_PREFIX="/" \
			"${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}" \
			|| die
		emake
		DESTDIR="${WORKDIR}/${PN}-${MY_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}/abseil-cpp" emake install
	popd  >/dev/null 2>&1 || die
}

src_configure() {
	multilib_foreach_abi build_multilib_abseil
	configure_multilib_re2() {
		cflags-hardened_append
		local mycmakeargs=(
			-DBUILD_SHARED_LIBS=ON
			-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
			-DCMAKE_INSTALL_PREFIX="/usr/lib/re2/${SLOT}"
			-DRE2_BUILD_TESTING=$(usex debug)
			-DRE2_USE_ICU=$(usex icu)
			-Dabsl_DIR="${WORKDIR}/${PN}-${MY_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}/abseil-cpp/usr/$(get_libdir)/cmake/absl"
		)
		cmake_src_configure
	}
	multilib_foreach_abi configure_multilib_re2
}

src_compile() {
	cmake-multilib_src_compile
}

test_abi() {
	pushd "${WORKDIR}/${PN}-${MY_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}" >/dev/null 2>&1 || die
		local configuration=$(usex debug "Debug" "Release")
		ctest -C "${configuration}" --output-on-failure -E 'dfa|exhaustive|random' || die
	popd  >/dev/null 2>&1 || die
}

src_test() {
	multilib_foreach_abi test_abi
}

src_install() {
	cmake-multilib_src_install
	mv "${ED}/usr/share" "${ED}/usr/lib/re2/${SLOT}" || die
}

# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bazel needed to avoid multiple abseil-cpp subslots.

# Bump every month

# Different date format used upstream.
ABSEIL_CPP_PV="20240116.2"						# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L16
PYTHON_COMPAT=( "python3_"{10..12} )
RE2_VER="${PV#0.}"
RE2_VER="${RE2_VER//./-}"
SONAME="11" # https://github.com/google/re2/blob/2024-07-02/CMakeLists.txt#L33

inherit cmake distutils-r1 toolchain-funcs

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_PV}.tar.gz -> abseil-cpp-${ABSEIL_CPP_PV}.tar.gz
https://github.com/google/re2/archive/${RE2_VER}.tar.gz
	-> re2-${RE2_VER}.tar.gz
"
S="${WORKDIR}/re2-${RE2_VER}"

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
LICENSE="BSD"
SLOT="0/${SONAME}"
IUSE="-debug icu test"
RDEPEND="
	dev-python/absl-py[${PYTHON_USEDEP}]
	icu? (
		dev-libs/icu:0=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-cpp/benchmark-1.8.3
	>=dev-cpp/gtest-1.14.0
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	icu? (
		virtual/pkgconfig
	)
"
DOCS=( "README" "doc/syntax.txt" )
HTML_DOCS=( "doc/syntax.html" )

pkg_setup() {
	python_setup
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare
	python_copy_sources
}

build_abseil() {
#var/tmp/portage/dev-libs/re2-0.2024.07.02/work/abseil-cpp-20240116.2/build/install
	pushd "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}" || die
		mkdir -p build || die
		cd build || die
		append-flags -fPIC
		cmake \
			-DCMAKE_INSTALL_PREFIX="/" \
			.. \
			|| die
		emake -j1
		DESTDIR="${S}/abseil-cpp" emake install
	popd || die
}

python_configure() {
	build_abseil
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		-DBUILD_SHARED_LIBS=ON
		-DRE2_BUILD_TESTING=$(usex debug)
		-DRE2_USE_ICU=$(usex icu)
		-Dabsl_DIR="${WORKDIR}/${PN}-${RE2_VER}/abseil-cpp/usr/$(get_libdir)/cmake/absl"
	)
	cmake_src_configure
}

python_compile() {
	cmake_src_compile
}

src_test() {
	local configuration=$(usex debug "Debug" "Release")
	ctest -C ${configuration} --output-on-failure -E 'dfa|exhaustive|random'
}

python_install() {
	cmake_src_install
}

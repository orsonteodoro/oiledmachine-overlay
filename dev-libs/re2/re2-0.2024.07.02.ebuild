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

inherit cmake-multilib distutils-r1 toolchain-funcs

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
IUSE="-debug icu python test"
RDEPEND="
	python? (
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
	)
	icu? (
		dev-libs/icu:0=[${MULTILIB_USEDEP}]
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
	python? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
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
	multilib_copy_sources

	prepare_multilib_abseil() {
		mkdir -p "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
	}
	multilib_foreach_abi prepare_multilib_abseil

	if use python ; then
		python_copy_sources
	fi
}

build_multilib_abseil() {
	pushd "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
		mkdir -p build || die
		cd build || die
		append-flags -fPIC
		cmake \
			-DCMAKE_INSTALL_PREFIX="/" \
			"${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}" \
			|| die
		emake
		DESTDIR="${WORKDIR}/${PN}-${RE2_VER}_build-${MULTILIB_ABI_FLAG}.${ABI}/abseil-cpp" emake install
	popd || die
}

python_configure() {
	:
}

src_configure() {
	multilib_foreach_abi build_multilib_abseil
	configure_multilib_re2() {
		local mycmakeargs=(
			-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
			-DBUILD_SHARED_LIBS=ON
			-DRE2_BUILD_TESTING=$(usex debug)
			-DRE2_USE_ICU=$(usex icu)
			-Dabsl_DIR="${WORKDIR}/${PN}-${RE2_VER}_build-${MULTILIB_ABI_FLAG}.${ABI}/abseil-cpp/usr/$(get_libdir)/cmake/absl"
		)
		cmake_src_configure
	}
	multilib_foreach_abi configure_multilib_re2
	if use python ; then
		distutils-r1_src_configure
	fi
}

python_compile() {
	"${PYTHON}" -m build --wheel || die
}

src_compile() {
	cmake-multilib_src_compile
	if use python ; then
		distutils-r1_src_compile
	fi
}

python_test() {
	local dir=$(mktemp -d -p "${T}")
	cp "re2_test.py" "${dir}" || die
	cd "${dir}" || die
	"${PYTHON}" "re2_test.py" || die
}

test_abi() {
	pushd "${WORKDIR}/${PN}-${RE2_VER}_build-${MULTILIB_ABI_FLAG}.${ABI}" || die
		local configuration=$(usex debug "Debug" "Release")
		ctest -C ${configuration} --output-on-failure -E 'dfa|exhaustive|random' || die
	popd
}

src_test() {
	multilib_foreach_abi test_abi
	if use python ; then
		distutils-r1_src_test
	fi
}

src_install() {
	cmake-multilib_src_install
	if use python ; then
		distutils-r1_src_install
	fi
}

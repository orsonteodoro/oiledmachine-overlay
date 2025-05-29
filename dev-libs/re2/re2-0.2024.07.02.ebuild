# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump every month

RE2_VER="${PV#0.}"
RE2_VER="${RE2_VER//./-}"

# Different date format used upstream.
ABSEIL_CPP_PV="20240116.2"		# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L16
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
SONAME="11"				# https://github.com/google/re2/blob/2024-07-02/CMakeLists.txt#L33

inherit cflags-hardened cmake-multilib distutils-r1 toolchain-funcs

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/re2-${RE2_VER}"
SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_PV}.tar.gz -> abseil-cpp-${ABSEIL_CPP_PV}.tar.gz
https://github.com/google/re2/archive/${RE2_VER}.tar.gz
	-> re2-${RE2_VER}.tar.gz
"

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
LICENSE="BSD"
SLOT="0/${SONAME}"
IUSE="
-debug icu python test
ebuild_revision_11
"
RDEPEND="
	>=dev-cpp/abseil-cpp-20240116.2:0/20240116
	icu? (
		dev-libs/icu:0[${MULTILIB_USEDEP}]
		dev-libs/icu:=
	)
	python? (
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
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
	pushd "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}_build-${MULTILIB_ABI_FLAG}.${ABI}"  >/dev/null 2>&1 || die
		mkdir -p build || die
		cd build || die
		append-flags -fPIC
		cmake \
			-DCMAKE_INSTALL_PREFIX="/" \
			"${WORKDIR}/abseil-cpp-${ABSEIL_CPP_PV}" \
			|| die
		emake
		DESTDIR="${WORKDIR}/${PN}-${RE2_VER}_build-${MULTILIB_ABI_FLAG}.${ABI}/abseil-cpp" emake install
	popd  >/dev/null 2>&1 || die
}

python_configure() {
	:
}

src_configure() {
	multilib_foreach_abi build_multilib_abseil
	configure_multilib_re2() {
		cflags-hardened_append
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
	pushd "${WORKDIR}/${PN}-${RE2_VER}/python" >/dev/null 2>&1 || die
		"${PYTHON}" -m build --wheel || die

		local pyver="${EPYTHON/python}"
		pyver="${pyver/.}"
		local wheel_path=$(realpath "dist/google_re2-"*"-cp${pyver}-cp${pyver}-linux_"*".whl")

		local d="${WORKDIR}/${PN}-${RE2_VER}_build-${EPYTHON/./_}/install"
einfo "Installing ${wheel_path}"
		distutils_wheel_install \
			"${d}" \
			"${wheel_path}"
	popd  >/dev/null 2>&1 || die
}

src_compile() {
	cmake-multilib_src_compile
	if use python ; then
		distutils-r1_src_compile
	fi
}

python_test() {
	local old_pythonpath="${PYTHONPATH}"
	export PYTHONPATH="${WORKDIR}/${PN}-${RE2_VER}_build-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages"
	pushd "${WORKDIR}/${PN}-${RE2_VER}/python" >/dev/null 2>&1 || die
		local dir=$(mktemp -d -p "${T}")
		cp "re2_test.py" "${dir}" || die
		cd "${dir}" || die
		"${PYTHON}" "re2_test.py" || die
	popd  >/dev/null 2>&1 || die
	export PYTHONPATH="${old_pythonpath}"
}

test_abi() {
	pushd "${WORKDIR}/${PN}-${RE2_VER}_build-${MULTILIB_ABI_FLAG}.${ABI}" >/dev/null 2>&1 || die
		local configuration=$(usex debug "Debug" "Release")
		ctest -C ${configuration} --output-on-failure -E 'dfa|exhaustive|random' || die
	popd  >/dev/null 2>&1 || die
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

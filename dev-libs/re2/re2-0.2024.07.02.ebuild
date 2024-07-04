# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bazel needed to avoid multiple abseil-cpp subslots.

# Bump every month

# Different date format used upstream.
ABSEIL_CPP_PV="20240116.2"						# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L16
ABSEIL_PY_PV="2.1.0"							# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L29
APPLE_SUPPORT_PV="1.15.1"						# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L14
BAZEL_PV="7.2.1"							# Observed in CI
BENCHMARK_PV="1.8.4"							# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L27
GOOGLETEST_PV="1.14.0"							# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L28
JAVA_SLOT="21"
PYBIND11_BAZEL_PV="2.12.0"						# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L18
PYTHON_COMPAT=( "python3_"{10..12} )
RE2_VER="${PV#0.}"
RE2_VER="${RE2_VER//./-}"
RULES_CC_PV="0.0.9"							# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L15
RULES_PYTHON_PV="0.1.0"							# https://github.com/google/re2/blob/2024-07-02/MODULE.bazel#L17
SONAME="11" # https://github.com/google/re2/blob/2024-07-02/CMakeLists.txt#L33

inherit bazel distutils-r1 java-pkg-opt-2 toolchain-funcs

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
bazel_external_uris="
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_PV}.tar.gz -> abseil-cpp-${ABSEIL_CPP_PV}.tar.gz
https://github.com/abseil/abseil-py/archive/refs/tags/v${ABSEIL_PY_PV}.tar.gz -> abseil-py-v${ABSEIL_PY_PV}.tar.gz
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/releases/download/${RULES_CC_PV}/rules_cc-${RULES_CC_PV}.tar.gz
https://github.com/bazelbuild/rules_python/releases/download/${RULES_PYTHON_PV}/rules_python-${RULES_PYTHON_PV}.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/google/benchmark/archive/v${BENCHMARK_PV}.tar.gz -> google-benchmark-${BENCHMARK_PV}.tar.gz
https://github.com/google/googletest/archive/refs/tags/v${GOOGLETEST_PV}.tar.gz -> googletest-${GOOGLETEST_PV}.tar.gz
https://github.com/pybind/pybind11_bazel/archive/v${PYBIND11_BAZEL_PV}.tar.gz -> pybind11_bazel-${PYBIND11_BAZEL_PV}.tar.gz
"
SRC_URI="
	${bazel_external_uris}
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
	virtual/jre:${JAVA_SLOT}
	icu? (
		dev-libs/icu:0=
	)
"
DEPEND="
	${RDEPEND}
	virtual/jdk:${JAVA_SLOT}
"
BDEPEND="
	>=dev-build/bazel-${BAZEL_PV}:${BAZEL_PV%.*}
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
	java-pkg-opt-2_pkg_setup
	java-pkg_ensure-vm-version-eq "${JAVA_SLOT}"
}

src_unpack() {
	unpack ${A}
	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} is not installed"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	bazel_setup_bazelrc
	sed -i -e "/--nodistinct_host_configuration/d" "${T}/bazelrc" || die
	cat "${T}/bazelrc" >> "${S}/.bazelrc"
	"${EPYTHON}" "python/toolchains/generate.py" || die

	default
#	cmake_src_prepare
	python_copy_sources
}

python_configure() {
#	local mycmakeargs=(
#		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
#		-DBUILD_SHARED_LIBS=ON
#		-DRE2_BUILD_TESTING=$(usex debug)
#		-DRE2_USE_ICU=$(usex icu)
#	)
#	cmake_src_configure
	:
}

python_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	local compilation_mode=$(usex debug "dbg" "opt")
#	cmake_src_compile
	ebazel clean
	ebazel build \
		--extra_toolchains=//python/toolchains:all \
		--compilation_mode=${compilation_mode} -- \
		//:re2 \
		//python:re2
	ebazel shutdown
}

src_test() {
	local configuration=$(usex debug "Debug" "Release")
	ctest -C ${configuration} --output-on-failure -E 'dfa|exhaustive|random'
}

# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="standalone"
MY_PN="LIEF"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cmake edo distutils-r1 libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/lief-project/LIEF.git"
	FALLBACK_COMMIT="441bb4620bc7242a822b7cb4419c965d76119f6b" # Dec 10, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64 ~arm64-macos ~x64-macos"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/lief-project/LIEF/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Library to instrument executable formats"
HOMEPAGE="
	https://lief.re/
	https://lief-project.github.io/
	https://github.com/lief-project/LIEF
	https://pypi.org/project/lief
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc +examples +json +logging -python -rust -system-expected -system-frozen
-system-mbedtls -system-nanobind -system-nlohmann-json
-system-spdlog -system-utfcpp test
ebuild_revision_1
"
RDEPEND+="
	system-nanobind? (
		>=dev-python/nanobind-2.4.0[${PYTHON_USEDEP}]
	)
	system-expected? (
		>=dev-cpp/tl-expected-1.1.0
	)
	system-frozen? (
		>=dev-cpp/frozen-1.2.0
	)
	system-spdlog? (
		>=dev-libs/spdlog-1.14.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	system-mbedtls? (
		>=net-libs/mbedtls-3.6.1
	)
"
DEPEND+="
	${RDEPEND}
	system-nlohmann-json? (
		>=dev-cpp/nlohmann_json-3.11.2
	)
	system-utfcpp? (
		>=dev-libs/utfcpp-4.0.5
	)
"
BDEPEND+="
	>=dev-build/cmake-3.24
	python? (
		>=dev-python/build-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/pathspec-0.12.1[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.8.2[${PYTHON_USEDEP}]
		>=dev-python/scikit-build-core-0.9.8[${PYTHON_USEDEP}]
		>=dev-python/setuptools-70.2.0[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.43.0[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		app-text/doxygen
	)
"
DOCS=( "CHANGELOG" "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-0.16.0-libdir.patch"
)

pkg_setup() {
	python_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_prepare_all() {
	cmake_src_prepare
	distutils-r1_python_prepare_all
	eapply ${_PATCHES[@]}
}

src_prepare() {
	distutils-r1_src_prepare
}

python_configure() {
	local mycmakeargs=(
		-DLIEF_C_API=OFF
		-DLIEF_DOC=$(usex doc)
		-DLIEF_ENABLE_JSON=$(usex json)
		-DLIEF_EXAMPLES=$(usex examples)
		-DLIEF_EXTERNAL_SPDLOG=$(usex system-spdlog)
		-DLIEF_INSTALL_COMPILED_EXAMPLES=$(usex examples)
		-DLIEF_LOGGING=$(usex logging)
		-DLIEF_OPT_EXTERNAL_EXPECTED=$(usex system-expected)
		-DLIEF_OPT_EXTERNAL_SPAN=OFF
		-DLIEF_OPT_FROZEN_EXTERNAL=$(usex system-frozen)
		-DLIEF_OPT_MBEDTLS_EXTERNAL=$(usex system-mbedtls)
		-DLIEF_OPT_NANOBIND_EXTERNAL=$(usex system-nanobind)
		-DLIEF_OPT_NLOHMANN_JSON_EXTERNAL=$(usex system-nlohmann-json)
		-DLIEF_OPT_UTFCPP_EXTERNAL=$(usex system-utfcpp)
		-DLIEF_PYTHON_API=ON
		-DLIEF_RUST_API=OFF
		-DLIEF_TESTS=$(usex test)
	)
	cmake_src_configure
}

python_configure_all() {
	local mycmakeargs=(
		-DLIEF_C_API=ON
		-DLIEF_DOC=$(usex doc)
		-DLIEF_ENABLE_JSON=$(usex json)
		-DLIEF_EXAMPLES=$(usex examples)
		-DLIEF_EXTERNAL_SPDLOG=$(usex system-spdlog)
		-DLIEF_INSTALL_COMPILED_EXAMPLES=$(usex examples)
		-DLIEF_LOGGING=$(usex logging)
		-DLIEF_OPT_EXTERNAL_EXPECTED=$(usex system-expected)
		-DLIEF_OPT_EXTERNAL_SPAN=OFF
		-DLIEF_OPT_FROZEN_EXTERNAL=$(usex system-frozen)
		-DLIEF_OPT_MBEDTLS_EXTERNAL=$(usex system-mbedtls)
		-DLIEF_OPT_NANOBIND_EXTERNAL=$(usex system-nanobind)
		-DLIEF_OPT_NLOHMANN_JSON_EXTERNAL=$(usex system-nlohmann-json)
		-DLIEF_OPT_UTFCPP_EXTERNAL=$(usex system-utfcpp)
		-DLIEF_PYTHON_API=OFF
		-DLIEF_RUST_API=$(usex rust)
		-DLIEF_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_configure() {
	distutils-r1_src_configure
}

python_compile() {
	pushd "api/python" >/dev/null 2>&1 || die
		distutils-r1_python_compile
	popd >/dev/null 2>&1 || die
}

python_compile_all() {
	cmake_src_compile
}

src_compile() {
	distutils-r1_src_compile
}

python_install() {
	pushd "api/python" >/dev/null 2>&1 || die
		distutils-r1_python_install
	popd >/dev/null 2>&1 || die
}

python_install_all() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

src_install() {
	distutils-r1_src_install
}

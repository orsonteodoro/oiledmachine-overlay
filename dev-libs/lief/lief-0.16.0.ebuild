# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="LIEF"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cmake python-single-r1

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
"
RDEPEND+="
	system-nanobind? (
		$(python_gen_cond_dep '
			>=dev-python/nanobind-2.4.0[${PYTHON_USEDEP}]
		')
	)
	system-expected? (
		>=dev-cpp/tl-expected-1.1.0
	)
	system-frozen? (
		>=dev-cpp/frozen-1.2.0
	)
	system-spdlog? (
		>=dev-libs/spdlog-1.14.1
	)
	system-nlohmann-json? (
		>=dev-cpp/nlohmann_json-3.11.2
	)
	system-mbedtls? (
		>=net-libs/mbedtls-3.6.1
	)
	system-utfcpp? (
		>=dev-libs/utfcpp-4.0.5
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.24
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
		app-text/doxygen
	)
"
DOCS=( "CHANGELOG" "README.md" )

pkg_setup() {
	python-single-r1_pkg_setup
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

src_configure() {
	local mycmakeargs=(
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
		-DLIEF_PYTHON_API=$(usex python)
		-DLIEF_RUST_API=$(usex rust)
		-DLIEF_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

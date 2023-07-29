# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="A chess library for Python, with move generation and validation, \
PGN parsing and writing, Polyglot opening book reading, Gaviota tablebase \
probing, Syzygy tablebase probing, and UCI/XBoard engine communication"
HOMEPAGE="
	https://github.com/niklasf/python-chess
"
LICENSE="
	GPL-3+
	test? (
		BSD-2
		MIT
		ZLIB
	)
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc stockfish test"
REQUIRED_USE+="
	test? (
		stockfish
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-jquery[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		games-board/crafty
		games-board/stockfish
	)
"
PDEPEND+="
	stockfish? (
		games-board/stockfish
	)
"
GAVIOTA_TABLEBASES_COMMIT="981472cc83e3a8b6e996191e564295609ea4ce30"
SRC_URI="
https://github.com/niklasf/python-chess/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	test? (
https://github.com/michiguel/Gaviota-Tablebases/archive/${GAVIOTA_TABLEBASES_COMMIT}.tar.gz
	-> Gaviota-Tablebases-${GAVIOTA_TABLEBASES_COMMIT:0:7}.tar.gz
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG-OLD.rst CHANGELOG.rst README.rst )

distutils_enable_sphinx "docs"

build_libgtb() {
	pushd "${WORKDIR}/Gaviota-Tablebases-${GAVIOTA_TABLEBASES_COMMIT}" || die
		emake
	popd
	export LD_LIBRARY_PATH="${WORKDIR}/Gaviota-Tablebases-${GAVIOTA_TABLEBASES_COMMIT}:${LD_LIBRARY_PATH}"
}

src_compile() {
	use test && build_libgtb
	distutils-r1_src_compile
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		tox || die
	}
	python_foreach_impl run_test
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE.txt
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

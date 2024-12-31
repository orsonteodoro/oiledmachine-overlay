# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
SMMAP_COMMIT="256c5a21de2d14aca02c9689d7d63f78c4e0ef61" # Sep 17, 2023

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/gitpython-developers/gitdb/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/gitpython-developers/smmap/archive/${SMMAP_COMMIT}.tar.gz
	-> smmap-${SMMAP_COMMIT:0:7}.tar.gz
"

DESCRIPTION="IO of git-style object databases"
HOMEPAGE="
http://gitdb.readthedocs.org/
https://github.com/gitpython-developers/gitdb
"
LICENSE="
	BSD
	test? (
		GPL-2
	)
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
	(
		>=dev-python/smmap-3.0.1[${PYTHON_USEDEP}]
		<dev-python/smmap-6[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-4.3.2[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-7.4.2[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

distutils_enable_sphinx "doc"

src_unpack() {
	unpack ${A}
	rm -rf "gitdb/ext/smmap" || die
	ln -s \
		"${WORKDIR}/smmap-${SMMAP_COMMIT}" \
		"${S}/gitdb/ext/smmap" \
		|| die
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc \
		"AUTHORS" \
		"LICENSE"
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		# ulimit -n 48 || die
		# ulimit -n || die
		pytest -v || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# Another ebuild exists, but this is an independent creation.

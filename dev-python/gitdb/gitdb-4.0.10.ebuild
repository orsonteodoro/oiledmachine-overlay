# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

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
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
DEPEND+="
	(
		<dev-python/smmap-6[${PYTHON_USEDEP}]
		>=dev-python/smmap-3.0.1[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
SMMAP_COMMIT="334ef84a05c953ed5dbec7b9c6d4310879eeab5a"
SRC_URI="
https://github.com/gitpython-developers/gitdb/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/gitpython-developers/smmap/archive/${SMMAP_COMMIT}.tar.gz
	-> smmap-${SMMAP_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( README.rst )

distutils_enable_sphinx "doc"

src_unpack() {
	unpack ${A}
	rm -rf gitdb/ext/smmap || die
	ln -s \
		"${WORKDIR}/smmap-${SMMAP_COMMIT}" \
		"${S}/gitdb/ext/smmap" \
		|| die
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
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

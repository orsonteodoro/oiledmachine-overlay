# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=no # Must be no to avoid circular dependency
PYTHON_COMPAT=( "python3_"{10..14} "pypy3_11" )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/gentoo/gpep517.git"
	FALLBACK_COMMIT="ace02abe8d637e65ee721c74a65608f11d902f6b" # May 2, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/gentoo/gpep517/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Python package builder and installer for non-pip-centric world"
HOMEPAGE="
	https://github.com/gentoo/gpep517
	https://pypi.org/project/gpep517
"
LICENSE="
	GPL-2+
"
RESTRICT="mirror"
SLOT="0"
IUSE+="
test test-full
ebuild_revision_1
"
# Prevent circular deps by not adding flit-core to *DEPENDs
RDEPEND="
	>=dev-python/installer-0.5[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]
	' python3_10)
"
DEPEND="
	${RDEPEND}
"
DISABLED_BDEPEND="
	>=dev-python/flit-core-3.2[${PYTHON_USEDEP}]
	<dev-python/flit-core-4[${PYTHON_USEDEP}]
	test-full? (
		dev-python/flit_core[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	test-full? (
		dev-python/hatchling[${PYTHON_USEDEP}]
		dev-python/pdm-pep517[${PYTHON_USEDEP}]
		dev-python/poetry-core[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

EPYTEST_PLUGINS=()
distutils_enable_tests "pytest"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_test() {
	epytest -o tmp_path_retention_policy=all
}

python_install() {
	python_domodule gpep517
	python_newscript - gpep517 <<-EOF
		#!${EPREFIX}/usr/bin/python
		import sys
		from gpep517.__main__ import main
		sys.exit(main())
	EOF
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "COPYING"
}

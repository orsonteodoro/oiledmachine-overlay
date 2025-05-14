# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11,12} ) # U24 uses 3.12

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${PN^}-${PV}"
SRC_URI="
https://github.com/Edinburgh-Genome-Foundry/Proglog/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Logs and progress bars manager for Python"
HOMEPAGE="
https://github.com/Edinburgh-Genome-Foundry/Proglog
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
REQUIRED_USE+="
"
RDEPEND+="
	dev-python/tqdm[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} -m pytest --cov proglog --cov-report term-missing || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  moviepy
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED

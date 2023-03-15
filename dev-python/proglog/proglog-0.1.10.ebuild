# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} ) # Upstream tested up to 3.9
inherit distutils-r1

DESCRIPTION="Logs and progress bars manager for Python"
HOMEPAGE="
https://github.com/Edinburgh-Genome-Foundry/Proglog
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
REQUIRED_USE+="
"
DEPEND+="
	dev-python/tqdm[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/Edinburgh-Genome-Foundry/Proglog/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN^}-${PV}"
RESTRICT="mirror"

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} -m pytest --cov proglog --cov-report term-missing || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-REVDEP:  moviepy

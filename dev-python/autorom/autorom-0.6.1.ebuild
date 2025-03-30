# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( "python3_10" ) # Upstream tested up to 3.10

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/AutoROM-${PV}/packages/AutoROM"
SRC_URI="
https://github.com/Farama-Foundation/AutoROM/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A tool to automate installing Atari ROMs for the Arcade Learning \
Environment"
HOMEPAGE="
https://github.com/Farama-Foundation/AutoROM
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" accept-rom-license test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/Farama-Notifications[${PYTHON_USEDEP}]
		test? (
			dev-python/multi-agent-ale-py[${PYTHON_USEDEP}]
		)
	')
	test? (
		dev-python/ale-py[${PYTHON_SINGLE_USEDEP}]
	)
"
PDEPEND+="
	accept-rom-license? (
		>=dev-python/autorom-accept-rom-license-${PV}:${SLOT}[${PYTHON_SINGLE_USEDEP}]
	)
"

python_install_all() {
	distutils-r1_python_install_all
	rm -rf $(find "${ED}" -name "__pycache__")
	cd "${WORKDIR}/AutoROM-${PV}" || die
	dodoc "LICENSE.txt"
	dodoc "README.md"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

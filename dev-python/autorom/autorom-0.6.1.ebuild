# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 ) # Upstream tested up to 3.10

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
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
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/Farama-Notifications[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/ale-py[${PYTHON_USEDEP}]
		dev-python/multi-agent-ale-py[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	accept-rom-license? (
		>=dev-python/autorom-accept-rom-license-${PV}:${SLOT}
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

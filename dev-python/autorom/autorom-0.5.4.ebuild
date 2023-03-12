# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} ) # Upstream tested up to 3.9
inherit distutils-r1

DESCRIPTION="A tool to automate installing Atari ROMs for the Arcade Learning \
Environment"
HOMEPAGE="
https://github.com/Farama-Foundation/AutoROM
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	$(python_gen_any_dep 'net-libs/libtorrent-rasterbar[${PYTHON_SINGLE_USEDEP},python]')
	${PYTHON_DEPS}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/importlib_resources
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
SRC_URI="
https://github.com/Farama-Foundation/AutoROM/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/AutoROM-${PV}"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

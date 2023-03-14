# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A Python interface for reinforcement learning environments"
HOMEPAGE="https://github.com/deepmind/dm_env"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	>=dev-python/absl-py-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/dm-tree-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.4[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	test? (
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/deepmind/dm_env/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md docs/index.md README.md )

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

distutils_enable_tests "nose"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Reinforcement Learning / AI Bots in Card (Poker) Games - Blackjack, Leduc, Texas, DouDizhu, Mahjong, UNO."
HOMEPAGE="
	http://www.rlcard.org/
	https://github.com/datamllab/rlcard
"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" docs test torch"
REQUIRED_USE="
	test? (
		torch
	)
"
DEPEND+="
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
	torch? (
		dev-python/gitdb2[${PYTHON_USEDEP}]
		dev-python/GitPython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		sci-libs/pytorch[${PYTHON_USEDEP}]
	)
"
RDEPEND+="
	${DEPEND}
"
SRC_URI="
https://github.com/datamllab/rlcard/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( README.md )

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE.md
	docinto docs
	dodoc -r docs/*
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		py.test tests/ --cov=rlcard || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

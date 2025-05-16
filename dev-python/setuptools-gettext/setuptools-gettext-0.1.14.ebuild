# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..12} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/breezy-team/setuptools-gettext/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A setuptools plugin for building multilingual MO files"
HOMEPAGE="https://github.com/breezy-team/setuptools-gettext"
LICENSE="
	GPL-2+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
# U 22.04
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-61.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mypy-0.942[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/types-setuptools[${PYTHON_USEDEP}]
		dev-util/ruff
	)
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned

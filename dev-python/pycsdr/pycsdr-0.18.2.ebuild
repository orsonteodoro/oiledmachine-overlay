# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

SRC_URI="
https://github.com/jketterl/pycsdr/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"

DESCRIPTION="Python bindings for the csdr library"
HOMEPAGE="https://github.com/jketterl/pycsdr"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	>=media-radio/csdr-${PV}
"
DEPEND+="
	${RDEPEND}
"
RESTRICT="mirror"
DOCS=( LICENSE README.md )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

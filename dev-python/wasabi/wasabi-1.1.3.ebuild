# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO packages:
# types-colorama


DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/wasabi/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Create, fill a temporary directory"
HOMEPAGE="
	https://github.com/explosion/wasabi
	https://pypi.org/project/wasabi
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		dev-python/pytest
		dev-python/mypy
		dev-python/types-colorama
		dev-python/nbconvert
		dev-python/ipykernel
	)
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

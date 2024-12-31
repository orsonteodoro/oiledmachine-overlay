# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

MY_PN="${PN,,}"

DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( "python3_"{8..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"

DESCRIPTION="Python library for fast approximate string matching using Jaro and \
Jaro-Winkler similarity"
LICENSE="MIT"
HOMEPAGE="https://github.com/maxbachmann/JaroWinkler"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-python/RapidFuzz-3.5.2[${PYTHON_USEDEP}]
		<dev-python/RapidFuzz-4.0.0[${PYTHON_USEDEP}]
	)
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

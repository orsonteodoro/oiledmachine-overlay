# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Microsoft Authentication Extensions for Python"
HOMEPAGE="
	https://pypi.org/project/msal-extensions
"
LICENSE="
	all-rights-reserved
	MIT
"
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror"
RESTRICT="test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" portalocker test"
RDEPEND+="
	(
		>=dev-python/msal-1.29[${PYTHON_USEDEP}]
		<dev-python/msal-2[${PYTHON_USEDEP}]
	)
	portalocker? (
		>=dev-python/portalocker-1.4[${PYTHON_USEDEP}]
		<dev-python/portalocker-4[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD

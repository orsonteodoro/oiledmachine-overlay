# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
https://files.pythonhosted.org/packages/py3/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}-py3-none-any.whl
"

DESCRIPTION="What-If Tool TensorBoard plugin"
HOMEPAGE="
https://github.com/PAIR-code/what-if-tool/tree/master/tensorboard_plugin_wit
https://pypi.org/project/tensorboard-plugin-wit/
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"

python_compile() {
	distutils_wheel_install \
		"${BUILD_DIR}/install" \
		"${DISTDIR}/${MY_PN}-${PV}-py3-none-any.whl"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

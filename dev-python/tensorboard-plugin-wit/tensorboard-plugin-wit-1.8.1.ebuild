# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/_}"

DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="What-If Tool TensorBoard plugin"
HOMEPAGE="
https://github.com/PAIR-code/what-if-tool/tree/master/tensorboard_plugin_wit
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
SRC_URI="
https://files.pythonhosted.org/packages/py3/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}-py3-none-any.whl
"
S="${WORKDIR}"
RESTRICT="mirror"

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/${MY_PN}-${PV}-py3-none-any.whl"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

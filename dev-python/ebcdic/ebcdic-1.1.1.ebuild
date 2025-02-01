# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
https://files.pythonhosted.org/packages/0d/2f/633031205333bee5f9f93761af8268746aa75f38754823aabb8570eb245b/ebcdic-1.1.1-py2.py3-none-any.whl
"

DESCRIPTION="Additional EBCDIC codecs"
HOMEPAGE="
	https://pypi.org/project/ebcdic
"
LICENSE="
	BSD
	BSD-2
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

src_unpack() {
	:
}

src_compile() {
	install_impl() {
		local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
		local wheel_path=$(realpath "${DISTDIR}/ebcdic-1.1.1-py2.py3-none-any.whl")
		distutils_wheel_install "${d}" \
			"${wheel_path}"
	}
	python_foreach_impl install_impl
}

src_install() {
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

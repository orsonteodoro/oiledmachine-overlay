# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/_}"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
	amd64? (
https://files.pythonhosted.org/packages/89/bc/135d2c5a345f1c52431dbc92c181003ba61bcd35e304d36387e33070a9c5/typecode_libmagic-5.39.210531-py3-none-manylinux1_x86_64.whl
	)
"

DESCRIPTION="A ScanCode path provider plugin to provide a prebuilt native libmagic binary and database"
HOMEPAGE="
	https://github.com/nexB/scancode-plugins
	https://pypi.org/project/typecode-libmagic
"
LICENSE="
	Apache-2.0
	BSD
	BSD-2
	ISC
	GPL-1.0+
	MIT
	public-domain
	ZLIB
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	sys-libs/glibc
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

src_unpack() {
	mkdir -p "${S}" || die
}

python_compile() {
einfo "EPYTHON:  ${EPYTHON}"
	local wheel_path
	local d="${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install"
	mkdir -p "${d}" || die
	if [[ "${ARCH}" == "amd64" && "${ELIBC}" == "glibc" ]] ; then
		wheel_path=$(realpath "${DISTDIR}/${MY_PN}-${PV}-py3-none-manylinux1_x86_64.whl")
	else
		die "ARCH=${ARCH} ELIBC=${ELIBC} is not supported"
	fi
	distutils_wheel_install "${d}" \
		"${wheel_path}"
}

src_install() {
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

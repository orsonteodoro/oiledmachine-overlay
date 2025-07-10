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
SRC_URI="
	amd64? (
https://files.pythonhosted.org/packages/56/6e/8695d5773679fd05bd1c4e56a7b9ab3d5dc3c89aadfa9c1981a00fc66935/extractcode_libarchive-3.5.1.210531-py3-none-manylinux1_x86_64.whl
	)
"

DESCRIPTION="A ScanCode path provider plugin to provide a prebuilt native libarchive binary"
HOMEPAGE="
	https://github.com/nexB/scancode-plugins
	https://pypi.org/project/extractcode-libarchive
"
LICENSE="
	(
		BSD
		GPL-2
	)
	Apache-2.0
	BSD
	BSD-2
	BZIP2
	CC0-1.0
	MIT
	ZLIB
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev"
RDEPEND+="
	sys-devel/gcc[openmp]
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

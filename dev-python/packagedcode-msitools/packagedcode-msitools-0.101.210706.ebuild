# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
	arm64? (
https://files.pythonhosted.org/packages/04/c8/93f3344963765623763a899714a7d849491f5824fe2d939030f0437ef48a/packagedcode_msitools-0.101.210706-py3-none-manylinux2014_aarch64.whl
	)
	amd64? (
https://files.pythonhosted.org/packages/6f/c9/bb5ba90a3eee6706b0ac8b983d081bf03cc6d8545cead72005b38d3cd8db/packagedcode_msitools-0.101.210706-py3-none-manylinux1_x86_64.whl
	)
"

DESCRIPTION="A ScanCode path provider plugin to provide prebuilt binaries from msitools"
HOMEPAGE="
	https://github.com/nexB/scancode-plugins
	https://pypi.org/project/packagedcode-msitools
"
LICENSE="
	Apache-2.0
	GPL-2.0+
	LGPL-2.1+
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "

# From inspecting README.rst
README_RDEPEND="
	dev-libs/glib:2
	dev-lang/perl
	dev-lang/vala
	dev-libs/gobject-introspection
	dev-libs/libxml2
	gnome-extra/libgsf
	sys-devel/bison
"

# From inspecting lld
LDD_RDEPEND="
	app-arch/msitools
	dev-libs/glib:2
	dev-libs/libffi
	dev-libs/libpcre2
	sys-apps/util-linux
	sys-libs/glibc
	sys-libs/zlib
"

RDEPEND+="
	${README_RDEPEND}
	${LDD_RDEPEND}
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
		wheel_path=$(realpath "${DISTDIR}/${PN/-/_}-${PV}-py3-none-manylinux1_x86_64.whl")
	elif [[ "${ARCH}" == "arm64" && "${ELIBC}" == "glibc" ]] ; then
		wheel_path=$(realpath "${DISTDIR}/${PN/-/_}-${PV}-py3-none-manylinux2014_aarch64.whl")
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

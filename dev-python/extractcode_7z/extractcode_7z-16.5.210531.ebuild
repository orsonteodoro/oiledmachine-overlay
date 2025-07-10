# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/nexB/scancode-plugins.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://files.pythonhosted.org/packages/5a/9e/c27db5aaeb9edaf50727f9b498d57e1c3adaea79ea16b20391a3dceca928/extractcode_7z-16.5.210531-py3-none-manylinux1_x86_64.whl
	"
fi

DESCRIPTION="A ScanCode path provider plugin to provide a prebuilt native sevenzip binary"
HOMEPAGE="
	https://github.com/nexB/scancode-plugins
	https://pypi.org/project/extractcode-7z
"
LICENSE="
	Apache-2.0
	Brian-Gladman-3-Clause
	LGPL-2.1
	unRAR
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	sys-devel/gcc
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
		wheel_path=$(realpath "${DISTDIR}/${PN}-${PV}-py3-none-manylinux1_x86_64.whl")
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

# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_util_http"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.27.0"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="Web util for OpenTelemetry"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/util/opentelemetry-util-http
	https://pypi.org/project/opentelemetry-util-http
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/${OPENTELEMETRY_PV}"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.rst" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

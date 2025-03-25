# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_proto"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_SLOTS=(
	"3.21"
	"4.23"
	"4.24"
	"4.25"
)
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="OpenTelemetry Python Proto"
HOMEPAGE="
	https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-proto
	https://pypi.org/project/opentelemetry-proto
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/${PV}"
IUSE+=" dev"
gen_protobuf_rdepend() {
	local s
	for s in ${PROTOBUF_SLOTS[@]} ; do
		echo "
			dev-python/protobuf:0/${s}
		"
	done
}
RDEPEND+="
	|| (
		$(gen_protobuf_rdepend)
	)
	dev-python/protobuf:=
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
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

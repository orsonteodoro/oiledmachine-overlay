# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="no"
GRPC_SLOT="5"
PROTOBUF_PYTHON_SLOT="5"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..12} ) # Same as opensearch-py

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://files.pythonhosted.org/packages/34/42/1defb953c296aa8eee86ea86e311bd985a004ada39b309e3f162cf8593a1/opensearch_protobufs-${PV}-py3-none-any.whl
"

DESCRIPTION="OpenSearch Protobufs / Generated Code on the client ↔️ server GRPC APIs"
HOMEPAGE="
	https://github.com/opensearch-project/opensearch-protobufs
	https://pypi.org/project/opensearch-protobufs
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" "
RDEPEND+="
	>=dev-python/protobuf-3.25.8:${PROTOBUF_PYTHON_SLOT}
	>=dev-python/grpcio-1.70.0:${GRPC_SLOT}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die
}

python_compile() {
	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	local wheel_path="${DISTDIR}/opensearch_protobufs-${PV}-py3-none-any.whl"
	local d="${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install" # Based on ${S}
	distutils_wheel_install "${d}" \
		"${wheel_path}"

	find "${d}" -name "*.pyc" -delete || die
}

src_install() {
	distutils-r1_src_install

	change_prefix() {
		local old_prefix="/usr/lib/${EPYTHON}/site-packages"
		local new_prefix="/usr/lib/protobuf-python/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}/site-packages"
		dodir $(dirname "${new_prefix}")
		mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
		python_optimize "${ED}/usr/lib/protobuf-python/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}/site-packages"
	}

        python_foreach_impl change_prefix
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

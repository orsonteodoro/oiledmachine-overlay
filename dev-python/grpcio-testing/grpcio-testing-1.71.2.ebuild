# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut 1-3 "${PV}")

DISTUTILS_USE_PEP517="setuptools"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
GRPC_SLOT="5"
PROTOBUF_CPP_SLOT="5"
PROTOBUF_PYTHON_SLOT="5"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
S="${WORKDIR}/${GRPC_P}/src/python/grpcio_testing"
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
"

DESCRIPTION="Testing utilities for gRPC Python"
HOMEPAGE="
	https://grpc.io
	https://github.com/grpc/grpc/tree/master/src/python/grpcio_testing
"
LICENSE="Apache-2.0"
SLOT="${GRPC_SLOT}/"$(ver_cut "1-2" "${PV}")
IUSE="
ebuild_revision_2
"
RDEPEND="
	~dev-python/grpcio-${PV}:${GRPC_SLOT}[${PYTHON_USEDEP}]
	dev-python/grpcio:=
	dev-python/protobuf:${PROTOBUF_PYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/protobuf:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

python_configure() {
	export PATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/bin/grpc/${GRPC_SLOT}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/grpc/${GRPC_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
}

src_install() {
	distutils-r1_src_install

	change_prefix() {
	# Change of base /usr -> /usr/lib/grpc/${GRPC_SLOT}
		local old_prefix="/usr/lib/${EPYTHON}"
		local new_prefix="/usr/lib/grpc/${GRPC_SLOT}/lib/${EPYTHON}"
		dodir $(dirname "${new_prefix}")
		mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
	}

	python_foreach_impl change_prefix
}

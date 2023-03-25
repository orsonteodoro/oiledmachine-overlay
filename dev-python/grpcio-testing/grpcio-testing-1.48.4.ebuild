# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Testing utilities for gRPC Python"
HOMEPAGE="https://grpc.io"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
RDEPEND="
	(
		<dev-python/protobuf-python-4[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.5.0_p1[${PYTHON_USEDEP}]
	)
	~dev-python/grpcio-${PV}[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
MY_PV=$(ver_cut 1-3 "${PV}")
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
"
S="${WORKDIR}/${GRPC_P}/src/python/grpcio_testing"

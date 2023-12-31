# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 multiprocessing prefix

GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
MY_PV=$(ver_cut 1-3 "${PV}")
PROTOBUF_PV="21.6"
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_PV}.tar.gz
	-> protobuf-${PROTOBUF_PV}.tar.gz
"
S="${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools"

DESCRIPTION="Protobuf code generator for gRPC"
HOMEPAGE="https://grpc.io"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
PROTOBUF_SLOT="0/3.21"
# See https://github.com/grpc/grpc/blob/v1.52.2/bazel/grpc_python_deps.bzl#L45
# See https://github.com/grpc/grpc/tree/v1.52.2/third_party
RDEPEND="
	>=dev-python/cython-0.29.26:0[${PYTHON_USEDEP}]
	dev-python/protobuf-python:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	~dev-python/grpcio-${PV}[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

src_unpack() {
	unpack ${A}
	rm -rf "${WORKDIR}/${GRPC_P}/third_party/protobuf" || die
	mv "${WORKDIR}/protobuf-${PROTOBUF_PV}" \
		"${WORKDIR}/${GRPC_P}/third_party/protobuf" || die
	mkdir -p "${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools/third_party" || die
	ln -s "${WORKDIR}/${GRPC_P}/third_party/protobuf" \
		"${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools/third_party/protobuf" || die
	ln -s "${WORKDIR}/${GRPC_P}" \
		"${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools/grpc_root" || die
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	hprefixify setup.py
}

python_configure_all() {
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
}

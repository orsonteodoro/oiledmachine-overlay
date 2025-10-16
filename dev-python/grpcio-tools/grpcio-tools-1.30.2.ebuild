# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
MY_PV=$(ver_cut 1-3 "${PV}")
PROTOBUF_PV="3.12.2"
PROTOBUF_SLOT="0/3.12"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 multiprocessing prefix

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
S="${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools"
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_PV}.tar.gz
	-> protobuf-${PROTOBUF_PV}.tar.gz
"

DESCRIPTION="Protobuf code generator for gRPC"
HOMEPAGE="https://grpc.io"
LICENSE="Apache-2.0"
SLOT="0"
IUSE+=" ebuild_revision_1"
# See https://github.com/grpc/grpc/blob/v1.30.2/bazel/grpc_python_deps.bzl#L45
# See https://github.com/grpc/grpc/tree/v1.30.2/third_party
RDEPEND="
	>=dev-python/cython-0.29.8:0.29[${PYTHON_USEDEP}]
	dev-python/protobuf:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	dev-python/protobuf:=
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

check_cython() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local actual_cython_major=$(ver_cut 1-2 "${actual_cython_pv}")
	local expected_cython_slot="0.29"
	if ver_test "${actual_cython_slot}" -ne "${expected_cython_slot}" ; then
eerror
eerror "Do \`eselect cython set ${expected_cython_slot}\` to continue."
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_slot}"
eerror
		die
	fi
}

python_configure_all() {
	check_cython
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
}

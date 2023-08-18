# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 multiprocessing prefix

DESCRIPTION="High-performance RPC framework (python libraries)"
HOMEPAGE="https://grpc.io"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE+=" doc r1"
# See src/include/openssl/crypto.h#L99 for versioning
# See src/include/openssl/base.h#L187 for versioning
# See https://github.com/grpc/grpc/blob/v1.49.3/bazel/grpc_python_deps.bzl#L45
# See https://github.com/grpc/grpc/tree/v1.49.3/third_party
PROTOBUF_SLOT="0/32"
RDEPEND+="
	>=dev-cpp/abseil-cpp-20220623.0:0/20220623[cxx17(+)]
	>=dev-libs/openssl-1.1.1g:0=[-bindist(-)]
	>=dev-libs/re2-0.2021.09.01:=
	>=dev-python/six-1.16[${PYTHON_USEDEP}]
	>=net-dns/c-ares-1.17.2:=
	>=sys-libs/zlib-1.2.13:=
	dev-python/protobuf-python:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
# TODO: doc: requirements.bazel.txt
BDEPEND+="
	>=dev-python/coverage-4[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.26[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.29[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/six-1.10[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.8.1[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
	)
"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
MY_PV=$(ver_cut 1-3 ${PV})
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
"
S="${WORKDIR}/${GRPC_P}"
PATCHES=(
	"${FILESDIR}/grpcio-1.49.2-cc-flag-test-fix.patch"
)

python_prepare_all() {
	sed -i -e "s|-std=c++14|-std=c++17|g" setup.py || die
	distutils-r1_python_prepare_all
	hprefixify setup.py
}

check_cython() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local expected_cython_pv="<3.0"
	local required_cython_major=$(ver_cut 1 ${expected_cython_pv})
	if ver_test ${actual_cython_pv} -ge 3.0 ; then
eerror
eerror "Switch cython to ${expected_cython_pv} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_pv}"
eerror
		die
	fi
}

python_configure_all() {
	check_cython
	# os.environ.get('GRPC_BUILD_WITH_BORING_SSL_ASM', True)
	export GRPC_BUILD_WITH_BORING_SSL_ASM=
	export GRPC_PYTHON_DISABLE_LIBC_COMPATIBILITY=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
	export GRPC_PYTHON_BUILD_SYSTEM_ABSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_RE2=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_WITH_SYSTEM_RE2=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_ENABLE_DOCUMENTATION_BUILD=$(usex doc "1" "0")
}

distutils_enable_sphinx "doc/python/sphinx"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 multiprocessing prefix

DESCRIPTION="High-performance RPC framework (python libraries)"
HOMEPAGE="https://grpc.io"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE+=" doc"
RDEPEND="
	<dev-python/protobuf-python-5[${PYTHON_USEDEP}]
	>=dev-libs/openssl-1.1.1g:0=[-bindist(-)]
	>=dev-libs/re2-0.2022.04.01:=
	>=dev-python/cython-0.29.8[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-4.21.3[${PYTHON_USEDEP}]
	>=net-dns/c-ares-1.17.2:=
	>=sys-libs/zlib-1.2.13:=
"
DEPEND="${RDEPEND}"
BDEPEND+="
	>=dev-python/coverage-4[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.29[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.8.1[${PYTHON_USEDEP}]
	)
"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
"
S="${WORKDIR}/${GRPC_P}"
PATCHES=(
	"${FILESDIR}/1.51.0-respect-cc.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	hprefixify setup.py
}

python_configure_all() {
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
}

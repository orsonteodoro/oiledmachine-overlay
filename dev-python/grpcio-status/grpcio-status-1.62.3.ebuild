# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="grpc-${PV}"

DISTUTILS_USE_PEP517="setuptools"
PROTOBUF_CPP_SLOT="4"
PROTOBUF_PYTHON_SLOT="4"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_P}/src/python/grpcio_status"
SRC_URI="
https://github.com/grpc/grpc/archive/v${PV}.tar.gz
	-> ${MY_P}.gh.tar.gz
"

DESCRIPTION="Reference package for GRPC Python status proto mapping"
HOMEPAGE="
	https://grpc.io/
	https://github.com/grpc/grpc/tree/master/src/python/grpcio_status
	https://pypi.org/project/grpcio-status/
"
LICENSE="Apache-2.0"
SLOT="${PROTOBUF_CPP_SLOT}"
RDEPEND="
	~dev-python/grpcio-${PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/grpcio:=
	>=dev-python/googleapis-common-protos-1.5.5[${PYTHON_USEDEP}]
	dev-python/protobuf:${PROTOBUF_PYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/protobuf:=
"
BDEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

python_configure() {
	export PATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cd "${WORKDIR}/${MY_P}/src/python/grpcio_tests" || die
	epytest "tests"{"","_aio"}"/status"
}

src_install() {
	distutils-r1_src_install

	change_prefix() {
	# Change of base /usr -> /usr/lib/grpc/${PROTOBUF_CPP_SLOT}
		local old_prefix="/usr/lib/${EPYTHON}"
		local new_prefix="/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}"
		dodir $(dirname "${new_prefix}")
		mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
	}

	python_foreach_impl change_prefix
}

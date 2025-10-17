# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="grpc-${PV}"

DISTUTILS_USE_PEP517="setuptools"
PROTOBUF_SLOT="0/4.21"
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
SLOT="0"
RDEPEND="
	~dev-python/grpcio-${PV}[${PYTHON_USEDEP}]
	>=dev-python/googleapis-common-protos-1.5.5[${PYTHON_USEDEP}]
	dev-python/protobuf:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	dev-python/protobuf:=
"
BDEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cd "${WORKDIR}/${MY_P}/src/python/grpcio_tests" || die
	epytest "tests"{"","_aio"}"/status"
}

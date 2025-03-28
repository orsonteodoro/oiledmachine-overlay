# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# CI:
# protobuf: 4.21.6
# grpc: 1.70.0

MY_P="python-api-core-${PV}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 grpc-ver protobuf-ver

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/googleapis/python-api-core/archive/v${PV}.tar.gz
	-> ${MY_P}.gh.tar.gz
"

DESCRIPTION="Core Library for Google Client Libraries"
HOMEPAGE="
	https://github.com/googleapis/python-api-core/
	https://pypi.org/project/google-api-core/
	https://googleapis.dev/python/google-api-core/latest/index.html
"
LICENSE="Apache-2.0"
SLOT="0/3.21" # 0/$PROTOBUF_SLOT
IUSE="async-rest grpc grpcgcp grpcio-gcp"
REQUIRED_USE="
	test? (
		grpc
	)
"
gen_grpcio_rdepend() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS[@]} ; do
		s2=$(grpc_get_protobuf_slot "${s1}")
		echo "
			(
				=dev-python/grpcio-${s1}*[${PYTHON_USEDEP}]
				=dev-python/grpcio-status-${s1}*[${PYTHON_USEDEP}]
				dev-python/protobuf:0/${s2}[${PYTHON_USEDEP}]
			)
		"
	done
}
gen_protobuf_rdepend() {
	local s
	for s in ${PROTOBUF_SLOTS[@]} ; do
		echo  "
			dev-python/protobuf:0/${s}[${PYTHON_USEDEP}]
		"
	done
}
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/proto-plus-1.22.3[${PYTHON_USEDEP}]
		<dev-python/proto-plus-2.0.0[${PYTHON_USEDEP}]
	' python3_{10,11,12})
	$(python_gen_cond_dep '
		>=dev-python/proto-plus-1.25.0[${PYTHON_USEDEP}]
		<dev-python/proto-plus-2.0.0[${PYTHON_USEDEP}]
	' python3_13)
	(
		>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
		<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/google-auth-1.25.0[${PYTHON_USEDEP}]
		<dev-python/google-auth-3.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/googleapis-common-protos-1.56.2[${PYTHON_USEDEP}]
		<dev-python/googleapis-common-protos-2.0.0[${PYTHON_USEDEP}]
	)
	(
		!=dev-python/protobuf-3.20.0
		!=dev-python/protobuf-3.20.1
		!=dev-python/protobuf-4.21.0
		!=dev-python/protobuf-4.21.1
		!=dev-python/protobuf-4.21.2
		!=dev-python/protobuf-4.21.3
		!=dev-python/protobuf-4.21.4
		!=dev-python/protobuf-4.21.5
		|| (
			$(gen_protobuf_rdepend)
		)
		dev-python/protobuf:=
	)
	async-rest? (
		(
			>=dev-python/google-auth-2.35.0[aiohttp]
			<dev-python/google-auth-3.0
		)
	)
	grpc? (
		|| (
			$(gen_grpcio_rdepend)
		)
		dev-python/grpcio:=
		dev-python/grpcio-status:=
		dev-python/protobuf:=
	)
	grpcgcp? (
		>=dev-python/grpcio-gcp-0.2.2[${PYTHON_USEDEP}]
		<dev-python/grpcio-gcp-1.0[${PYTHON_USEDEP}]
	)
	grpcio-gcp? (
		>=dev-python/grpcio-gcpgrpcio-gcp-0.2.2[${PYTHON_USEDEP}]
		<dev-python/grpcio-gcpgrpcio-gcp-1.0[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/rsa[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

EPYTEST_IGNORE=(
	# The grpc_gcp module is missing to perform a stress test
	"tests/unit/test_grpc_helpers.py"
)

python_test() {
	rm -rf google || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p "asyncio" "tests"
}

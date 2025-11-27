# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# TODO package:
# sphinx-docstring-typing
# types-cachetools
# types-certifi
# types-freezegun
# types-pyOpenSSL
# types-mock

# See also
# https://github.com/googleapis/google-auth-library-python/blob/v2.29.0/.kokoro/requirements.txt

DISTUTILS_USE_PEP517="setuptools"
EPYTEST_IGNORE=(
	# these are compatibility tests with oauth2client
	# disable them to unblock removal of that package
	"tests/test__oauth2client.py"
)
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{11..12} )

inherit abseil-cpp distutils-r1 grpc protobuf pypi re2

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DESCRIPTION="The Google Auth library simplifies server-to-server authentication to Google APIs"
HOMEPAGE="
	https://github.com/googleapis/google-auth-library-python/
	https://pypi.org/project/google-auth/
"
LICENSE="Apache-2.0"
RESTRICT="test" # Not tested
SLOT="0"
IUSE+="
aiohttp doc enterprise_cert pyopenssl reauth requests test
ebuild_revision_1
"
RDEPEND="
	!dev-python/namespace-google
	(
		>=dev-python/cachetools-2.0.0[${PYTHON_USEDEP}]
		<dev-python/cachetools-6.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/rsa-3.1.4[${PYTHON_USEDEP}]
		<dev-python/rsa-5[${PYTHON_USEDEP}]
	)
	>=dev-python/pyasn1-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.2.1[${PYTHON_USEDEP}]
	aiohttp? (
		(
			>=dev-python/aiohttp-3.6.2[${PYTHON_USEDEP}]
			<dev-python/aiohttp-4.0.0_pre[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
			<dev-python/requests-3.0.0_pre[${PYTHON_USEDEP}]
		)
	)
	enterprise_cert? (
		>=dev-python/cryptography-36.0.2[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-22.0.0[${PYTHON_USEDEP}]
	)
	pyopenssl? (
		>=dev-python/cryptography-38.0.3[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-20.0.0[${PYTHON_USEDEP}]
	)
	reauth? (
		>=dev-python/pyu2f-0.1.5[${PYTHON_USEDEP}]
	)
	requests? (
		>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
		<dev-python/requests-3.0.0_pre[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
gen_grpc_test_bdepend() {
	echo "
		(
			dev-python/grpcio:3/1.30[${PYTHON_USEDEP}]
			net-libs/grpc:3/1.30[${PYTHON_USEDEP},python]
		)
		(
			dev-python/grpcio:3/1.51[${PYTHON_USEDEP}]
			net-libs/grpc:3/1.51[${PYTHON_USEDEP},python]
		)
		(
			dev-python/grpcio:4/1.62[${PYTHON_USEDEP}]
			net-libs/grpc:4/1.62[${PYTHON_USEDEP},python]
		)
		(
			dev-python/grpcio:5/1.71[${PYTHON_USEDEP}]
			net-libs/grpc:5/1.71[${PYTHON_USEDEP},python]
		)
		(
			dev-python/grpcio:6/1.75[${PYTHON_USEDEP}]
			net-libs/grpc:6/1.75[${PYTHON_USEDEP},python]
		)
	"
}
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/requests-oauthlib[${PYTHON_USEDEP}]
		dev-python/sphinx-docstring-typing[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		test? (
			dev-python/recommonmark[${PYTHON_USEDEP}]
		)
	)
	test? (
		$(python_gen_cond_dep '
			>dev-python/urllib3-2.0.0[${PYTHON_USEDEP}]
		' python3_11)
		$(python_gen_cond_dep '
			>dev-python/urllib3-2.0.0[${PYTHON_USEDEP}]
		' python3_12)
		<dev-python/cryptography-39.0.0[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/oauth2client[${PYTHON_USEDEP}]
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aioresponses[${PYTHON_USEDEP}]
		dev-python/asynctest[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/pyu2f[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]

		|| (
			$(gen_grpc_test_bdepend)
		)
		dev-python/grpcio:=
		net-libs/grpc:=

		dev-python/black[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-import-order[${PYTHON_USEDEP}]
		dev-python/nox[${PYTHON_USEDEP}]
		dev-python/types-cachetools[${PYTHON_USEDEP}]
		dev-python/types-certifi[${PYTHON_USEDEP}]
		dev-python/types-freezegun[${PYTHON_USEDEP}]
		dev-python/types-pyOpenSSL[${PYTHON_USEDEP}]
		dev-python/types-requests[${PYTHON_USEDEP}]
		dev-python/types-setuptools[${PYTHON_USEDEP}]
		dev-python/types-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

python_configure() {
	if use test ; then
		if has_version "dev-libs/protobuf:3/3.12" ; then
			ABSEIL_CPP_SLOT="20200225"
			GRPC_SLOT="3"
			PROTOBUF_CPP_SLOT="3"
			PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_3[@]}" )
			RE2_SLOT="20220623"
		elif has_version "dev-libs/protobuf:3/3.21" ; then
			ABSEIL_CPP_SLOT="20220623"
			GRPC_SLOT="3"
			PROTOBUF_CPP_SLOT="3"
			PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
			RE2_SLOT="20220623"
		elif has_version "dev-libs/protobuf:4/4.25" ; then
			ABSEIL_CPP_SLOT="20240116"
			GRPC_SLOT="4"
			PROTOBUF_CPP_SLOT="4"
			PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
			RE2_SLOT="20220623"
		elif has_version "dev-libs/protobuf:5/5.29" ; then
			ABSEIL_CPP_SLOT="20240722"
			GRPC_SLOT="5"
			PROTOBUF_CPP_SLOT="5"
			PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
			RE2_SLOT="20240116"
		elif has_version "dev-libs/protobuf:6/6.33" ; then
			ABSEIL_CPP_SLOT="20250512"
			GRPC_SLOT="6"
			PROTOBUF_CPP_SLOT="6"
			PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
			RE2_SLOT="20240116"
		fi
		abseil-cpp_python_configure
		protobuf_python_configure
		re2_python_configure
		grpc_python_configure
	fi
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

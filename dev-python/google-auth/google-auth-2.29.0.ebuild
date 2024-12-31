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
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

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
# Uses PROTOBUF_SLOT=0/3.20 ; 3.20.3
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
			<dev-python/urllib3-2.0.0[${PYTHON_USEDEP}]
		' python3_10)
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
			(
				=dev-python/grpcio-1.54*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.54*[${PYTHON_USEDEP},python]
			)
			(
				=dev-python/grpcio-1.53*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.53*[${PYTHON_USEDEP},python]
			)
			(
				=dev-python/grpcio-1.52*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.52*[${PYTHON_USEDEP},python]
			)
			(
				=dev-python/grpcio-1.49*[${PYTHON_USEDEP}]
				=net-libs/grpc-1.49*[${PYTHON_USEDEP},python]
			)
		)
		dev-python/grpcio:=[${PYTHON_USEDEP}]
		net-libs/grpc:=[${PYTHON_USEDEP},python]

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

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

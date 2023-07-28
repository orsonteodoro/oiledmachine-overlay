# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Google Authentication Library"
HOMEPAGE="
	https://github.com/googleapis/google-auth-library-python/
	https://pypi.org/project/google-auth/
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE+="
aiohttp enterprise_cert pyopenssl reauth requests
"
RDEPEND="
	!dev-python/namespace-google
	(
		<dev-python/cachetools-6.0.0[${PYTHON_USEDEP}]
		>=dev-python/cachetools-2.0.0[${PYTHON_USEDEP}]
	)
	(
		<dev-python/rsa-5[${PYTHON_USEDEP}]
		>=dev-python/rsa-3.1.4[${PYTHON_USEDEP}]
	)
	>=dev-python/pyasn1-0.4.8[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.2.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	aiohttp? (
		(
			<dev-python/aiohttp-4_pre[${PYTHON_USEDEP}]
			>=dev-python/aiohttp-3.6.2[${PYTHON_USEDEP}]
		)
		(
			<dev-python/requests-3.0.0_pre[${PYTHON_USEDEP}]
			>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
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
		<dev-python/requests-3.0.0_pre[${PYTHON_USEDEP}]
		>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		<dev-python/cryptography-39[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/grpcio:=[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/moto[${PYTHON_USEDEP}]
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
	)
"

distutils_enable_tests "pytest"

EPYTEST_IGNORE=(
	# these are compatibility tests with oauth2client
	# disable them to unblock removal of that package
	tests/test__oauth2client.py
)

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

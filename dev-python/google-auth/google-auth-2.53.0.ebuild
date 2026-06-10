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
PYTHON_COMPAT=( "python3_"{10..14} )

_PROTOBUF_PYTHON=(
	protobuf_python_3
	protobuf_python_4
	protobuf_python_5
	protobuf_python_6
)
_PROTOBUF_CPP=(
	protobuf_cpp_3
	protobuf_cpp_4
	protobuf_cpp_5
	protobuf_cpp_6
)

CFLAGS_HARDENED_USE_CASES="security-critical network sensitive-data untrusted-data"

inherit abseil-cpp cflags-hardened distutils-r1 grpc protobuf re2

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}/google-cloud-python-google-auth-v${PV}/packages/google-auth"
SRC_URI="
https://github.com/googleapis/google-cloud-python/archive/refs/tags/google-auth-v${PV}.tar.gz
"

DESCRIPTION="The Google Auth library simplifies server-to-server authentication to Google APIs"
HOMEPAGE="
	https://github.com/googleapis/google-cloud-python/tree/main/packages/google-auth
	https://github.com/googleapis/google-auth-library-python/
	https://pypi.org/project/google-auth/
"
LICENSE="Apache-2.0"
RESTRICT="test" # Not tested
SLOT="0"
IUSE+="
${_PROTOBUF_PYTHON[@]}
${_PROTOBUF_CPP[@]}
aiohttp cryptography enterprise_cert pyjwt pyopenssl reauth requests urllib3 rsa test
ebuild_revision_5
"
REQUIRED_USE="
	test? (
		aiohttp
		pyjwt
		pyopenssl
		reauth
		urllib3
		^^ (
			${_PROTOBUF_PYTHON[@]}
		)
		^^ (
			${_PROTOBUF_CPP[@]}
		)
	)
"
RDEPEND="
	>=dev-python/pyasn1-modules-0.2.1[${PYTHON_USEDEP}]
	>=dev-python/cryptography-38.0.3[${PYTHON_USEDEP}]

	aiohttp? (
		>=dev-python/aiohttp-3.8.0[${PYTHON_USEDEP}]
		<dev-python/aiohttp-4.0.0[${PYTHON_USEDEP}]
	)
	cryptography? (
		>=dev-python/cryptography-38.0.3[${PYTHON_USEDEP}]
	)
	enterprise_cert? (
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
	pyjwt? (
		>=dev-python/pyjwt-2.0[${PYTHON_USEDEP}]
	)
	pyopenssl? (
		>=dev-python/pyopenssl-20.0.0[${PYTHON_USEDEP}]
	)
	reauth? (
		>=dev-python/pyu2f-0.1.5[${PYTHON_USEDEP}]
	)
	requests? (
		>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
		<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
	)
	urllib3? (
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
	rsa? (
		>=dev-python/rsa-3.1.4[${PYTHON_USEDEP}]
		<dev-python/rsa-5[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/aioresponses[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		<dev-python/pyopenssl-24.3.0[${PYTHON_USEDEP}]
		<dev-python/aiohttp-3.10.0[${PYTHON_USEDEP}]

		protobuf_cpp_3? (
			protobuf_python_3? (
				dev-python/grpcio:3/1.30[${PYTHON_USEDEP}]
				net-libs/grpc:3/1.30[${PYTHON_USEDEP},python]
			)
		)
		protobuf_cpp_3? (
			protobuf_python_4? (
				dev-python/grpcio:3/1.51[${PYTHON_USEDEP}]
				net-libs/grpc:3/1.51[${PYTHON_USEDEP},python]
			)
		)
		protobuf_cpp_4? (
			dev-python/grpcio:4/1.62[${PYTHON_USEDEP}]
			net-libs/grpc:4/1.62[${PYTHON_USEDEP},python]
		)
		protobuf_cpp_5? (
			dev-python/grpcio:5/1.71[${PYTHON_USEDEP}]
			net-libs/grpc:5/1.71[${PYTHON_USEDEP},python]
		)
		protobuf_cpp_6? (
			dev-python/grpcio:6/1.75[${PYTHON_USEDEP}]
			net-libs/grpc:6/1.75[${PYTHON_USEDEP},python]
		)
		dev-python/grpcio:=
		net-libs/grpc:=
	)
"

distutils_enable_tests "pytest"

python_configure() {
	cflags-hardened_append
	if use test ; then
		if use protobuf_cpp_3 && use protobuf_python_3 ; then
			ABSEIL_CPP_SLOT="20200225"
			GRPC_SLOT="3"
			PROTOBUF_CPP_SLOT="3"
			PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_3}"
			RE2_SLOT="20220623"
		elif use protobuf_cpp_3 && use protobuf_python_4 ; then
			ABSEIL_CPP_SLOT="20220623"
			GRPC_SLOT="3"
			PROTOBUF_CPP_SLOT="3"
			PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_4_WITH_PROTOBUF_CPP_3}"
			RE2_SLOT="20220623"
		elif use protobuf_cpp_4 && use protobuf_python_4 ; then
			ABSEIL_CPP_SLOT="20240116"
			GRPC_SLOT="4"
			PROTOBUF_CPP_SLOT="4"
			PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_4_WITH_PROTOBUF_CPP_4}"
			RE2_SLOT="20220623"
		elif use protobuf_cpp_5 ; then
			ABSEIL_CPP_SLOT="20240722"
			GRPC_SLOT="5"
			PROTOBUF_CPP_SLOT="5"
			PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_5}"
			RE2_SLOT="20250512"
		elif use protobuf_cpp_6 ; then
			ABSEIL_CPP_SLOT="20250512"
			GRPC_SLOT="6"
			PROTOBUF_CPP_SLOT="6"
			PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_6}"
			RE2_SLOT="20250512"
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

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
	https://files.pythonhosted.org/packages/e6/aa/809e7de6af007e36d456d9a5361250bc906a3f3a6dfc9babebb0de146641/google_ai_generativelanguage-0.6.17.tar.gz
"

DESCRIPTION="Google AI Generative Language API client library"
HOMEPAGE="
	https://github.com/googleapis/google-cloud-python/tree/main/packages/google-ai-generativelanguage
	https://pypi.org/project/google-ai-generativelanguage/
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	(
		!=dev-python/google-api-core-2.0*
		!=dev-python/google-api-core-2.1*
		!=dev-python/google-api-core-2.2*
		!=dev-python/google-api-core-2.3*
		!=dev-python/google-api-core-2.4*
		!=dev-python/google-api-core-2.5*
		!=dev-python/google-api-core-2.6*
		!=dev-python/google-api-core-2.7*
		!=dev-python/google-api-core-2.8*
		!=dev-python/google-api-core-2.9*
		!=dev-python/google-api-core-2.10*
		>=dev-python/google-api-core-1.34.1[${PYTHON_USEDEP},grpc]
		<dev-python/google-api-core-3.0.0[${PYTHON_USEDEP}]
	)
	(
		!=dev-python/google-auth-2.24.0
		!=dev-python/google-auth-2.25.0
		>=dev-python/google-auth-2.14.1[${PYTHON_USEDEP}]
		<dev-python/google-auth-3.0.0[${PYTHON_USEDEP}]
	)
	(
		$(python_gen_cond_dep '
			(
				>=dev-python/proto-plus-1.22.3[${PYTHON_USEDEP}]
				<dev-python/proto-plus-2.0.0[${PYTHON_USEDEP}]
			)
		' python3_{10,11,12})
		$(python_gen_cond_dep '
			(
				>=dev-python/proto-plus-1.25.0[${PYTHON_USEDEP}]
				<dev-python/proto-plus-2.0.0[${PYTHON_USEDEP}]
			)
		' python3_13)
	)
	(
		!=dev-python/protobuf-4.21.0
		!=dev-python/protobuf-4.21.1
		!=dev-python/protobuf-4.21.2
		!=dev-python/protobuf-4.21.3
		!=dev-python/protobuf-4.21.4
		!=dev-python/protobuf-4.21.5
		>=dev-python/protobuf-3.20.2[${PYTHON_USEDEP}]
		<dev-python/protobuf-7.0.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.rst" )

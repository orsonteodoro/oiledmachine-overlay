# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For version correspondence, see
# https://github.com/open-telemetry/opentelemetry-python/blob/v1.27.0/opentelemetry-semantic-conventions/src/opentelemetry/semconv/version/__init__.py

MY_PN="opentelemetry_semantic_conventions"
MY_PV="${PV/_beta/b}"

DISTUTILS_USE_PEP517="hatchling"
OPENTELEMETRY_PV="1.38.0"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="OpenTelemetry Semantic Conventions"
HOMEPAGE="
	https://opentelemetry.io/
	https://pypi.org/project/opentelemetry-sdk/
	https://github.com/open-telemetry/opentelemetry-python/
"
LICENSE="Apache-2.0"
SLOT="${PROTOBUF_CPP_SLOT}/${OPENTELEMETRY_PV%.*}"
RDEPEND="
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-api-${OPENTELEMETRY_PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
"
BDEPEND="
	test? (
		>=dev-python/asgiref-3.7.2[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-6.11.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
		>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.19.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

python_test() {
	cp -a "${BUILD_DIR}/"{"install","test"} || die
	local -x PATH="${BUILD_DIR}/test/usr/bin:${PATH}"

	local L=(
		"opentelemetry-sdk"
		"tests/opentelemetry-test-utils"
	)
	local dep
	for dep in ${L[@]} ; do
		pushd "${WORKDIR}/${MY_P}/${dep}" >/dev/null || die
			distutils_pep517_install "${BUILD_DIR}/test"
		popd >/dev/null || die
	done

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

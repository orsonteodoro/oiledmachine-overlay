# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_api"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="OpenTelemetry Python API"
HOMEPAGE="
	https://opentelemetry.io/
	https://pypi.org/project/opentelemetry-api/
	https://github.com/open-telemetry/opentelemetry-python/
"
LICENSE="Apache-2.0"
SLOT="${PROTOBUF_CPP_SLOT}/$(ver_cut 1-2 ${PV})" # Use PYTHONPATH for multislot package
KEYWORDS="~amd64"
RDEPEND="
	>=dev-python/importlib-metadata-6.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/asgiref-3.7.2[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-8.7.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
		>=dev-python/pluggy-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.20.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

src_prepare() {
	default

	# Unnecessary restriction
	sed -i \
		-e '/importlib-metadata/s:, <= [0-9.]*::' \
		"pyproject.toml" \
		|| die
}

python_test() {
	cp -a "${BUILD_DIR}"/{install,test} || die
	local -x PATH=${BUILD_DIR}/test/usr/bin:${PATH}

	local L=(
		"opentelemetry-semantic-conventions"
		"opentelemetry-sdk"
		"tests/opentelemetry-test-utils"
	)

	local dep
	for dep in ${L[@]} ; do
		pushd "${WORKDIR}/${MY_P}/${dep}" >/dev/null || die
			distutils_pep517_install "${BUILD_DIR}"/test
		popd >/dev/null || die
	done

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

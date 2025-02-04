# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_api"

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="OpenTelemetry Python API"
HOMEPAGE="
	https://opentelemetry.io/
	https://pypi.org/project/opentelemetry-api/
	https://github.com/open-telemetry/opentelemetry-python/
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	>=dev-python/deprecated-1.2.6[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/typing-extensions[${PYTHON_USEDEP}]
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

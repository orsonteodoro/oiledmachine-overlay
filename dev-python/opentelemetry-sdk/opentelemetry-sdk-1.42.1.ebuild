# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="opentelemetry_sdk"

DISTUTILS_USE_PEP517="hatchling"
PROTOBUF_CPP_SLOT="5"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="OpenTelemetry Python SDK"
HOMEPAGE="
	https://opentelemetry.io/
	https://pypi.org/project/opentelemetry-sdk/
	https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-sdk
"
LICENSE="Apache-2.0"
SLOT="${PROTOBUF_CPP_SLOT}/"$(ver_cut "1-2" "${PV}")
IUSE="
benchmark
file-configuration
ebuild_revision_2
"
RDEPEND="
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-api-${PV}:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api:=
	~dev-python/opentelemetry-semantic-conventions-0.63_beta1:${PROTOBUF_CPP_SLOT}[${PYTHON_USEDEP}]
	dev-python/opentelemetry-semantic-conventions:=
	file-configuration? (
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-4.0[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	benchmark? (
		~dev-python/pytest-benchmark-4.0.0[${PYTHON_USEDEP}]
	)
	test? (
		~dev-python/asgiref-3.7.2[${PYTHON_USEDEP}]
		~dev-python/flaky-3.7.0[${PYTHON_USEDEP}]
		~dev-python/importlib-metadata-6.11.0[${PYTHON_USEDEP}]
		~dev-python/iniconfig-2.0.0[${PYTHON_USEDEP}]
		~dev-python/packaging-24.0[${PYTHON_USEDEP}]
		~dev-python/pluggy-1.6.0[${PYTHON_USEDEP}]
		~dev-python/psutil-7.2.2[${PYTHON_USEDEP}]
		~dev-python/py-cpuinfo-9.0.0[${PYTHON_USEDEP}]
		~dev-python/pytest-7.4.4[${PYTHON_USEDEP}]
		~dev-python/jsonschema-4.25.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			~dev-python/rpds-py-0.23.1[${PYTHON_USEDEP}]
		' python3_10)
		$(python_gen_cond_dep '
			~dev-python/rpds-py-0.30.0[${PYTHON_USEDEP}]
		' python3_{11..13})
		~dev-python/pyyaml-6.0.3[${PYTHON_USEDEP}]
		~dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
		~dev-python/typing-extensions-4.12.0[${PYTHON_USEDEP}]
		~dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
		~dev-python/zipp-3.19.2[${PYTHON_USEDEP}]
	)
"

# Tests cannot handle xdist with high makeopts
# https://bugs.gentoo.org/928132
distutils_enable_tests "pytest"

python_test() {
	cp -a "${BUILD_DIR}/"{"install","test"} || die
	local -x PATH="${BUILD_DIR}/test/usr/bin:${PATH}"

	for dep in tests/opentelemetry-test-utils; do
		pushd "${WORKDIR}/${MY_P}/${dep}" >/dev/null || die
			distutils_pep517_install "${BUILD_DIR}/test"
		popd >/dev/null || die
	done

	local EPYTEST_DESELECT=(
		# TODO
		"${PN}/tests/resources/test_resources.py::TestOTELResourceDetector::test_process_detector"
		"${PN}/tests/metrics/integration_test/test_console_exporter.py::TestConsoleExporter::test_console_exporter_with_exemplars"
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}

python_install_all() {
	distutils-r1_python_install_all
	dodir "/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/lib"
	mv \
		"${ED}/usr/lib/python"* \
		"${ED}/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/lib" \
		|| die

	dodir "/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/share/doc"
	mv \
		"${ED}/usr/share/doc/${PN}-${PV}" \
		"${ED}/usr/lib/opentelemetry/${PROTOBUF_CPP_SLOT}/share/doc" \
		|| die
}

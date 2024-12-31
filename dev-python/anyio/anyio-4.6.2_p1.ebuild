# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# On amd64, let's get more test coverage by dragging in uvloop, but let's not
# bother on other arches where uvloop may not be supported.

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "pypy3" "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64 ~arm64-macos"

DESCRIPTION="A compatibility layer for multiple asynchronous event loop implementations"
HOMEPAGE="
	https://github.com/agronholm/anyio/
	https://pypi.org/project/anyio/
"
RESTRICT="test" # Untested
LICENSE="MIT"
SLOT="0"
IUSE+=" doc test"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/exceptiongroup-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.1[${PYTHON_USEDEP}]
	' 3.10)
	>=dev-python/idna-2.8[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-64[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.4[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-7.4[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc-typehints-1.2.0[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/trio-0.26.1[${PYTHON_USEDEP}]
		' 3.{10..13})
		>=dev-python/exceptiongroup-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.9[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		>=dev-python/truststore-0.9.1[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		amd64? (
			$(python_gen_cond_dep '
				>=dev-python/uvloop-0.21.0_beta1[${PYTHON_USEDEP}]
			' python3_{10..13})
		)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.6.2_p1-pyproject-toml-changes.patch"
)

distutils_enable_tests "pytest"
distutils_enable_sphinx "docs" \
	">=dev-python/sphinx-rtd-theme-1.2.2" \
	"dev-python/sphinxcontrib-jquery" \
	"dev-python/sphinx-autodoc-typehints"

python_test() {
	local EPYTEST_DESELECT=(
		# requires link-local IPv6 interface
		"tests/test_sockets.py::TestTCPListener::test_bind_link_local"
	)

	local filter=()
	if ! has_version ">=dev-python/trio-0.26.1[${PYTHON_USEDEP}]"; then
		filter+=( -k "not trio" )
		EPYTEST_DESELECT+=(
			"tests/test_pytest_plugin.py::test_plugin"
			"tests/test_pytest_plugin.py::test_autouse_async_fixture"
			"tests/test_pytest_plugin.py::test_cancel_scope_in_asyncgen_fixture"
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m 'not network' "${filter[@]}"
}

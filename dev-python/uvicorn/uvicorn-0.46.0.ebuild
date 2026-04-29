# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
EPYTEST_PLUGINS=( "anyio" "pytest-mock" )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
PYPI_VERIFY_REPO="https://github.com/Kludex/uvicorn"
PYTHON_COMPAT=( "pypy3_11" "python3_"{11..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Lightning-fast ASGI server implementation"
HOMEPAGE="
	https://www.uvicorn.org/
	https://github.com/Kludex/uvicorn/
	https://pypi.org/project/uvicorn/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="dev doc standard test"
REQUIRED_USE="
	dev? (
		standard
	)
	test? (
		dev
		standard
	)
"
RDEPEND="
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/h11-0.8[${PYTHON_USEDEP}]
	standard? (
		>=dev-python/colorama-0.4[${PYTHON_USEDEP}]
		>=dev-python/httptools-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/python-dotenv-0.13[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/uvloop-0.15.1[${PYTHON_USEDEP}]
		>=dev-python/watchfiles-0.20[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.4[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev? (
		>=dev-python/a2wsgi-1.10.10[${PYTHON_USEDEP}]
		>=dev-python/coverage-7.13.4[${PYTHON_USEDEP}]
		>=dev-python/coverage-conditional-plugin-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-enable-subprocess-1.0[${PYTHON_USEDEP}]
		>=dev-python/cryptography-44.0.3[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-9.0.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.15.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.8.0[${PYTHON_USEDEP},psutil(+)]
		>=dev-python/pytest-codspeed-4.1.1[${PYTHON_USEDEP}]
		>=dev-python/trustme-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/types-click-7.1.8[${PYTHON_USEDEP}]
		>=dev-python/types-pyyaml-6.0.12.20250915[${PYTHON_USEDEP}]
		>=dev-python/twine-6.2.0[${PYTHON_USEDEP}]
		>=dev-python/websockets-13.1[${PYTHON_USEDEP}]
		>=dev-python/wsproto-1.3.2[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.15.1
	)
	doc? (
		>=dev-python/mkdocs-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-llmstxt-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-material-9.7.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocstrings-python-2.0.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

python_test() {
	local EPYTEST_DESELECT=(
	# Too long path for unix socket
		'tests/test_config.py::test_bind_unix_socket_works_with_reload_or_workers'
	# TODO
		'tests/protocols/test_http.py::test_close_connection_with_multiple_requests[httptools]'
		'tests/protocols/test_websocket.py::test_send_binary_data_to_server_bigger_than_default_on_websockets[httptools-max=defaults sent=defaults+1]'
		'tests/protocols/test_websocket.py::test_send_binary_data_to_server_bigger_than_default_on_websockets[h11-max=defaults sent=defaults+1]'
	# Tests are broken with non-ancient dev-python/websockets
		'tests/protocols/test_websocket.py::test_fragmented_message_exceeding_max_size'
		'tests/protocols/test_websocket.py::test_fragmented_message_reassembly'
	)
	case "${EPYTHON}" in
		"pypy3"*)
	# TODO
			EPYTEST_DESELECT+=(
				"tests/middleware/test_logging.py::test_running_log_using_fd"
			)
			;;
	esac

	epytest
}

pkg_postinst() {
	optfeature "auto reload on file changes" dev-python/watchfiles
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1 # Simplify switch
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

SRC_URI="
https://github.com/conan-io/${PN}/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="A decentralized C/C++ package manager"
HOMEPAGE="https://conan.io/"
LICENSE="MIT"
# Try to fix the test if you're brave enough.
# Conan requires noumerous external toolchain dependencies with restricted
# versions and cannot be managable outside of a pure CI environment.
RESTRICT="test"
SLOT="0/${PV%%.*}" # Version 2
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dev server runners test"
REQUIRED_USE="
	test? (
		server
	)
"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
		>=dev-python/distro-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/fasteners-0.15[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
		>=dev-python/patch-ng-1.18.0[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.25[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.26.6[${PYTHON_USEDEP}]
		runners? (
			>=dev-python/docker-7.1.0[${PYTHON_USEDEP}]
			dev-python/paramiko[${PYTHON_USEDEP}]
		)
		server? (
			>=dev-python/bottle-0.12.8[${PYTHON_USEDEP}]
			>=dev-python/pluginbase-0.5[${PYTHON_USEDEP}]
			>=dev-python/pyjwt-2.4.0[${PYTHON_USEDEP}]
		)
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
			>=dev-python/parameterized-0.6.3[${PYTHON_USEDEP}]
			>=dev-python/pytest-7[${PYTHON_USEDEP}]
			>=dev-python/webtest-3.0.0[${PYTHON_USEDEP}]
			dev-python/bottle[${PYTHON_USEDEP}]
			dev-python/docker[${PYTHON_USEDEP}]
			dev-python/pluginbase[${PYTHON_USEDEP}]
			dev-python/pyjwt[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
		)
	')
"

src_prepare() {
	default
	# Fix strict dependencies
	sed -i \
		-e 's:,[[:space:]]\?<=\?[[:space:]]\?[[:digit:]|.]*::g' \
		-e 's:==:>=:g' \
		"conans/requirements"{"","_server"}".txt" \
		|| die
}

python_install() {
	distutils-r1_python_install
}

src_install() {
	distutils-r1_src_install
}

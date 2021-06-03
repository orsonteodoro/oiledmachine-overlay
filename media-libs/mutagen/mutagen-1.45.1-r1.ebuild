# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Audio metadata tag reader and writer implemented in pure Python"
HOMEPAGE="https://github.com/quodlibet/mutagen https://pypi.org/project/mutagen/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux \
~x86-linux"
IUSE+=" doc test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
# TODO: Missing support for >=dev-python/eyeD3-0.7 API
# test? ( >=dev-python/eyeD3-0.7 )
RDEPEND+=" ${PYTHON_DEPS}"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"
SRC_URI="
https://github.com/quodlibet/mutagen/releases/download/release-${PV}/${P}.tar.gz"
RESTRICT="!test? ( test )"

python_compile_all() {
	use doc && emake -C docs
}

python_test() {
	esetup.py test --no-quality
}

python_install_all() {
	local DOCS=( NEWS README.rst )
	use doc && local HTML_DOCS=( docs/_build/. )
	distutils-r1_python_install_all
}

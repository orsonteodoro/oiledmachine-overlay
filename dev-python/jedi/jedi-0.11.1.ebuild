# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="https://github.com/davidhalter/jedi"
SRC_URI="https://github.com/davidhalter/jedi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE} test? ( || ( python_targets_python3_4 python_targets_python3_5 ) !python_targets_python2_7 )"

RESTRICT="test"

DEPEND="
	>=dev-python/parso-0.1.1
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	if ! use test ; then
		rm -rf test #the tests only support python 3.5 and above
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${PYTHONPATH%:}${PYTHONPATH+:}${S}/test" py.test -v -v test \
		|| die "Tests failed under ${EPYTHON}"
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && HTML_DOCS=( "${S}"/docs/_build/html/. )
	distutils-r1_python_install_all
}

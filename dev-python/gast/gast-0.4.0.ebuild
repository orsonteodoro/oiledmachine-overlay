# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8,9,10} ) # Lists up to 3.7.  3.9 was tested.

# python3.10 error:
# ======================================================================
# ERROR: testCompile (tests.test_self.SelfTestCase)
# ----------------------------------------------------------------------
# Traceback (most recent call last):
#   File "/var/tmp/portage/dev-python/gast-0.4.0/work/gast-0.4.0/tests/test_self.py", line 26, in testCompile
#     compile(gast.gast_to_ast(gnode), src_py, 'exec')
# TypeError: required field "lineno" missing from alias

inherit distutils-r1 pypi

DESCRIPTION="A generic AST to represent Python2 and Python3's Abstract Syntax Tree (AST)"
HOMEPAGE="
https://pypi.org/project/gast/
https://github.com/serge-sans-paille/gast/
"

LICENSE="BSD PSF-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE+=" test"

BDEPEND+="
	test? (
		dev-python/astunparse[${PYTHON_USEDEP}]
	)
"

pkg_setup() {
	if use python_targets_python3_10 ; then
eerror
eerror "python_targets_python3_10 breaks during testing."
eerror "Disable the python_targets_python3_10 USE flag."
eerror
		die
	fi
	python_setup
}

src_test() {
	run_test() {
einfo "Running test for ${EPYTHON}"
		${EPYTHON} setup.py test || die
	}
	python_foreach_impl run_test
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED for 0.4.0 20230420
# USE="test" PYTHON_TARGETS="python3_9"
# Ran 35 tests in 0.386s
#
# OK

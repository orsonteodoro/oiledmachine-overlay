# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 20.04

# TODO package
# interpreters-pep-734

MY_PV="${PV/_beta/b}"
MY_PV="${MY_PV/_rc/rc}"

CFLAGS_HARDENED_USE_CASES="system-set"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..14} "pypy3_11" )
PYTHON_REQ_USE="threads(+)"
SITEFILE="50cython-gentoo.el"
SLOT_MAJOR=$(ver_cut 1-2 "${PV}")

inherit distutils-r1 flag-o-matic toolchain-funcs elisp-common

# Based on CI
KEYWORDS="
~amd64 ~amd64-linux ~amd64-macos ~arm64 ~arm64-macos
"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
https://github.com/cython/cython/archive/${MY_PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="A Python to C compiler"
HOMEPAGE="
	https://cython.org/
	https://github.com/cython/cython/
	https://pypi.org/project/Cython/
"
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${SLOT_MAJOR}/${PV}"
IUSE="
doc emacs test
ebuild_revision_17
"
RDEPEND="
	!dev-python/cython:3
	emacs? (
		>=app-editors/emacs-23.1:*
	)
"
DEPEND="
	${RDEPEND}
"
# <dev-python/setuptools-60[${PYTHON_USEDEP}] relaxed for python3_11
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-9.1.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-issues-5.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-tabs-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-clarity-theme-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/ipython-pygments-lexers-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/setuptools-82.0.1[${PYTHON_USEDEP}]
		>=dev-python/alabaster-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/babel-2.18.0[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup4-4.13.3[${PYTHON_USEDEP}]
		>=dev-python/certifi-2026.2.25[${PYTHON_USEDEP}]
		>=dev-python/charset-normalizer-3.4.6[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.22.4[${PYTHON_USEDEP}]
		>=dev-python/idna-3.11[${PYTHON_USEDEP}]
		>=dev-python/imagesize-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.6[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/packaging-26.0[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.19.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
		>=dev-python/roman-numerals-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/setuptools-82.0.1[${PYTHON_USEDEP}]
		>=dev-python/snowballstemmer-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/soupsieve-2.8.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-null-theme-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-applehelp-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-devhelp-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-htmlhelp-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-qthelp-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-serializinghtml-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/typing_extensions-4.15.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-2.6.3[${PYTHON_USEDEP}]
	)
	test? (
		(
			virtual/numpy[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/pycodestyle[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
			>=dev-python/abi3audit-0.0.25[${PYTHON_USEDEP}]
		)
		(
			!=dev-python/line_profiler-4*
			dev-python/ipython[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		)
		$(python_gen_cond_dep '
			dev-python/interpreters-pep734[${PYTHON_USEDEP}]
		' python3_13)
	)
"
# For the above test section, the groups are
# test-requirements
# test-requirements-cython
# test-requirements-python3.13
PATCHES=(
#	"${FILESDIR}/${PN}-0.29.23-test_exceptions-py310.patch"
	"${FILESDIR}/${PN}-0.29.23-pythran-parallel-install.patch"
)

# disabled to workaround pkgcheck performance issue
# https://github.com/pkgcore/pkgcheck/issues/782
#distutils_enable_sphinx \
#	"docs" \
#	"dev-python/jinja2" \
#	"dev-python/sphinx-issues" \
#	"dev-python/sphinx-tabs"

python_compile() {
	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	# uses $(nproc) to additionally parallelize many OpenMP-based jobs,
	# leading to overcommitting
	local -x OMP_NUM_THREADS=1

	distutils-r1_python_compile
}

python_compile_all() {
	use emacs && elisp-compile "Tools/cython-mode.el"
}

python_test() {
	# PYTHON_TESTED controls whether we expect the testsuite to
	# pass at all, while PYTHON_FULLY_TESTED allows skipping before
	# numpy is ported (and possibly other deps in future).
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}" ; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	# Needed to avoid confusing cache tests
	unset CYTHON_FORCE_REGEN

	# Uses $(nproc) to additionally parallelize many OpenMP-based jobs,
	# leading to overcommitting
	local -x OMP_NUM_THREADS=1

	tc-export CC

	local testargs=(
		-vv
		-j "$(makeopts_jobs)"
		--work-dir "${BUILD_DIR}"/tests

		--no-examples
		--no-code-style

		# Fails to find embedded.c
		--exclude 'embedded'
		# coverage_installed_pkg needs dev-python/pip and doesn't like
		# 'externally-managed' (bug #927995), but we don't really
		# want automagic test dependencies at all, so just skip
		# unimportant-for-us coverage tests entirely.
		--exclude 'run.coverage*'
		--exclude 'Cython.Coverage'
		# Automagic on dev-python/python-tests, could add this in future
		--exclude 'run.test_exceptions'
		# TODO: Unpackaged dev-python/interpreters-pep-734 (interpreters_backport)
		# This only shows up as a failure with >=3.13.
		--exclude 'subinterpreters_threading_stress_test'

		# The fix for https://github.com/cython/cython/issues/6938
		# changes these tests s.t. they break with our build layout.
		--exclude 'build.depfile*'
	)

	# Keep test-full for numpy as it's large and doesn't pass tests itself
	# on niche arches.
	if ! use test-full || ! has "${EPYTHON/./_}" "${PYTHON_FULLY_TESTED[@]}"; then
		testargs+=(
			--exclude 'run.numpy*'
			--exclude 'run.ufunc'
			--exclude 'numpy*'
		)
	fi

	"${PYTHON}" runtests.py "${testargs[@]}" || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=(
		"CHANGES.rst"
		"README.rst"
		"ToDo.txt"
		"USAGE.txt"
	)
	distutils-r1_python_install_all

	if use emacs; then
		elisp-install "${PN}" "Tools/cython-mode."*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	_slotify() {
		# Slotify for parallel builds
		local old_sitedir="$(python_get_sitedir)"
		local new_sitedir="/usr/lib/cython/${SLOT_MAJOR}/lib/${EPYTHON}/site-packages"

		local old_python_exec_dir="/usr/lib/python-exec/${EPYTHON}"
		local new_python_exec_dir="/usr/lib/cython/${SLOT_MAJOR}/lib/python-exec/${EPYTHON}"

		dodir "${new_sitedir}"
		dodir "${new_python_exec_dir}"

		einfo "Slotifying ${PN}"
		mv "${ED}"{"${old_sitedir}","${new_sitedir}"}"/Cython" || die
		mv "${ED}"{"${old_sitedir}","${new_sitedir}"}"/pyximport" || die
		mv "${ED}"{"${old_sitedir}","${new_sitedir}"}"/cython.py" || die
		mv "${ED}"{"${old_sitedir}","${new_sitedir}"}"/cython-"$(ver_cut "1-3" "${PV}")".dist-info" || die
		find "${ED}" -regex '^.*\(__pycache__\|\.py[co]\)$' -delete || die
		rm -rf "${ED}/usr/bin/cygdb" || die
		rm -rf "${ED}/usr/bin/cython" || die
		rm -rf "${ED}/usr/bin/cythonize" || die

		mv "${ED}"{"${old_python_exec_dir}","${new_python_exec_dir}"}"/cygdb" || die
		mv "${ED}"{"${old_python_exec_dir}","${new_python_exec_dir}"}"/cython" || die
		mv "${ED}"{"${old_python_exec_dir}","${new_python_exec_dir}"}"/cythonize" || die

		dosym "${new_python_exec_dir}/cython" "${new_python_exec_dir}/cython3"
	}

	python_foreach_impl _slotify
}

pkg_postinst() {
	use emacs && elisp-site-regen
	eselect cython set "${SLOT_MAJOR}"
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multislot
# OILEDMACHINE-OVERLAY-META-REVDEP:  RapidFuzz, JaroWinkler

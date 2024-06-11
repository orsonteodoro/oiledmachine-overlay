# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 20.04

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} "pypy3" )
PYTHON_REQ_USE="threads(+)"
SITEFILE="50cython-gentoo.el"
SLOT_MAJOR="${PV%%.*}"

inherit distutils-r1 toolchain-funcs elisp-common

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv
~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos
~x64-solaris
"
SRC_URI="
	https://github.com/cython/cython/archive/${PV}.tar.gz
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
SLOT="${SLOT_MAJOR}/$(ver_cut 1-2 ${PV})"
IUSE="emacs test"
RDEPEND="
	app-eselect/eselect-cython
	emacs? (
		>=app-editors/emacs-23.1:*
	)
"
DEPEND="
	${RDEPEND}
"
# <dev-python/setuptools-60[${PYTHON_USEDEP}] relaxed for python3_11
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	' python3_{10..11})
	doc? (
		>=dev-python/jinja-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-issues-3.0.1[${PYTHON_USEDEP}]
	)
	test? (
		$(python_gen_any_dep '
			<dev-python/numpy-2[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/pycodestyle[${PYTHON_USEDEP}]
		')
		$(python_gen_cond_dep '
			dev-python/line-profiler[${PYTHON_USEDEP}]
		' python3_{10..11})
		doc? (
			$(python_gen_cond_dep '
				dev-python/jupyter[${PYTHON_USEDEP}]
			' python3_{10..11})
		)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.29.22-spawn-multiprocessing.patch"
	"${FILESDIR}/${PN}-0.29.23-test_exceptions-py310.patch"
	"${FILESDIR}/${PN}-0.29.23-pythran-parallel-install.patch"
)

distutils_enable_sphinx \
	"docs"

python_compile() {
	# Python gets confused when it is in sys.path before build.
	local -x PYTHONPATH=

	distutils-r1_python_compile
}

python_compile_all() {
	use emacs && elisp-compile "Tools/cython-mode.el"
}

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}" ; then
		einfo "Skipping tests on ${EPYTHON} (xfail)"
		return
	fi

	tc-export CC
	# https://github.com/cython/cython/issues/1911
	local -x CFLAGS="${CFLAGS} -fno-strict-overflow"
	"${PYTHON}" "runtests.py" \
		-vv \
		-j "$(makeopts_jobs)" \
		--work-dir "${BUILD_DIR}/tests" \
		|| die "Tests fail with ${EPYTHON}"
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
		einfo "Slotifying ${PN}"
		mv "${ED}$(python_get_sitedir)/Cython"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}$(python_get_sitedir)/pyximport"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}$(python_get_sitedir)/cython.py"{"",".${SLOT_MAJOR}"} || die
		find "${ED}" -regex '^.*\(__pycache__\|\.py[co]\)$' -delete || die
		rm -rf "${ED}/usr/bin/cygdb" || die
		rm -rf "${ED}/usr/bin/cython" || die
		rm -rf "${ED}/usr/bin/cythonize" || die

		mv "${ED}/usr/lib/python-exec/${EPYTHON}/cygdb"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}/usr/lib/python-exec/${EPYTHON}/cython"{"",".${SLOT_MAJOR}"} || die
		mv "${ED}/usr/lib/python-exec/${EPYTHON}/cythonize"{"",".${SLOT_MAJOR}"} || die
	}

	python_foreach_impl _slotify
}

pkg_postinst() {
	use emacs && elisp-site-regen
	eselect cython set "cython.${SLOT_MAJOR}"
einfo
einfo "Use eselect cython to switch between cython slots."
einfo
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multislot
# OILEDMACHINE-OVERLAY-META-REVDEP:  distro-packages

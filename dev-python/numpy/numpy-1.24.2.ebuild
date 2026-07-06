# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="AFW BO CE DOS IL ISD NPD SYM"
CYTHON_SLOT="0.29"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
DL_SOURCE=${DL_SOURCE:-"git"}
FORTRAN_NEEDED="lapack"
PYTHON_COMPAT=( "python3_11" ) # Forced for binary packages
PYTHON_REQ_USE="threads(+)"

DOC_PV="${PV}"

inherit cflags-hardened cython distutils-r1 flag-o-matic fortran-2 toolchain-funcs

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Use pypi or git for submodules
if [[ "${DL_SOURCE}" == "git" ]] ; then
	EGIT_COMMIT="v${PV}"
	EGIT_REPO_URI="https://github.com/numpy/numpy.git"
	inherit git-r3
elif [[ "${DL_SOURCE}" == "pypi" ]] ; then
	inherit pypy
else
	die "DL_SOURCE must be git or pypi"
fi

#	doc? (
#https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-html.zip -> numpy-html-${DOC_PV}.zip
#https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-ref.pdf -> numpy-ref-${DOC_PV}.pdf
#https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-user.pdf -> numpy-user-${DOC_PV}.pdf
#	)

DESCRIPTION="Fast array and numerical Python library"
HOMEPAGE="
	https://numpy.org/
	https://github.com/numpy/numpy/
	https://pypi.org/project/numpy/
"
LICENSE="BSD"
SLOT="0"
IUSE="
doc lapack linter release test
ebuild_revision_8
"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-python/setuptools-59.2.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.0[${PYTHON_USEDEP}]
	dev-python/cython:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	>=dev-python/wheel-0.37.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		~dev-python/numpydoc-1.4[${PYTHON_USEDEP}]
		~dev-python/pydata-sphinx-theme-0.9.0[${PYTHON_USEDEP}]
		dev-python/sphinx-design[${PYTHON_USEDEP}]
		!~dev-python/ipython-8.1.0[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/breathe[${PYTHON_USEDEP}]

		dev-python/towncrier[${PYTHON_USEDEP}]
	)
	lapack? (
		virtual/pkgconfig
	)
	linter? (
		~dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
		~dev-python/gitpython-3.1.13[${PYTHON_USEDEP}]
	)
	release? (
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pygithub[${PYTHON_USEDEP}]
		dev-python/gitpython[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/paver[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/cython-0.29.30[${PYTHON_USEDEP}]
		<dev-python/cython-0.29.30[${PYTHON_USEDEP}]

		~dev-python/wheel-0.37.0[${PYTHON_USEDEP}]
		~dev-python/setuptools-59.2.0[${PYTHON_USEDEP}]
		~dev-python/hypothesis-6.24.1[${PYTHON_USEDEP}]
		~dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
		~dev-python/pytz-2021.3[${PYTHON_USEDEP}]
		~dev-python/pytest-cov-3.0.0[${PYTHON_USEDEP}]
		~dev-python/mypy-0.981[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/numpy-1.22.0-no-hardcode-blasv2.patch"
	"${FILESDIR}/numpy-1.24.3-fix-c++-linkage.patch"
)

distutils_enable_tests "pytest"

src_unpack() {
	if [[ "${DL_SOURCE}" == "git" ]] ; then
		git-r3_fetch
		git-r3_checkout
	elif [[ "${DL_SOURCE}" == "pypy" ]] ; then
		pypi_src_unpack
	fi
	if use doc; then
		unzip -qo "${DISTDIR}"/numpy-html-${DOC_PV}.zip -d html || die
	fi
}

python_prepare_all() {
	# Allow use with setuptools 60.x
	# See numpy-1.22.1-revert-setuptools-upper-bound.patch for details
	export SETUPTOOLS_USE_DISTUTILS="stdlib"

	if use lapack; then
		local incdir="${EPREFIX}/usr/include"
		local libdir="${EPREFIX}/usr/$(get_libdir)"
		cat >> site.cfg <<-EOF || die
			[blas]
			include_dirs = ${incdir}
			library_dirs = ${libdir}
			blas_libs = cblas,blas
			[lapack]
			library_dirs = ${libdir}
			lapack_libs = lapack
		EOF
	else
		export {ATLAS,PTATLAS,BLAS,LAPACK,MKL}=None
	fi

	export CC="$(tc-getCC) ${CFLAGS}"
	export CPP="$(tc-getCPP)"

	append-flags -fno-strict-aliasing

	# See progress in http://projects.scipy.org/scipy/numpy/ticket/573
	# with the subtle difference that we don't want to break Darwin where
	# -shared is not a valid linker argument
	if [[ "${CHOST}" != *"-darwin"* ]]; then
		append-ldflags -shared
	fi

	# only one fortran to link with:
	# linking with cblas and lapack library will force
	# autodetecting and linking to all available fortran compilers
	append-fflags -fPIC
	if use lapack; then
		NUMPY_FCONFIG="config_fc --noopt --noarch"
		# workaround bug 335908
		[[ $(tc-getFC) == *gfortran* ]] && NUMPY_FCONFIG+=" --fcompiler=gnu95"
	fi

	# don't version f2py, we will handle it.
	sed -i -e '/f2py_exe/s: + os\.path.*$::' numpy/f2py/setup.py || die

	distutils-r1_python_prepare_all
}

python_configure() {
	cython_python_configure
}

python_configure_all() {
	cflags-hardened_append
}

python_compile() {
	export MAKEOPTS="-j1" #660754

	distutils-r1_python_compile ${NUMPY_FCONFIG}
}

python_test() {
	local EPYTEST_DESELECT=(
		# very disk- and memory-hungry
		numpy/lib/tests/test_histograms.py::TestHistogram::test_big_arrays
		numpy/lib/tests/test_io.py::test_large_zip

		# precision problems
		numpy/core/tests/test_umath_accuracy.py::TestAccuracy::test_validate_transcendentals

		# runs the whole test suite recursively, that's just crazy
		numpy/core/tests/test_mem_policy.py::test_new_policy

		# very slow, unlikely to be practically useful
		numpy/typing/tests/test_typing.py
	)

	if use arm && [[ $(uname -m || echo "unknown") == "armv8l" ]] ; then
		# Degenerate case. arm32 chroot on arm64.
		# bug #774108
		EPYTEST_DESELECT+=(
			numpy/core/tests/test_cpu_features.py::Test_ARM_Features::test_features
		)
	fi

	if use x86 ; then
		EPYTEST_DESELECT+=(
			# https://github.com/numpy/numpy/issues/18388
			numpy/core/tests/test_umath.py::TestRemainder::test_float_remainder_overflow
			# https://github.com/numpy/numpy/issues/18387
			numpy/random/tests/test_generator_mt19937.py::TestRandomDist::test_pareto
			# more precision problems
			numpy/core/tests/test_einsum.py::TestEinsum::test_einsum_sums_int16
		)
	fi

	case "${ABI}" in
		alpha|arm|hppa|m68k|o32|ppc|s390|sh|sparc|x86)
			EPYTEST_DESELECT+=(
				# too large for 32-bit platforms
				numpy/core/tests/test_ufunc.py::TestUfunc::test_identityless_reduction_huge_array
			)
			;;
		*)
			;;
	esac

	distutils_install_for_testing --single-version-externally-managed \
		--record "${TMPDIR}/record.txt" ${NUMPY_FCONFIG}

	cd "${TEST_DIR}/lib" || die
	epytest -k "not _fuzz" -n "$(makeopts_jobs)"
}

python_install() {
	# https://github.com/numpy/numpy/issues/16005
	local DISTUTILS_ARGS=( build_src )
	distutils-r1_python_install ${NUMPY_FCONFIG}
	python_optimize
}

python_install_all() {
	local DOCS=( "CITATION.bib" "LICENSE.txt" "LICENSES_bundled.txt" "README.md" "THANKS.txt" )

	distutils-r1_python_install_all
}

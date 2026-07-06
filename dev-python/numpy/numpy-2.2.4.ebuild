# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D13

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="AFW BO CE DOS IL ISD NPD SYM"
CYTHON_SLOT="3.0"
EPYTEST_XDIST=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="meson-python"
DL_SOURCE=${DL_SOURCE:-"git"}
FORTRAN_NEEDED="lapack"
PYTHON_COMPAT=( "python3_13" ) # Forced for binary packages
PYTHON_REQ_USE="threads(+)"

QA_CONFIG_IMPL_DECL_SKIP=(
	# https://bugs.gentoo.org/925367
	"vrndq_f32"
)

inherit cflags-hardened cython distutils-r1 flag-o-matic fortran-2

KEYWORDS="~alpha amd64 ~arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

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

DESCRIPTION="Fast array and numerical Python library"
HOMEPAGE="
	https://numpy.org/
	https://github.com/numpy/numpy/
	https://pypi.org/project/numpy/
"

LICENSE="BSD"
SLOT="0/2"
# +lapack because the internal fallbacks are pretty slow. Building without blas
# is barely supported anyway, see bug #914358.
IUSE="
all big-endian build ci ci32 doc -lapack linter release test
ebuild_revision_7
"
REQUIRED_USE="
	all? (
		build
		ci
		doc
		linter
		release
		test
	)
"
RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-build/meson-0.15.0[${PYTHON_USEDEP}]
	dev-python/cython:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	build? (
		>=dev-build/meson-0.13.1[${PYTHON_USEDEP}]
		dev-python/cython:${CYTHON_SLOT}[${PYTHON_USEDEP}]
		dev-python/cython:=
		dev-build/ninja
		~dev-python/spin-0.13[${PYTHON_USEDEP}]
		dev-python/build[${PYTHON_USEDEP}]
	)
	ci? (
		~dev-python/spin-0.13[${PYTHON_USEDEP}]
		~dev-python/scipy-openblas32-0.3.28.0.2[${PYTHON_USEDEP}]
		~dev-python/scipy-openblas64-0.3.28.0.2[${PYTHON_USEDEP}]
	)
	ci32? (
		~dev-python/spin-0.13[${PYTHON_USEDEP}]
		~dev-python/scipy-openblas32-0.3.28.0.2[${PYTHON_USEDEP}]
	)
	doc? (
		~dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
		~dev-python/numpydoc-1.4[${PYTHON_USEDEP}]
		>=dev-python/pydata-sphinx-theme-0.15.2[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-design[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		>dev-python/breathe-4.33.0[${PYTHON_USEDEP}]
		!~dev-python/ipython-8.1.0[${PYTHON_USEDEP}]
		dev-python/pickleshare[${PYTHON_USEDEP}]

		dev-python/towncrier[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]

		~dev-python/scipy-doctest-1.5.1[${PYTHON_USEDEP}]
	)
	lapack? (
		virtual/pkgconfig
	)
	linter? (
		~dev-python/pycodestyle-2.12.1[${PYTHON_USEDEP}]
		>=dev-python/gitpython-3.1.30[${PYTHON_USEDEP}]
	)
	release? (
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pygithub[${PYTHON_USEDEP}]
		>=dev-python/gitpython-3.1.30[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/paver[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		~dev-python/wheel-0.38.1[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		~dev-python/hypothesis-6.104.1[${PYTHON_USEDEP}]
		~dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		~dev-python/pytz-2023.3_p1[${PYTHON_USEDEP}]
		~dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		dev-build/meson[${PYTHON_USEDEP}]
		dev-build/ninja[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		~dev-python/mypy-1.14.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

src_unpack() {
	if [[ "${DL_SOURCE}" == "git" ]] ; then
		git-r3_fetch
		git-r3_checkout
	elif [[ "${DL_SOURCE}" == "pypy" ]] ; then
		pypi_src_unpack
	fi
}

python_prepare_all() {
	local PATCHES=(
		# https://github.com/numpy/numpy/pull/28748
		# https://github.com/numpy/numpy/pull/28928
		"${FILESDIR}/${PN}-2.2.5-py314.patch"
		# https://github.com/google/highway/issues/2577
		# github.com/google/highway/commit/7cde540171a1718a9bdfa8f896d70e47eb0785d5
		"${FILESDIR}/${PN}-2.2.6-gcc16.patch"
	)

	# bug #922457
	filter-lto
	# https://github.com/numpy/numpy/issues/25004
	append-flags -fno-strict-aliasing

	distutils-r1_python_prepare_all
}

setup_cython3_symlink() {
	mkdir -p "${WORKDIR}/bin" || die
	ln -sf \
		"${ESYSROOT}/usr/lib/cython/${CYTHON_SLOT}/lib/python-exec/${EPYTHON}/cython" \
		"${WORKDIR}/bin/cython3" \
		|| die
	export PATH="${WORKDIR}/bin:${PATH}"
	cython3 --version || die
}

python_configure() {
	cython_python_configure
	setup_cython3_symlink
}

python_configure_all() {
	cflags-hardened_append
	DISTUTILS_ARGS=(
		-Dallow-noblas=$(usex !lapack true false)
		-Dblas=$(usev lapack cblas)
		-Dlapack=$(usev lapack lapack)
		# TODO: cpu-* options
	)
}

python_compile() {
	setup_cython3_symlink
	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_DESELECT=(
		# Very disk-and-memory-hungry
		numpy/lib/tests/test_io.py::TestSaveTxt::test_large_zip
		numpy/lib/tests/test_io.py::TestSavezLoad::test_closing_fid
		numpy/lib/tests/test_io.py::TestSavezLoad::test_closing_zipfile_after_load

		# Precision problems
		numpy/_core/tests/test_umath_accuracy.py::TestAccuracy::test_validate_transcendentals

		# Runs the whole test suite recursively, that's just crazy
		numpy/core/tests/test_mem_policy.py::test_new_policy

		numpy/typing/tests/test_typing.py
		# Uses huge amount of memory
		numpy/core/tests/test_mem_overlap.py
	)

	if [[ $(uname -m) == armv8l ]]; then
		# Degenerate case of arm32 chroot on arm64, bug #774108
		EPYTEST_DESELECT+=(
			numpy/_core/tests/test_cpu_features.py::Test_ARM_Features::test_features
		)
	fi

	case ${ARCH} in
		arm)
			EPYTEST_DESELECT+=(
				# TODO: warnings
				numpy/_core/tests/test_umath.py::TestSpecialFloats::test_unary_spurious_fpexception

				# TODO
				numpy/_core/tests/test_function_base.py::TestLinspace::test_denormal_numbers
				numpy/f2py/tests/test_kind.py::TestKind::test_real
				numpy/f2py/tests/test_kind.py::TestKind::test_quad_precision

				# require too much memory
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[complex128]'
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[float64]'
			)
			;;
		hppa)
			EPYTEST_DESELECT+=(
				# https://bugs.gentoo.org/942689
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype[int]"
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype[float]"
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype_bytes_str_equivalence[datetime64]"
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype_bytes_str_equivalence[timedelta64]"
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype_bytes_str_equivalence[<f]"
				"numpy/_core/tests/test_dtype.py::TestPickling::test_pickle_dtype[dt28]"
				numpy/f2py/tests/test_kind.py::TestKind::test_real
				numpy/f2py/tests/test_kind.py::TestKind::test_quad_precision
				numpy/tests/test_ctypeslib.py::TestAsArray::test_reference_cycles
				numpy/tests/test_ctypeslib.py::TestAsArray::test_segmentation_fault
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_scalar
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_subarray
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_structure
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_structure_aligned
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_union
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_padded_union
			)
			;;
		ppc|x86)
			EPYTEST_DESELECT+=(
				# require too much memory
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[complex128]'
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[float64]'
			)
			;;
	esac

	if [[ ${CHOST} == powerpc64le-* ]]; then
		EPYTEST_DESELECT+=(
			# long double thingy
			numpy/_core/tests/test_scalarprint.py::TestRealScalars::test_ppc64_ibm_double_double128
		)
	fi

	if use big-endian; then
		EPYTEST_DESELECT+=(
			# ppc64 and sparc
			numpy/linalg/tests/test_linalg.py::TestDet::test_generalized_sq_cases
			numpy/linalg/tests/test_linalg.py::TestDet::test_sq_cases
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f77[s1]"
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f77[t1]"
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f90[s1]"
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f90[t1]"
		)
	fi

	if ! has_version -b "~${CATEGORY}/${P}[${PYTHON_USEDEP}]" ; then
		# depends on importing numpy.random from system namespace
		EPYTEST_DESELECT+=(
			'numpy/random/tests/test_extending.py::test_cython'
		)
	fi

	if has_version ">=dev-python/setuptools-74[${PYTHON_USEDEP}]"; then
		# msvccompiler removal
		EPYTEST_DESELECT+=(
			numpy/tests/test_public_api.py::test_all_modules_are_expected_2
			numpy/tests/test_public_api.py::test_api_importable
		)
		EPYTEST_IGNORE+=(
			numpy/distutils/tests/test_mingw32ccompiler.py
			numpy/distutils/tests/test_system_info.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest -p rerunfailures --reruns=5
}

python_install_all() {
	local DOCS=( "CITATION.bib" "LICENSE.txt" "LICENSES_bundled.txt" "README.md" "THANKS.txt" )
	distutils-r1_python_install_all
}

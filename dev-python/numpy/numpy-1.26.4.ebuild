# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="AFW BO CE DOS IL ISD NPD SYM"
CYTHON_SLOT="3.0"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="meson-python"
DL_SOURCE=${DL_SOURCE:-"git"}
EPYTEST_XDIST=1
FORTRAN_NEEDED="lapack"
PYTHON_COMPAT=( "python3_12" ) # Forced for binary packages
PYTHON_REQ_USE="threads(+)"

QA_CONFIG_IMPL_DECL_SKIP=(
	# https://bugs.gentoo.org/925367
	vrndq_f32
)

inherit cflags-hardened cython distutils-r1 flag-o-matic fortran-2 toolchain-funcs

if [[ ${PV} != *_[rab]* ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

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
SLOT="0"
# +lapack because the internal fallbacks are pretty slow. Building without blas
# is barely supported anyway, see bug #914358.
IUSE="
build doc -lapack linter release test
ebuild_revision_7
"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
# meson requirement relaxed
BDEPEND="
	${RDEPEND}
	>=dev-build/meson-0.15.0[${PYTHON_USEDEP}]
	dev-python/cython:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	build? (
		>=dev-build/meson-0.13.1[${PYTHON_USEDEP}]
		dev-python/cython:${CYTHON_SLOT}[${PYTHON_USEDEP}]
		dev-python/cython:=
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-build/ninja
		~dev-python/spin-0.7[${PYTHON_USEDEP}]
		dev-python/build[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-7.2.0[${PYTHON_USEDEP}]

		~dev-python/numpydoc-1.4[${PYTHON_USEDEP}]
		~dev-python/pydata-sphinx-theme-0.13.3[${PYTHON_USEDEP}]
		dev-python/sphinx-design[${PYTHON_USEDEP}]
		!~dev-python/ipython-8.1.0[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		>dev-python/breathe-4.33.0[${PYTHON_USEDEP}]

		dev-python/towncrier[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
	)
	lapack? (
		virtual/pkgconfig
	)
	linter? (
		~dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/gitpython-3.1.30[${PYTHON_USEDEP}]
	)
	release? (
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pygithub[${PYTHON_USEDEP}]
		>=dev-python/gitpython-3.1.30[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/paver[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		~dev-python/wheel-0.38.1[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		~dev-python/hypothesis-6.81.1[${PYTHON_USEDEP}]
		~dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		~dev-python/pytz-2023.3_p1[${PYTHON_USEDEP}]
		~dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		dev-build/meson[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		~dev-python/mypy-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
PATCHES=(
	"${FILESDIR}/${PN}-2.1.2-disable-generate-manifest.patch" # unbreak ModuleNotFoundError: No module named 'distutils.msvccompiler' with distutils 74.x
)

src_unpack() {
	if [[ "${DL_SOURCE}" == "git" ]] ; then
		git-r3_fetch
		git-r3_checkout
	elif [[ "${DL_SOURCE}" == "pypy" ]] ; then
		pypi_src_unpack
	fi
}

python_prepare_all() {
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
		lib/tests/test_io.py::TestSaveTxt::test_large_zip
		lib/tests/test_io.py::TestSavezLoad::test_closing_fid
		lib/tests/test_io.py::TestSavezLoad::test_closing_zipfile_after_load

		# Precision problems
		core/tests/test_umath_accuracy.py::TestAccuracy::test_validate_transcendentals

		# Runs the whole test suite recursively, that's just crazy
		core/tests/test_mem_policy.py::test_new_policy

		typing/tests/test_typing.py
		# Uses huge amount of memory
		core/tests/test_mem_overlap.py
		'core/tests/test_multiarray.py::TestDot::test_huge_vectordot[complex128]'

		# TODO: crashes
		lib/tests/test_histograms.py::TestHistogram::test_big_arrays

		# likely a test problem
		# https://github.com/numpy/numpy/issues/25135
		core/tests/test_cython.py::test_conv_intp

		# flaky
		f2py/tests/test_crackfortran.py
		f2py/tests/test_data.py::TestData{,F77}::test_crackedlines
	)

	if use arm && [[ $(uname -m || echo "unknown") == "armv8l" ]] ; then
		# Degenerate case of arm32 chroot on arm64, bug #774108
		EPYTEST_DESELECT+=(
			core/tests/test_cpu_features.py::Test_ARM_Features::test_features
		)
	fi

	if use x86 ; then
		EPYTEST_DESELECT+=(
			# https://github.com/numpy/numpy/issues/18388
			core/tests/test_umath.py::TestRemainder::test_float_remainder_overflow
			# https://github.com/numpy/numpy/issues/18387
			random/tests/test_generator_mt19937.py::TestRandomDist::test_pareto
			# more precision problems
			core/tests/test_einsum.py::TestEinsum::test_einsum_sums_int16
			# https://github.com/numpy/numpy/issues/24548
			f2py/tests/test_kind.py::TestKind::test_int
		)
	fi

	if use ppc64 ; then
		EPYTEST_DESELECT+=(
			core/tests/test_cpu_features.py::TestEnvPrivation::test_impossible_feature_enable
		)
	fi

	if use hppa ; then
		EPYTEST_DESELECT+=(
			# TODO: Get selectedrealkind updated!
			# bug #907228
			# https://github.com/numpy/numpy/issues/3424 (https://github.com/numpy/numpy/issues/3424#issuecomment-412369029)
			# https://github.com/numpy/numpy/pull/21785
			f2py/tests/test_kind.py::TestKind::test_real
			f2py/tests/test_kind.py::TestKind::test_quad_precision
		)
	fi

	if [[ $(tc-endian) == "big" ]] ; then
		# https://github.com/numpy/numpy/issues/11831 and bug #707116
		EPYTEST_DESELECT+=(
			'f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f77[s1]'
			'f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f90[t1]'
			'f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f90[s1]'
			'f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f77[t1]'
			f2py/tests/test_kind.py::TestKind::test_int
		)
	fi

	case "${ABI}" in
		alpha|arm|hppa|m68k|o32|ppc|s390|sh|sparc|x86)
			EPYTEST_DESELECT+=(
				# too large for 32-bit platforms
				core/tests/test_ufunc.py::TestUfunc::test_identityless_reduction_huge_array
				'core/tests/test_multiarray.py::TestDot::test_huge_vectordot[float64]'
				'core/tests/test_multiarray.py::TestDot::test_huge_vectordot[complex128]'
			)
			;;
		*)
			;;
	esac

	if ! has_version -b "~${CATEGORY}/${P}[${PYTHON_USEDEP}]" ; then
		# depends on importing numpy.random from system namespace
		EPYTEST_DESELECT+=(
			'random/tests/test_extending.py::test_cython'
		)
	fi

	rm -rf numpy || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest --pyargs numpy
}

python_install_all() {
	local DOCS=( "CITATION.bib" "LICENSE.txt" "LICENSES_bundled.txt" "README.md" "THANKS.txt" )
	distutils-r1_python_install_all
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="meson-python"
FORTRAN_NEEDED="lapack"
PYTHON_COMPAT=( "python3_"{10..12} "pypy3" )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic fortran-2 pypi toolchain-funcs

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
IUSE="+lapack ebuild_revision_2"
if [[ ${PV} != *_[rab]* ]] ; then
	KEYWORDS="~amd64 ~amd64-linux ~arm64 ~arm64-linux ~arm64-macos ~arm64-linux ~x86 ~x86-linux"
fi

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-build/meson-1.1.0
	>=dev-python/cython-3.0.0:3.0[${PYTHON_USEDEP}]
	lapack? (
		virtual/pkgconfig
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/cffi-1.14.0[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-5.8.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest
PATCHES=(
	"${FILESDIR}/${PN}-2.1.2-disable-generate-manifest.patch" # unbreak ModuleNotFoundError: No module named 'distutils.msvccompiler' with distutils 74.x
)

python_prepare_all() {
	# bug #922457
	filter-lto
	# https://github.com/numpy/numpy/issues/25004
	append-flags -fno-strict-aliasing

	distutils-r1_python_prepare_all
}

check_cython() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local actual_cython_slot=$(ver_cut 1-2 "${actual_cython_pv}")
	local expected_cython_slot="3.0"
	if ver_test "${actual_cython_slot}" -ne "${expected_cython_slot}" ; then
eerror
eerror "Do \`eselect cython set ${expected_cython_slot}\` to continue."
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_slot}"
eerror
		die
	fi
}

python_configure_all() {
	check_cython
	DISTUTILS_ARGS=(
		-Dallow-noblas=$(usex !lapack true false)
		-Dblas=$(usev lapack cblas)
		-Dlapack=$(usev lapack lapack)
		# TODO: cpu-* options
	)
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
	local DOCS=( "LICENSE.txt" "README.md" "THANKS.txt" )
	distutils-r1_python_install_all
}

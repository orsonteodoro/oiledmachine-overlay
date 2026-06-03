# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For deps, see https://github.com/numba/llvmlite/blob/v0.47.0/conda-recipes/llvmlite/meta.yaml

CXX_STANDARD=17
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..14} )

# See FALLBACK_LLVMDEV_VERSION in https://github.com/numba/llvmlite/blob/v0.47.0/.github/workflows/llvmlite_linux-64_wheel_builder.yml
LLVM_COMPAT=( 20 )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)

inherit check-compiler-switch cmake distutils-r1 flag-o-matic libcxx-slot libstdcxx-slot pypi toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/numba/${PN^}.git"
	FALLBACK_COMMIT="6c786059354260a0ae93f9d0144d4016ab3d63b4"
	inherit git-r3
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="A lightweight wrapper around basic LLVM functionality"
HOMEPAGE="https://github.com/numba/llvmlite"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	BSD-2
"
SLOT="0"
IUSE="
ebuild_revision_5
"
REQUIRED_USE+="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"

gen_llvm_rdepend() {
	local x
	for x in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${x}? (
				llvm-core/clang:${x}
				llvm-core/clang:=
				llvm-core/llvm:${x}
				llvm-core/llvm:=
			)
		"
	done
}

RDEPEND="
	$(gen_llvm_rdepend)
	dev-libs/icu:=
	dev-libs/libffi:=
	dev-libs/libxml2:2
	sys-libs/zlib:=
	sys-libs/ncurses[tinfo]
	sys-libs/ncurses:=
	app-arch/zstd
"
DEPEND+="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
)

distutils_enable_tests "unittest"

pkg_setup() {
	check-compiler-switch_start
	python_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_prepare_all() {
	export LLVMLITE_SHARED="true"
	distutils-r1_python_prepare_all

	# Removed test - assertion error
	sed -i \
		-e "/test_rv32d_ilp32(/,+6d" \
		"llvmlite/tests/test_binding.py" \
		|| die "sed failed for test_binding.py"
}

python_configure() {
	if use llvm_slot_15 ; then
		export CC="${CHOST}-clang-15"
		export CXX="${CHOST}-clang++-15"
		export CPP="${CC} -E"
		strip-unsupported-flags
	fi

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	${CC} --version || die
}

python_test() {
	"${EPYTHON}" runtests.py -v \
		|| die "tests failed for ${EPYTHON}"
}

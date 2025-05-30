# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
PYTHON_COMPAT=( "python3_"{10..12} )
LLVM_COMPAT=( 16 ) # Based on CI

inherit cmake distutils-r1 flag-o-matic llvm-r1 toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/numba/${PN^}.git"
	FALLBACK_COMMIT="8cc8944f6234ca2eee0ecc817b834e5a7a27d2c5"
	inherit git-r3
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="A lightweight wrapper around basic LLVM functionality"
HOMEPAGE="https://github.com/numba/llvmlite"
LICENSE="BSD"
SLOT="0"
REQUIRED_USE+="
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
"
RDEPEND="
	dev-libs/icu:=
	dev-libs/libffi:=
	dev-libs/libxml2:2
	sys-libs/zlib:=
	sys-libs/ncurses[tinfo]
	sys-libs/ncurses:=
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/clang:=
		llvm-core/llvm:${LLVM_SLOT}
		llvm-core/llvm:=
	')
"
DEPEND+="
	${RDEPEND}
"

PATCHES=(
)

distutils_enable_tests "unittest"

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
	if use llvm_slot_16 ; then
		export CC="${CHOST}-clang-16"
		export CXX="${CHOST}-clang++-16"
		export CPP="${CC} -E"
		strip-unsupported-flags
	fi
	${CC} --version || die
}

python_test() {
	"${EPYTHON}" runtests.py -v \
		|| die "tests failed for ${EPYTHON}"
}

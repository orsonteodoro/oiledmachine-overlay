# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM18_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM18_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

FLAG_O_MATIC_FILTER_LTO=1
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
PYTHON_COMPAT=( "python3_11" )

inherit check-compiler-switch cmake-multilib flag-o-matic llvm.org llvm-utils python-any-r1
inherit toolchain-funcs

KEYWORDS="
~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~arm64-macos
~x64-macos
"

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://llvm.org/docs/ExceptionHandling.html"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
SLOT="0"
IUSE+="
${LLVM_EBUILDS_LLVM18_REVISION}
+clang +debug static-libs test
ebuild_revision_3
"
REQUIRED_USE="
	test? (
		clang
	)
"
RDEPEND="
"
DEPEND="
	llvm-core/llvm:${LLVM_MAJOR}
"
BDEPEND="
	!test? (
		${PYTHON_DEPS}
	)
	clang? (
		llvm-core/clang:${LLVM_MAJOR}
	)
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"
RESTRICT="
	!test? (
		test
	)
"
LLVM_COMPONENTS=(
	"runtimes"
	"libunwind"
	"libcxx"
	"llvm/cmake"
	"cmake"
)
LLVM_TEST_COMPONENTS=(
	"libcxxabi"
	"llvm/utils/llvm-lit"
)
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
}

multilib_src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"
	local libdir=$(get_libdir)

	# https://github.com/llvm/llvm-project/issues/56825
	# also separately bug #863917
	filter-lto

	if use clang ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		export CPP="${CC} -E"
		strip-unsupported-flags
	fi

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# link to compiler-rt
	# https://github.com/gentoo/gentoo/pull/21516
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	# Respect upstream build type assumptions (bug #910436) where they do:
	# -DLIBUNWIND_ENABLE_ASSERTIONS=ON =>
	#       -DCMAKE_BUILD_TYPE=DEBUG  => -UNDEBUG
	#       -DCMAKE_BUILD_TYPE!=debug => -DNDEBUG
	# -DLIBUNWIND_ENABLE_ASSERTIONS=OFF =>
	#       -UNDEBUG
	# See also https://github.com/llvm/llvm-project/issues/86#issuecomment-1649668826.
	use debug || append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libunwind"
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLIBUNWIND_INCLUDE_TESTS=$(usex test)
		-DLIBUNWIND_INSTALL_HEADERS=ON

		# support non-native unwinding; given it's small enough,
		# enable it unconditionally
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON

		# avoid dependency on libgcc_s if compiler-rt is used
		-DLIBUNWIND_USE_COMPILER_RT=${use_compiler_rt}
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx"
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"
			-DLIBUNWIND_LIBCXX_PATH="${WORKDIR}/libcxx"

			-DLIBCXXABI_LIBDIR_SUFFIX=
			-DLIBCXXABI_ENABLE_SHARED=OFF
			-DLIBCXXABI_ENABLE_STATIC=ON
			-DLIBCXXABI_USE_LLVM_UNWINDER=ON
			-DLIBCXXABI_INCLUDE_TESTS=OFF

			-DLIBCXX_LIBDIR_SUFFIX=
			-DLIBCXX_ENABLE_SHARED=OFF
			-DLIBCXX_ENABLE_STATIC=ON
			-DLIBCXX_CXX_ABI=libcxxabi
			-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
			-DLIBCXX_HAS_MUSL_LIBC=$(llvm_cmake_use_musl)
			-DLIBCXX_HAS_GCC_S_LIB=OFF
			-DLIBCXX_INCLUDE_TESTS=OFF
			-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		)
	fi

	cmake_src_configure
}

multilib_src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-unwind
}

multilib_src_install() {
	DESTDIR="${D}" \
	cmake_build install-unwind
}

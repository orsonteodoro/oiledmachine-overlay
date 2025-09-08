# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Last update:  2024-10-23

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM20_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM20_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

PYTHON_COMPAT=( "python3_12" )

inherit check-compiler-switch cmake-multilib crossdev flag-o-matic llvm.org llvm-utils python-any-r1
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
${LLVM_EBUILDS_LLVM20_REVISION}
+clang debug static-libs test
ebuild_revision_6
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
		llvm-core/clang-linker-config:${LLVM_MAJOR}
		llvm-runtimes/clang-rtlib-config:${LLVM_MAJOR}
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
	"libc"
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

test_compiler() {
	target_is_not_host && return
	local compiler=${1}
	shift
	${compiler} ${CFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

multilib_src_configure() {
	if use clang ; then
		llvm_prepend_path -b "${LLVM_MAJOR}"
	fi
	local libdir=$(get_libdir)

	# https://github.com/llvm/llvm-project/issues/56825
	# also separately bug #863917
	filter-lto

	if use clang ; then
		local -x CC="${CTARGET}-clang-${LLVM_MAJOR}"
		local -x CXX="${CTARGET}-clang++-${LLVM_MAJOR}"
		export CPP="${CC} -E"
		strip-unsupported-flags

		# The full clang configuration might not be ready yet. Use the partial
		# configuration files that are guaranteed to exist even during initial
		# installations and upgrades.
		local flags=(
			--config="${ESYSROOT}"/etc/clang/"${LLVM_MAJOR}"/gentoo-{rtlib,linker}.cfg
		)
		local -x CFLAGS="${CFLAGS} ${flags[@]}"
		local -x CXXFLAGS="${CXXFLAGS} ${flags[@]}"
		local -x LDFLAGS="${LDFLAGS} ${flags[@]}"
	fi

	# Check whether C compiler runtime is available.
	if ! test_compiler "$(tc-getCC)"; then
		local nolib_flags=( -nodefaultlibs -lc )
		if test_compiler "$(tc-getCC)" "${nolib_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${nolib_flags[*]}"
		elif test_compiler "$(tc-getCC)" "${nolib_flags[@]}" -nostartfiles; then
			# Avoiding -nostartfiles earlier on for bug #862540,
			# and set available entry symbol for bug #862798.
			nolib_flags+=( -nostartfiles -e main )
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${nolib_flags[*]}"
		fi
	fi
	# Check whether C++ standard library is available,
	local nostdlib_flags=( -nostdlib++ )
	if ! test_compiler "$(tc-getCXX)" &&
		test_compiler "$(tc-getCXX)" "${nostdlib_flags[@]}"
	then
		local -x LDFLAGS="${LDFLAGS} ${nostdlib_flags[*]}"
		ewarn "${CXX} seems to lack runtime, trying with ${nostdlib_flags[*]}"
	fi

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
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
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DCMAKE_C_COMPILER_TARGET="${CTARGET}"
		-DCMAKE_CXX_COMPILER_TARGET="${CTARGET}"
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
	if is_crosspkg; then
		mycmakeargs+=(
			# Without this, the compiler will compile a test program
			# and fail due to no builtins.
			-DCMAKE_C_COMPILER_WORKS=1
			-DCMAKE_CXX_COMPILER_WORKS=1
			# Install inside the cross sysroot.
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/${CTARGET}/usr"
		)
	fi
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

# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]/llvm_slot_}
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM21_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM21_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

CFLAGS_HARDENED_USE_CASES="multhreaded-confiential network p2p sandbox security-critical server web-browser web-server"
CXX_STANDARD=23
PYTHON_COMPAT=( "python3_"{13..14} )

inherit cflags-hardened check-compiler-switch cmake-multilib crossdev flag-o-matic libcxx-slot libstdcxx-slot llvm.org llvm-utils python-any-r1 toolchain-funcs

LLVM_MAX_SLOT="${LLVM_MAJOR}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos"

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
SLOT="0"
IUSE+="
${LLVM_EBUILDS_LLVM21_REVISION}
clang +static-libs test
ebuild_revision_16
"
# in 15.x, cxxabi.h is moving from libcxx to libcxxabi
RDEPEND="
	!<llvm-runtimes/libcxx-15
"
DEPEND+="
	${RDEPEND}
	llvm-core/llvm:${LLVM_MAJOR}[${LIBSTDCXX_USEDEP_LTS}]
	llvm-core/llvm:=
"
BDEPEND+="
	!test? (
		${PYTHON_DEPS}
	)
	clang? (
		llvm-core/clang:${LLVM_MAJOR}[${LIBSTDCXX_USEDEP_LTS}]
		llvm-core/clang:=
		llvm-core/clang-linker-config:${LLVM_MAJOR}
		llvm-core/clang-linker-config:=
		llvm-runtimes/clang-rtlib-config:${LLVM_MAJOR}
		llvm-runtimes/clang-rtlib-config:=
		llvm-runtimes/clang-unwindlib-config:${LLVM_MAJOR}
		llvm-runtimes/clang-unwindlib-config:=
	)
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"
# Don't strip CFI from .so files
RESTRICT="
	!test? (
		test
	)
	strip
"
S="${WORKDIR}"
PATCHES=(
)
LLVM_COMPONENTS=(
	"runtimes"
	"libcxx"{"abi",""}
	"llvm/cmake"
	"cmake"
)
LLVM_TEST_COMPONENTS=(
	"libc"
	"llvm/include/llvm/"{"Demangle","Testing"}
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
	libcxx-slot_verify
	libstdcxx-slot_verify
}

get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

test_compiler() {
	target_is_not_host && return
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	check-compiler-switch_end
	cflags-hardened_append
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			_configure_abi
		done
	}
	multilib_foreach_abi configure_abi
}

_configure_abi() {
	# Workaround for bgo #961153.
	# TODO: Fix the multilib.eclass, so it sets CTARGET properly.
	if ! is_crosspkg ; then
		export CTARGET="${CHOST}"
	fi

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)

	if tc-is-clang ; then
		if ! has_version "llvm-core/clang:${SLOT_MAJOR}" ; then
eerror "You must emerge clang:${SLOT_MAJOR} to build with clang."
		fi

		llvm_prepend_path -b "${LLVM_MAJOR}"
		local -x CC="${CTARGET}-clang-${LLVM_MAJOR}"
		local -x CXX="${CTARGET}-clang++-${LLVM_MAJOR}"
		export CPP="${CC} -E"
		strip-unsupported-flags

	#
	# The full clang configuration might not be ready yet.  Use the partial
	# configuration of components that libunwind depends on.
	#
		local flags=(
			--config="${ESYSROOT}"/etc/clang/"${LLVM_MAJOR}"/gentoo-{rtlib,unwindlib,linker}.cfg
		)
		local -x CFLAGS="${CFLAGS} ${flags[@]}"
		local -x CXXFLAGS="${CXXFLAGS} ${flags[@]}"
		local -x LDFLAGS="${LDFLAGS} ${flags[@]}"
	fi

	local nostdlib_flags=( -nostdlib++ )
	if ! test_compiler && test_compiler "${nostdlib_flags[@]}"; then
		local -x LDFLAGS="${LDFLAGS} ${nostdlib_flags[*]}"
		ewarn "${CXX} seems to lack stdlib, trying with ${nostdlib_flags[*]}"
	fi

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# Link compiler-rt
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == "compiler-rt" ]] && use_compiler_rt=ON

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DCMAKE_CXX_COMPILER_TARGET="${CTARGET}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		#
		#
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DLIBCXXABI_USE_COMPILER_RT=${use_compiler_rt}

	# Upstream is omitting standard search path for this
	# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}/usr/include"
	# This is broken with standalone builds, and also meaningless
		-DLIBCXXABI_USE_LLVM_UNWINDER=OFF

		#
		#
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(llvm_cmake_use_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
		-DLIBCXX_HARDENING_MODE=extensive
	)

	if [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DLIBCXXABI_ENABLE_SHARED=OFF
			-DLIBCXXABI_ENABLE_STATIC=ON
			-DLIBCXX_ENABLE_SHARED=OFF
			-DLIBCXX_ENABLE_STATIC=ON
		)
	else
		mycmakeargs+=(
			-DLIBCXXABI_ENABLE_SHARED=ON
			-DLIBCXXABI_ENABLE_STATIC=OFF
			-DLIBCXX_ENABLE_SHARED=ON
			-DLIBCXX_ENABLE_STATIC=OFF
		)
	fi

	if is_crosspkg ; then
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
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	cmake_src_configure
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_build cxxabi
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			local -x LIT_PRESERVES_TMP=1
			cmake_build check-cxxabi
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			DESTDIR="${D}" cmake_build install-cxxabi
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	insinto /usr/include/libcxxabi
	doins -r "${WORKDIR}"/libcxxabi/include/.
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, hardened-flags-patch

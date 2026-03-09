# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
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
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM17_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM17_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX23[@]}
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)"

LLVM_COMPONENTS=(
	"runtimes"
	"libcxx"{"","abi"}
	"llvm/"{"cmake","utils/llvm-lit"}
	"cmake"
)

CFLAGS_HARDENED_USE_CASES="casual-messaging credentials crypto dss multithreaded-confedential network p2p sandbox secure-messaging security-critical server sensitive-data untrusted-data web-browser web-server"
CMAKE_ECLASS="cmake"
CXX_STANDARD=23
LLVM_MAX_SLOT="${PV%%.*}"
PYTHON_COMPAT=( "python3_"{12..14} )

inherit check-compiler-switch cflags-hardened cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot llvm llvm.org python-any-r1 toolchain-funcs

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos"
SRC_URI+="
https://github.com/llvm/llvm-project/commit/ef843c8271027b89419d07ffc2aaa3abf91438ef.patch
	-> libcxx-commit-ef843c8.patch
"

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE+="
${LLVM_EBUILDS_LLVM17_REVISION}
clang +libcxxabi +static-libs test +threads
ebuild_revision_19
"
RDEPEND="
	!libcxxabi? (
		>=sys-devel/gcc-4.7[cxx]
		sys-devel/gcc:=
	)
	libcxxabi? (
		~llvm-runtimes/libcxxabi-${PV}[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},static-libs?]
		llvm-runtimes/libcxxabi:=
	)
"
DEPEND="
	${RDEPEND}
	llvm-core/llvm:${LLVM_MAJOR}[${LIBSTDCXX_USEDEP_LTS}]
	llvm-core/llvm:=
"
BDEPEND+="
	dev-util/patchutils
	sys-devel/gcc
	clang? (
		llvm-core/clang:${LLVM_MAJOR}[${LIBSTDCXX_USEDEP_LTS}]
		llvm-core/clang:=
	)
	test? (
		$(python_gen_any_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
		>=dev-build/cmake-3.16
		>=llvm-core/clang-3.9.0[${LIBSTDCXX_USEDEP_LTS}]
		llvm-core/clang:=
		dev-debug/gdb[python]
	)
"
PATCHES=(
)
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

test_compiler() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c++ - \
		<<<'int main() { return 0; }' &>/dev/null
}

get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

pkg_setup() {
	check-compiler-switch_start

	# Darwin Prefix builds do not have llvm installed yet, so rely on
	# bootstrap-prefix to set the appropriate path vars to LLVM instead
	# of using llvm_pkg_setup.
	if [[ "${CHOST}" != *"-darwin"* ]] || has_version "llvm-core/llvm" ; then
		LLVM_MAX_SLOT=${LLVM_MAJOR} \
		llvm_pkg_setup
	fi

	python-any-r1_pkg_setup

	if ! use libcxxabi && ! tc-is-gcc ; then
eerror
eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
eerror "and try again."
eerror
		die
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	check-compiler-switch_end
	cflags-hardened_append
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# note: we need to do this before multilib kicks in since it will
	# alter the CHOST
	local cxxabi cxxabi_incs
	if use libcxxabi; then
		cxxabi=system-libcxxabi
		cxxabi_incs="${EPREFIX}/usr/include/c++/v1"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
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
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)

	if tc-is-clang ; then
		if ! has_version "llvm-core/clang:${PV%%.*}" ; then
eerror "You must emerge clang:${PV%%.*} to build with clang."
		fi
		export CC="${CHOST}-clang-${PV%%.*}"
		export CXX="${CHOST}-clang++-${PV%%.*}"
		export CPP="${CC} -E"
		strip-unsupported-flags
	fi

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# link to compiler-rt
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	# bootstrap: cmake is unhappy if compiler can't link to stdlib
	local nolib_flags=( -nodefaultlibs -lc )
	if ! test_compiler; then
		if test_compiler "${nolib_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CXX} seems to lack runtime, trying with ${nolib_flags[*]}"
		fi
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}"
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
	# We're using our own mechanism for generating linker scripts.
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_ENABLE_THREADS=$(usex threads)
		-DLIBCXX_HARDENING_MODE=hardened
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_USE_COMPILER_RT=${use_compiler_rt}
		-DLLVM_ENABLE_RUNTIMES=libcxx
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if [[ "${lib_type}" == "static" ]] ; then
		mycmakeargs+=(
			-DLIBCXX_ENABLE_SHARED=OFF
			-DLIBCXX_ENABLE_STATIC=ON
		)
	else
		mycmakeargs+=(
			-DLIBCXX_ENABLE_SHARED=ON
			-DLIBCXX_ENABLE_STATIC=OFF
		)
	fi

	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		[[ -n "${clang_path}" ]] || die "Unable to find ${CHOST}-clang for tests"

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
			cmake_src_compile
			if [[ "${CHOST}" != *"-darwin"* ]] ; then
				gen_shared_ldscript
				use static-libs && gen_static_ldscript
			fi
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
			cmake_build "check-cxx"
		done
	}
	multilib_foreach_abi test_abi
}

# Usage: deps
gen_ldscript() {
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	cat <<-END_LDSCRIPT
/* GNU ld script
   Include missing dependencies
*/
${output_format}
GROUP ( $@ )
END_LDSCRIPT
}

gen_static_ldscript() {
	# Move it first.
	mv "lib/libc++"{"","_static"}".a" || die
	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps=(
		"libc++_static.a"
		$(usex libcxxabi "libc++abi.a" "libsupc++.a")
	)
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=( "libpthread.a" "libdl.a" )

	gen_ldscript "${deps[*]}" > "lib/libc++.a" || die
}

gen_shared_ldscript() {
	# Move it first.
	mv "lib/libc++"{"","_shared"}".so" || die
	local deps=(
		"libc++_shared.so"
	# libsupc++ doesn't have a shared version.
		$(usex libcxxabi "libc++abi.so" "libsupc++.a")
	)

	gen_ldscript "${deps[*]}" > "lib/libc++.so" || die
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
	# Since we've replaced libc++.{a,so} with ldscripts, we have to
	# install the extra symlinks.
			if [[ "${CHOST}" != *"-darwin"* ]] ; then
				dolib.so "lib/libc++_shared.so"
				use static-libs && dolib.a "lib/libc++_static.a"
			fi
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

pkg_postinst() {
einfo
einfo "This package (${PN}) is mainly intended as a replacement for the C++"
einfo "standard library when using clang."
einfo "To use it, instead of libstdc++, use:"
einfo "    clang++ -stdlib=libc++"
einfo "to compile your C++ programs."
einfo
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, hardened-flags-patch

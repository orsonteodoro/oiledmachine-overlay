# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{7..9} )
inherit cmake-multilib flag-o-matic llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv x86 ~x64-macos"
IUSE="elibc_glibc elibc_musl +libcxxabi +libunwind static-libs test"
IUSE+=" cfi cfi-cast cfi-icall cfi-vcall clang full-relro lto noexecstack shadowcallstack ssp"
REQUIRED_USE="libunwind? ( libcxxabi )"
REQUIRED_USE+="
	cfi? ( clang lto static-libs )
	cfi-cast? ( clang lto cfi-vcall static-libs )
	cfi-icall? ( clang lto cfi-vcall static-libs )
	cfi-vcall? ( clang lto static-libs )"
RESTRICT="!test? ( test )"

RDEPEND="
	libcxxabi? ( ~sys-libs/libcxxabi-${PV}[cfi?,cfi-cast?,cfi-icall?,cfi-vcall?,full-relro?,noexecstack?,shadowcallstack?,ssp?,libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	!libcxxabi? ( >=sys-devel/gcc-4.7:=[cxx] )"
DEPEND="${RDEPEND}"

_seq() {
	local min=${1}
	local max=${2}
	local i=${min}
	while (( ${i} <= ${max} )) ; do
		echo "${i}"
		i=$(( ${i} + 1 ))
	done
}

gen_cfi_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[cfi]
		)
		     "
	done
}

gen_shadowcallstack_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*[shadowcallstack?]
		)
		     "
	done
}

gen_lto_bdepend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP}]
			>=sys-devel/lld-${v}
		)
		"
	done
}

BDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-cast? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-icall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-vcall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" clang? ( || ( $(gen_lto_bdepend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+="
	test? (
		>=dev-util/cmake-3.16
		>=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)"

DOCS=( CREDITS.TXT )
PATCHES=( "${FILESDIR}/libcxx-13.0.0.9999-cfi.patch" )
S="${WORKDIR}"

LLVM_COMPONENTS=( libcxx{,abi} llvm/{cmake/modules,utils/llvm-lit} )
LLVM_PATCHSET=12.0.0-1
llvm.org_set_globals

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# Darwin Prefix builds do not have llvm installed yet, so rely on
	# bootstrap-prefix to set the appropriate path vars to LLVM instead
	# of using llvm_pkg_setup.
	if [[ ${CHOST} != *-darwin* ]] || has_version dev-lang/llvm; then
		llvm_pkg_setup
	fi
	use test && python-any-r1_pkg_setup

	if ! use libcxxabi && ! tc-is-gcc ; then
		eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
		eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
		eerror "and try again."
		die
	fi
}

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

src_prepare() {
	# Known failures.
	rm test/libcxx/gdb/gdb_pretty_printer_test.sh.cpp || die
	rm test/libcxx/memory/trivial_abi/unique_ptr_ret.pass.cpp || die
	rm test/libcxx/memory/trivial_abi/weak_ptr_ret.pass.cpp || die

	llvm.org_src_prepare
}

test_compiler() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c++ - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	# note: we need to do this before multilib kicks in since it will
	# alter the CHOST
	local cxxabi cxxabi_incs
	if use libcxxabi; then
		cxxabi=libcxxabi
		cxxabi_incs="${EPREFIX}/usr/include/libcxxabi"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	configure_abi() {
		for build_type in $(get_build_types) ; do
			export BUILD_DIR="${S}.${ABI}_${build_type/-*}_build"
			_configure_abi
		done
	}
	multilib_foreach_abi configure_abi
}

_configure_abi() {
	if use clang ; then
		CC="clang $(get_abi_CFLAGS ${ABI})"
		CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		NM=llvm-nm
		AR=llvm-ar
		READELF=llvm-readelf
		AS=llvm-as
		LD="${CC}"
	fi
	if tc-is-clang && ! use clang ; then
		die "You must enable the clang USE flag or remove clang/clang++ from CC/CXX."
	fi

	export CC CXX AR AS NM RANDLIB READELF LD

	if tc-is-clang ; then
		filter-flags -fprefetch-loop-arrays \
			'-fopt-info*' \
			-frename-registers \
			'-mindirect-branch=*' \
			-mindirect-branch-register
	fi
	filter-flags '-flto*' '-fuse-ld=*'

	# we want -lgcc_s for unwinder, and for compiler runtime when using
	# gcc, clang with gcc runtime (or any unknown compiler)
	local extra_libs=() want_gcc_s=ON want_compiler_rt=OFF
	if use libunwind; then
		# work-around missing -lunwind upstream
		extra_libs+=( -lunwind )
		# if we're using libunwind and clang with compiler-rt, we want
		# to link to compiler-rt instead of -lgcc_s
		if tc-is-clang; then
			local compiler_rt=$($(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
			   ${LDFLAGS} -print-libgcc-file-name)
			if [[ ${compiler_rt} == *libclang_rt* ]]; then
				want_gcc_s=OFF
				want_compiler_rt=ON
				extra_libs+=( "${compiler_rt}" )
			fi
		fi
	elif [[ ${CHOST} == *-darwin* ]] && tc-is-clang; then
		# clang-based darwin prefix disables libunwind useflag during
		# bootstrap, because libunwind is not in the prefix yet.
		# override the default, though, because clang based libcxx
		# should never use gcc_s on Darwin.
		want_gcc_s=OFF
		# compiler_rt is not available in EPREFIX during bootstrap,
		# so we cannot link to it yet anyway, so keep the defaults
		# of want_compiler_rt=OFF and extra_libs=()
	fi

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
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		# we're using our own mechanism for generating linker scripts
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=${want_gcc_s}
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_USE_COMPILER_RT=${want_compiler_rt}
		-DLIBCXX_HAS_ATOMIC_LIB=${want_gcc_s}
		-DCMAKE_SHARED_LINKER_FLAGS="${extra_libs[*]} ${LDFLAGS}"
		-DLTO=$(usex lto)
		-DNOEXECSTACK=$(usex noexecstack)
	)

	if tc-is-gcc && gcc --version | grep -q -e "Hardened" ; then
		# Already done by hardened gcc
		:;
	elif tc-is-clang && clang --version | grep -q -e "Hardened:" ; then
		# Some already done by hardened clang
		mycmakeargs+=(
			-DSHADOW_CALL_STACK=$(usex shadowcallstack)
		)
		if [[ "${build_type}" == "static-libs" ]] ; then
			mycmakeargs+=(
				-DCFI=$(usex cfi)
				-DCFI_CAST=$(usex cfi-cast)
				-DCFI_ICALL=OFF
				-DCFI_VCALL=$(usex cfi-vcall)
			)
		fi
	else
		mycmakeargs+=(
			-DFULL_RELRO=$(usex full-relro)
			-DSSP=$(usex ssp)
		)
		if tc-is-clang ; then
			mycmakeargs+=(
				-DSHADOW_CALL_STACK=$(usex shadowcallstack)
			)
			if [[ "${build_type}" == "static-libs" ]] ; then
				mycmakeargs+=(
					-DCFI=$(usex cfi)
					-DCFI_CAST=$(usex cfi-cast)
					-DCFI_ICALL=OFF
					-DCFI_VCALL=$(usex cfi-vcall)
				)
			fi
		fi
	fi
	if [[ "${build_type}" == "static-libs" ]] ; then
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
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags);--param=cxx_under_test=${clang_path}"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	cmake_src_configure
}

src_compile() {
	compile_abi() {
		for build_type in $(get_build_types) ; do
			export BUILD_DIR="${S}.${ABI}_${build_type/-*}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		for build_type in $(get_build_types) ; do
			export BUILD_DIR="${S}.${ABI}_${build_type/-*}_build"
			cd "${BUILD_DIR}" || die
			local -x LIT_PRESERVES_TMP=1
			cmake_build check-cxx
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
	local libdir=$(get_libdir)
	local cxxabi_lib=$(usex libcxxabi "libc++abi.a" "libsupc++.a")

	# Move it first.
	mv "${ED}/usr/${libdir}/libc++.a" "${ED}/usr/${libdir}/libc++_static.a" || die
	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps="libc++_static.a ${cxxabi_lib} $(usex libunwind libunwind.a libgcc_eh.a)"
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=" libpthread.a libdl.a"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.a" || die
}

gen_shared_ldscript() {
	local libdir=$(get_libdir)
	# libsupc++ doesn't have a shared version
	local cxxabi_lib=$(usex libcxxabi "libc++abi.so" "libsupc++.a")

	mv "${ED}/usr/${libdir}/libc++.so" "${ED}/usr/${libdir}/libc++_shared.so" || die
	local deps="libc++_shared.so ${cxxabi_lib} $(usex libunwind libunwind.so libgcc_s.so)"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.so" || die
}

src_install() {
	install_abi() {
		for build_type in $(get_build_types) ; do
			export BUILD_DIR="${S}.${ABI}_${build_type/-*}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
			if [[ ${CHOST} != *-darwin* ]] ; then
				if [[ "${build_type}" == "static-libs" ]] ; then
					gen_static_ldscript
				else
					gen_shared_ldscript
				fi
			fi
		done
	}
	multilib_foreach_abi install_abi
}

pkg_postinst() {
elog "This package (${PN}) is mainly intended as a replacement for the C++"
elog "standard library when using clang."
elog "To use it, instead of libstdc++, use:"
elog "    clang++ -stdlib=libc++"
elog "to compile your C++ programs."
	if [[ "${USE}" =~ "cfi" ]] ; then
ewarn
ewarn "cfi, cfi-cast, cfi-icall, cfi-vcall require static linking of this"
ewarn "library."
ewarn
ewarn "If you do \`ldd <path to exe>\` and you still see libc++.so"
ewarn "then it breaks the CFI runtime protection spec as if that scheme of CFI"
ewarn "was never used.  For details, see"
ewarn "https://clang.llvm.org/docs/ControlFlowIntegrity.html with"
ewarn "\"statically linked\" keyword search."
ewarn
	fi
}

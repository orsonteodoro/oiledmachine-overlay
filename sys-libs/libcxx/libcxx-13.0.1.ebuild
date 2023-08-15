# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake-multilib flag-o-matic llvm llvm.org python-any-r1 toolchain-funcs
LLVM_MAX_SLOT=${LLVM_MAJOR}

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		UoI-NCSA
		MIT
	)
"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv x86 ~x64-macos"
IUSE="
+libcxxabi +libunwind +static-libs test

hardened r11
"
REQUIRED_USE="
	libunwind? (
		libcxxabi
	)
"
RDEPEND="
	!libcxxabi? (
		>=sys-devel/gcc-4.7:=[cxx]
	)
	libcxxabi? (
		~sys-libs/libcxxabi-${PV}:=[${MULTILIB_USEDEP},hardened?,libunwind=,static-libs?]
	)
"
DEPEND="
	${RDEPEND}
	sys-devel/llvm:${LLVM_MAJOR}
"
BDEPEND+="
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
		>=dev-util/cmake-3.16
		>=sys-devel/clang-3.9.0
		sys-devel/gdb[python]
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
	"${FILESDIR}/libcxx-13.0.0.9999-hardened.patch"
)
DOCS=( CREDITS.TXT )
LLVM_COMPONENTS=(
	"libcxx"{,"abi"}
	"llvm/"{"cmake","utils/llvm-lit"}
)
LLVM_PATCHSET="${PV/_/-}"
llvm.org_set_globals

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# Darwin Prefix builds do not have llvm installed yet, so rely on
	# bootstrap-prefix to set the appropriate path vars to LLVM instead
	# of using llvm_pkg_setup.
	if [[ ${CHOST} != *-darwin* ]] || has_version sys-devel/llvm; then
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

test_compiler() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c++ - \
		<<<'int main() { return 0; }' &>/dev/null
}

get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

has_sanitizer_option() {
	local needle="${1}"
	for haystack in $(echo "${CFLAGS}" \
		| grep -E -e "-fsanitize=[a-z,]+( |$)" \
		| sed -e "s|-fsanitize||g" | tr "," "\n") ; do
		[[ "${haystack}" == "${needle}" ]] && return 0
	done
	return 1
}

HAVE_FLAG_CFI="0"
WANTS_CFI=0
_usex_cfi() {
	local s=$(clang-major-version)
	if tc-is-clang \
		&& has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& [[ "${HAVE_FLAG_CFI}" == "1" ]] ; then
		WANTS_CFI=1
		echo "ON"
	else
		echo "OFF"
	fi
}

HAVE_FLAG_CFI_CAST="0"
_usex_cfi_cast() {
	local s=$(clang-major-version)
	if tc-is-clang \
		&& has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& [[ "${HAVE_CFI_CAST}" == "1" ]] ; then
		WANTS_CFI=1
		echo "ON"
	else
		echo "OFF"
	fi
}

HAVE_FLAG_CFI_ICALL="0"
_usex_cfi_icall() {
	local s=$(clang-major-version)
	if tc-is-clang \
		&& has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& [[ "${HAVE_FLAG_CFI_ICALL}" == "1" ]] ; then
		WANTS_CFI=1
		echo "ON"
	else
		echo "OFF"
	fi
}

HAVE_FLAG_CFI_VCALL="0"
_usex_cfi_vcall() {
	local s=$(clang-major-version)
	if tc-is-clang \
		&& has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& [[ "${HAVE_FLAG_CFI_VCALL}" == "1" ]] ; then
		WANTS_CFI=1
		echo "ON"
	else
		echo "OFF"
	fi
}

HAVE_FLAG_CFI_CROSS_DSO="0"
WANTS_CFI_CROSS_DSO=0
_usex_cfi_cross_dso() {
	local s=$(clang-major-version)
	if tc-is-clang \
		&& has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& [[ "${HAVE_FLAG_CFI_CROSS_DSO}" == "1" ]] ; then
		WANTS_CFI_CROSS_DSO=1
		echo "ON"
	else
		echo "OFF"
	fi
}

HAVE_FLAG_SHADOW_CALL_STACK="0"
_usex_shadowcallstack() {
	local s=$(clang-major-version)
	if tc-is-clang \
		&& has_version "=sys-libs/compiler-rt-sanitizers-${s}*[shadowcallstack]" \
		&& [[ "${HAVE_FLAG_SHADOW_CALL_STACK}" == "1" ]] ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

HAVE_FLAG_LTO="0"
WANTS_LTO=0
_usex_lto() {
	if [[ "${HAVE_FLAG_LTO}" == "1" ]] ; then
		WANTS_LTO=1
		echo "ON"
	else
		echo "OFF"
	fi
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

	is-flagq '-flto*' && HAVE_FLAG_LTO="1"
	has_sanitizer_option "cfi-icall" && HAVE_FLAG_CFI_ICALL="1"
	has_sanitizer_option "cfi-vcall" && HAVE_FLAG_CFI_VCALL="1"
	has_sanitizer_option "shadow-call-stack" && HAVE_FLAG_SHADOW_CALL_STACK="1"
	is-flagq '-fsanitize-cfi-cross-dso' && HAVE_FLAG_CFI_CROSS_DSO="1"
	( \
		   has_sanitizer_option "cfi-derived-cast" \
		|| has_sanitizer_option "cfi-unrelated-cast" \
	) \
		&& HAVE_FLAG_CFI_CAST="1"

	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			_configure_abi
		done
	}
	multilib_foreach_abi configure_abi
}

is_hardened_clang() {
	if tc-is-clang && clang --version 2>/dev/null | grep -q -e "Hardened:" ; then
		return 0
	fi
	return 1
}

is_hardened_gcc() {
	if tc-is-gcc && gcc --version 2>/dev/null | grep -q -e "Hardened" ; then
		return 0
	fi
	return 1
}

is_cfi_supported() {
	[[ "${USE}" =~ "cfi" ]] || return 1
	if [[ "${lib_type}" == "static" ]] ; then
		return 0
	elif is-flagq '-fsanitize-cfi-cross-dso' && [[ "${lib_type}" == "shared" ]] ; then
		return 0
	fi
	return 1
}

_configure_abi() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)

	if tc-is-clang ; then
		if ! has_version "sys-devel/clang:${SLOT_MAJOR}" ; then
eerror
eerror "You must emerge clang:${SLOT_MAJOR} to build with clang."
eerror
		fi
		export CC="${CHOST}-clang-${SLOT_MAJOR}"
		export CXX="${CHOST}-clang++-${SLOT_MAJOR}"
		strip-unsupported-flags
	fi

einfo
einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"
einfo

	local _lto=$(_usex_lto)
	local _cfi=$(_usex_cfi)
	local _cfi_cast=$(_usex_cfi_cast)
	local _cfi_icall=$(_usex_cfi_icall)
	local _cfi_vcall=$(_usex_cfi_vcall)
	local _cross_dso_cfi=$(_usex_cfi_cross_dso)
	local _shadowcallstack=$(_usex_shadowcallstack)

	filter-flags \
		'--param=ssp-buffer-size=*' \
		'-f*sanitize*' \
		'-f*stack*' \
		'-f*visibility*' \
		'-flto*' \
		'-fsplit-lto-unit' \
		'-fuse-ld=*' \
		'-lubsan' \
		'-Wl,-lubsan' \
		'-Wl,-z,noexecstack' \
		'-Wl,-z,now' \
		'-Wl,-z,relro'

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
		#
		#
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		# we're using our own mechanism for generating linker scripts
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=${want_gcc_s}
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_USE_COMPILER_RT=${want_compiler_rt}
		-DLIBCXX_HAS_ATOMIC_LIB=${want_gcc_s}
		-DLIBCXX_TARGET_TRIPLE="${CHOST}"
		-DCMAKE_SHARED_LINKER_FLAGS="${extra_libs[*]} ${LDFLAGS}"

		-DLTO=${_lto}
		-DNOEXECSTACK=$(usex hardened)
	)

	set_cfi() {
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
		# cfi-icall breaks icu/genrb
		if tc-is-clang && is_cfi_supported ; then
			mycmakeargs+=(
				-DCFI=${_cfi}
				-DCFI_CAST=${_cfi_cast}
				-DCFI_EXCEPTIONS="-fno-sanitize=cfi-icall"
				-DCFI_ICALL=OFF
				-DCFI_VCALL=${_cfi_vcall}
				-DCROSS_DSO_CFI=${_cfi_cross_dso}
			)
		fi
		mycmakeargs+=(
			-DSHADOW_CALL_STACK=${_shadowcallstack}
		)
	}

	if is_hardened_gcc ; then
		:;
	elif is_hardened_clang ; then
		set_cfi
	else
		set_cfi
		if use hardened ; then
			mycmakeargs+=(
				-DFULL_RELRO=$(usex hardened)
				-DSSP=$(usex hardened)
			)
			if [[ -n "${USE_HARDENED_PROFILE_DEFAULTS}" \
				&& "${USE_HARDENED_PROFILE_DEFAULTS}" == "1" ]] ; then
				mycmakeargs+=(
					-DFORTIFY_SOURCE=2
					-DSTACK_CLASH_PROTECTION=ON
					-DSSP_LEVEL="strong"
				)
			else
				mycmakeargs+=(
					-DSSP_LEVEL="weak"
				)
			fi
		fi
	fi

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
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags);--param=cxx_under_test=${clang_path}"
			-DLIBCXX_LINK_TESTS_WITH_SHARED_LIBCXXABI=ON
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
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
			if [[ ${CHOST} != *-darwin* ]] ; then
				gen_shared_ldscript
				use static-libs && gen_static_ldscript
			fi
		done
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

	if (( ${WANTS_CFI_CROSS_DSO} == 1 )) ; then
ewarn
ewarn "Using cfi-cross-dso requires a rebuild of the app with only the clang"
ewarn "compiler."
ewarn
	fi

	if (( ${WANTS_CFI} == 1 )) && use static-libs ; then
ewarn
ewarn "Using cfi with static-libs requires the app be built with only the clang"
ewarn "compiler."
ewarn
	fi

	if (( ${WANTS_LTO} == 1 )) && use static-libs ; then
		if tc-is-clang ; then
ewarn
ewarn "You are only allowed to static link this library with clang."
ewarn
		elif tc-is-gcc ; then
ewarn
ewarn "You are only allowed to static link this library with gcc."
ewarn
		else
ewarn
ewarn "You are only allowed to static link this library with CC=${CC}"
ewarn "CXX=${CXX}."
ewarn
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, hardened-flags-patch

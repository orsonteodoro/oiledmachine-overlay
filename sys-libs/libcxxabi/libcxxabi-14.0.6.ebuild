# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{9..11} )
inherit cmake-multilib llvm llvm.org python-any-r1 toolchain-funcs
# llvm-6 for new lit options
LLVM_MAX_SLOT=${LLVM_MAJOR}

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		UoI-NCSA
		MIT
	)
"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv sparc x86 ~x64-macos"
IUSE="
+libunwind +static-libs test

hardened r9
"
RDEPEND="
	libunwind? (
		|| (
			>=sys-libs/libunwind-1.0.1-r1[${MULTILIB_USEDEP},static-libs?]
			>=sys-libs/llvm-libunwind-3.9.0-r1[${MULTILIB_USEDEP},static-libs?]
		)
	)
"
DEPEND+="
	${RDEPEND}
	sys-devel/llvm:${LLVM_MAJOR}
"
BDEPEND+="
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
		>=sys-devel/clang-3.9.0
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
	"${FILESDIR}/libcxxabi-15.0.0.9999-hardened.patch"
	"${FILESDIR}/libcxx-13.0.0.9999-hardened.patch"
)
LLVM_COMPONENTS=(
	"runtimes"
	"libcxx"{"abi",}
	"llvm/cmake"
	"cmake"
)
LLVM_TEST_COMPONENTS=(
	"llvm/utils/llvm-lit"
)
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# darwin prefix builds do not have llvm installed yet, so rely on bootstrap-prefix
	# to set the appropriate path vars to LLVM instead of using llvm_pkg_setup.
	if [[ ${CHOST} != *-darwin* ]] || has_version sys-devel/llvm; then
		llvm_pkg_setup
	fi
	python-any-r1_pkg_setup
}

get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
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

src_configure() {
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

is_cfi_supported() {
	[[ "${USE}" =~ "cfi" ]] || return 1
	if [[ "${lib_type}" == "static" ]] ; then
		return 0
	elif is-flagq '-fsanitize-cfi-cross-dso' && [[ "${lib_type}" == "shared" ]] ; then
		return 0
	fi
	return 1
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

	# link against compiler-rt instead of libgcc if we are using clang with libunwind
	local want_compiler_rt=OFF
	if use libunwind && [[ $(tc-get-c-rtlib) == compiler-rt ]]; then
		want_compiler_rt=ON
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		#
		#
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		#
		-DLIBCXXABI_USE_COMPILER_RT=${want_compiler_rt}

		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		-DLIBCXXABI_TARGET_TRIPLE="${CHOST}"

		-DLIBCXX_LIBDIR_SUFFIX=
		#
		#
		-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${WORKDIR}"/libcxxabi/include
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
		-DLIBCXX_TARGET_TRIPLE="${CHOST}"

		-DLTO=${_lto}
		-DNOEXECSTACK=$(usex hardened)
	)

	set_cfi() {
		if tc-is-clang && is_cfi_supported ; then
			mycmakeargs+=(
				-DCFI=${_cfi}
				-DCFI_CAST=${_cfi_cast}
				-DCFI_ICALL=${_cfi_icall}
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
			-DLIBCXXABI_ENABLE_SHARED=OFF
			-DLIBCXXABI_ENABLE_STATIC=ON
			-DLIBCXXABI_USE_LLVM_UNWINDER=OFF
			-DLIBCXX_ENABLE_SHARED=OFF
			-DLIBCXX_ENABLE_STATIC=ON
		)
	else
		mycmakeargs+=(
			-DLIBCXXABI_ENABLE_SHARED=ON
			-DLIBCXXABI_ENABLE_STATIC=OFF
			-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
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

pkg_postinst() {
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

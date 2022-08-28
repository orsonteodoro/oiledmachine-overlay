# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake-multilib llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"
LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv ~x86 ~x64-macos"
IUSE="+libunwind static-libs test"
IUSE+=" hardened"
RDEPEND="
	libunwind? (
		|| (
			>=sys-libs/libunwind-1.0.1-r1[static-libs?,${MULTILIB_USEDEP}]
			>=sys-libs/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
		)
	)
"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	test? (
		>=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"
S="${WORKDIR}"
RESTRICT="!test? ( test )"
# Don't strip CFI from .so files
RESTRICT+=" strip"
PATCHES=(
	"${FILESDIR}/libcxxabi-13.0.0.9999-hardened.patch"
	"${FILESDIR}/libcxx-13.0.0.9999-hardened.patch"
)

LLVM_COMPONENTS=( libcxx{abi,} llvm/cmake )
llvm.org_set_globals

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# darwin prefix builds do not have llvm installed yet, so rely on bootstrap-prefix
	# to set the appropriate path vars to LLVM instead of using llvm_pkg_setup.
	if [[ ${CHOST} != *-darwin* ]] || has_version dev-lang/llvm; then
		llvm_pkg_setup
	fi
	use test && python-any-r1_pkg_setup
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
	configure_abi() {
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

_usex_cfi() {
	local s=$(clang-major-version)
	if has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& has_sanitizer_option "cfi" ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

_usex_cfi_cast() {
	local s=$(clang-major-version)
	if has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& ( \
			has_sanitizer_option "cfi-derived-cast" \
			|| has_sanitizer_option "cfi-unrelated-cast" \
		) ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

_usex_cfi_icall() {
	local s=$(clang-major-version)
	if has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& has_sanitizer_option "cfi-icall" ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

_usex_cfi_vcall() {
	local s=$(clang-major-version)
	if has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& has_sanitizer_option "cfi-vcall" ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

_usex_cfi_cross_dso() {
	local s=$(clang-major-version)
	if has_version "=sys-libs/compiler-rt-sanitizers-${s}*[cfi]" \
		&& is-flagq '-fsanitize-cfi-cross-dso' ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

_usex_shadowcallstack() {
	local s=$(clang-major-version)
	if has_version "=sys-libs/compiler-rt-sanitizers-${s}*[shadowcallstack]" \
		&& has_sanitizer_option "shadow-call-stack" ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

_usex_lto() {
	if is-flagq '-flto*' ; then
		echo "ON"
	else
		echo "OFF"
	fi
}

_configure_abi() {
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

	# we need a configured libc++ for __config_site
	wrap_libcxx cmake_src_configure
	wrap_libcxx cmake_build generate-cxx-headers

	# link against compiler-rt instead of libgcc if we are using clang with libunwind
	local want_compiler_rt=OFF
	if use libunwind && tc-is-clang; then
		local compiler_rt=$($(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
			${LDFLAGS} -print-libgcc-file-name)
		if [[ ${compiler_rt} == *libclang_rt* ]]; then
			want_compiler_rt=ON
		fi
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DLIBCXXABI_USE_COMPILER_RT=${want_compiler_rt}
		-DLIBCXXABI_LIBCXX_INCLUDES="${BUILD_DIR}"/libcxx/include/c++/v1
		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		-DLIBCXXABI_TARGET_TRIPLE="${CHOST}"
		-DLTO=$(_usex_lto)
		-DNOEXECSTACK=$(usex hardened)
	)

	set_cfi() {
		if tc-is-clang && is_cfi_supported ; then
			mycmakeargs+=(
				-DCFI=$(_usex_cfi)
				-DCFI_CAST=$(_usex_cfi_cast)
				-DCFI_ICALL=$(_usex_cfi_icall)
				-DCFI_VCALL=$(_usex_cfi_vcall)
				-DCROSS_DSO_CFI=$(_usex_cfi_cross_dso)
			)
		fi
		mycmakeargs+=(
			-DSHADOW_CALL_STACK=$(_usex_shadowcallstack)
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
		)
	else
		mycmakeargs+=(
			-DLIBCXXABI_ENABLE_SHARED=ON
			-DLIBCXXABI_ENABLE_STATIC=OFF
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

wrap_libcxx() {
	local -x LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/$(get_libdir)"
	local CMAKE_USE_DIR=${WORKDIR}/libcxx
	local BUILD_DIR=${BUILD_DIR}/libcxx
	local mycmakeargs=(
		-DLIBCXX_LIBDIR_SUFFIX=
		-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${S}"/include
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
		-DLIBCXX_TARGET_TRIPLE="${CHOST}"
		-DLTO=$(_usex_lto)
		-DNOEXECSTACK=$(usex hardened)
	)

	set_cfi() {
		if tc-is-clang && is_cfi_supported ; then
			mycmakeargs+=(
				-DCFI=$(_usex_cfi)
				-DCFI_CAST=$(_usex_cfi_cast)
				-DCFI_ICALL=OFF
				-DCFI_EXCEPTIONS="-fno-sanitize=cfi-icall"
				-DCFI_VCALL=$(_usex_cfi_vcall)
				-DCROSS_DSO_CFI=$(_usex_cfi_cross_dso)
			)
		fi
		mycmakeargs+=(
			-DSHADOW_CALL_STACK=$(_usex_shadowcallstack)
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

	"${@}"
}

src_compile() {
	compile_abi() {
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
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			wrap_libcxx cmake_src_compile
			mv "${BUILD_DIR}"/libcxx/lib/libc++* "${BUILD_DIR}/$(get_libdir)/" || die
			local -x LIT_PRESERVES_TMP=1
			cmake_build check-cxxabi
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
		done
	}
	multilib_foreach_abi install_abi

	cd "${S}" || die
	insinto /usr/include/libcxxabi
	doins -r include/.
}

pkg_postinst() {
	if is-flagq '-fsanitize-cfi-cross-dso' ; then
ewarn
ewarn "Using cfi-cross-dso requires a rebuild of the app with only the clang"
ewarn "compiler."
ewarn
	fi

	if [[ "${USE}" =~ "cfi" ]] && use static-libs ; then
ewarn
ewarn "Using cfi with static-libs requires the app be built with only the clang"
ewarn "compiler."
ewarn
	fi

	if use lto && use static-libs ; then
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

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit autotools flag-o-matic llvm multilib-minimal python-any-r1 toolchain-funcs

DESCRIPTION="International Components for Unicode"
HOMEPAGE="http://site.icu-project.org/"
SRC_URI="https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz"

LICENSE="BSD"

SLOT="0/${PV}"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="debug doc examples static-libs"
IUSE+=" cfi cfi-cross-dso cfi-cast cfi-icall cfi-vcall clang hardened libcxx lto shadowcallstack"
REQUIRED_USE="
	cfi? ( clang lto )
	cfi-cast? ( clang lto cfi-vcall )
	cfi-cross-dso? ( || ( cfi cfi-vcall ) )
	cfi-icall? ( clang lto cfi-vcall )
	cfi-vcall? ( clang lto )
	shadowcallstack? ( clang )"

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
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*:=[cfi]
			cfi-cross-dso? ( sys-devel/clang:${v}[${MULTILIB_USEDEP},experimental] )
		)
		     "
	done
}

gen_shadowcallstack_bdepend() {
	local min=${1}
	local max=${2}
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/clang:${v}[${MULTILIB_USEDEP}]
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			=sys-devel/clang-runtime-${v}*[${MULTILIB_USEDEP},compiler-rt,sanitize]
			>=sys-devel/lld-${v}
			=sys-libs/compiler-rt-${v}*
			=sys-libs/compiler-rt-sanitizers-${v}*:=[shadowcallstack?]
		)
		     "
	done
}

gen_lto_bdepend() {
	local min=${1}
	local max=${2}
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

gen_libcxx_depend() {
	local min=${1}
	local max=${2}
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			libcxx? ( >=sys-libs/libcxx-${v}:=[cfi?,cfi-cast?,cfi-cross-dso?,cfi-icall?,cfi-vcall?,clang?,hardened?,shadowcallstack?,${MULTILIB_USEDEP}] )
		)
		"
	done
}

RDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
DEPEND+=" ${RDEPEND}"

BDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-cast? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-icall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-vcall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" clang? ( || ( $(gen_lto_bdepend 10 14) ) )"
BDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+=" ${PYTHON_DEPS}
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	doc? ( app-doc/doxygen[dot] )
"

S="${WORKDIR}/${PN}/source"
S_orig="${WORKDIR}/${PN}/source"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/icu-config
)

PATCHES=(
	"${FILESDIR}/${PN}-65.1-remove-bashisms.patch"
	"${FILESDIR}/${PN}-64.2-darwin.patch"
	"${FILESDIR}/${PN}-68.1-nonunicode.patch"
	"${FILESDIR}/${PN}-69.1-extra-so-flags.patch"
)

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

src_prepare() {
	default

	local variable

	# Disable renaming as it is stupid thing to do
	sed -i \
		-e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" \
		common/unicode/uconfig.h || die

	# Fix linking of icudata
	sed -i \
		-e "s:LDFLAGSICUDT=-nodefaultlibs -nostdlib:LDFLAGSICUDT=:" \
		config/mh-linux || die

	# Append doxygen configuration to configure
	sed -i \
		-e 's:icudefs.mk :icudefs.mk Doxyfile :' \
		configure.ac || die

	if is_hardened_clang || is_hardened_gcc ; then
		:; # Already applied by default
	elif use hardened ; then
		eapply "${FILESDIR}/icu-69.1-pie.patch"
	fi

	if [[ "${USE}" =~ "cfi" ]] && ! use cfi-cross-dso ; then
		eapply "${FILESDIR}/icu-69.1-static-build.patch"
	fi

	eautoreconf

	prepare_abi() {
		for build_type in $(get_build_types) ; do
			einfo "Build type is ${build_type}"
			export S="${S_orig}.${ABI}_${build_type/-*}"
			einfo "Copying to ${S}"
			cp -a "${S_orig}" "${S}" || die
		done
	}
	multilib_foreach_abi prepare_abi
}

append_all() {
	append-flags ${@}
	append-ldflags ${@}
}

append_lto() {
	filter-flags '-flto*' '-fuse-ld=*'
	if tc-is-clang ; then
		append-flags -flto=thin
		append-ldflags -fuse-ld=lld -flto=thin
		append-flags -fsplit-lto-unit
	else
		append-flags -flto
		append-ldflags -flto
	fi
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
	append-cxxflags -std=c++14

	if tc-is-cross-compiler; then
		mkdir "${WORKDIR}"/host || die
		pushd "${WORKDIR}"/host >/dev/null || die

		CFLAGS="" CXXFLAGS="" ASFLAGS="" LDFLAGS="" \
		CC="$(tc-getBUILD_CC)" CXX="$(tc-getBUILD_CXX)" AR="$(tc-getBUILD_AR)" \
		RANLIB="$(tc-getBUILD_RANLIB)" LD="$(tc-getBUILD_LD)" \
		"${S}"/configure --disable-renaming --disable-debug \
			--disable-samples --enable-static || die
		emake

		popd >/dev/null || die
	fi

	configure_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_configure_abi
		done
	}
	multilib_foreach_abi configure_abi
}

is_cfi_supported() {
	[[ "${USE}" =~ "cfi" ]] || return 1
	if [[ "${build_type}" == "static-libs" ]] ; then
		return 0
	elif use cfi-cross-dso && [[ "${build_type}" == "shared-libs" ]] ; then
		return 0
	fi
	return 1
}

_configure_abi() {
	if use clang ; then
		CC="clang $(get_abi_CFLAGS ${ABI})"
		CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		AR=llvm-ar
		AS=llvm-as
		NM=llvm-nm
		RANLIB=llvm-ranlib
		READELF=llvm-readelf
		LD="${CC}"
	fi
	if tc-is-clang && ! use clang ; then
		die "You must enable the clang USE flag or remove clang/clang++ from CC/CXX."
	fi

	export CC CXX AR AS NM RANDLIB READELF LD

	filter-flags \
		'--param=ssp-buffer-size=*' \
		'-f*sanitize*' \
		'-f*stack*' \
		'-fvisibility=*' \
		-DU_STATIC_IMPLEMENTATION \
		-Wl,-z,noexecstack \
		-Wl,-z,now \
		-Wl,-z,relro \
		-stdlib=libc++

	autofix_flags

	if tc-is-clang && use libcxx ; then
		if [[ "${USE}" =~ "cfi" && "${build_type}" == "static-libs" ]] ; then
			has_version "sys-libs/libcxx[cfi,static-libs]" \
				&& append-cxxflags -stdlib=libc++
			append-cxxflags \
				-Wno-unused-command-line-argument
			append-cppflags -DDHAVE_DLOPEN=0 -DU_DISABLE_RENAMING=1 -DU_STATIC_IMPLEMENTATION
		fi
		if [[ "${USE}" =~ "cfi" && "${build_type}" == "static-libs" ]] ; then
			has_version "sys-libs/libcxx[cfi,static-libs]" \
				&& append-ldflags -stdlib=libc++
			append-ldflags \
				-Wno-unused-command-line-argument # Passes through clang++
		fi
		append-ldflags -stdlib=libc++
	elif ! tc-is-clang && use libcxx ; then
		die "libcxx requires clang++"
	fi

	set_cfi() {
		if tc-is-clang && is_cfi_supported ; then
			if [[ "${build_type}" == "static-libs" ]] ; then
				append_all -fvisibility=hidden
			elif use cfi-cross-dso && [[ "${build_type}" == "shared-libs" ]] ; then
				append_all -fvisibility=default
			fi
			if use cfi ; then
				append_all -fsanitize=cfi
			else
				use cfi-cast && append_all \
							-fsanitize=cfi-derived-cast \
							-fsanitize=cfi-unrelated-cast
				use cfi-icall && append_all \
							-fsanitize=cfi-icall
				use cfi-vcall && append_all \
							-fsanitize=cfi-vcall
			fi
			if use cfi-cross-dso \
				&& [[ "${build_type}" == "shared-libs" ]] ; then
				# setting -fsanitize-cfi-cross-dso for cflags breaks keepassx
				export ESHAREDLIBCFLAGS="-fsanitize-cfi-cross-dso"
				export ESHAREDLIBCXXFLAGS="-fsanitize-cfi-cross-dso"
				export ELD_SOOPTIONS="-fsanitize-cfi-cross-dso"
			else
				export ESHAREDLIBCFLAGS=""
				export ESHAREDLIBCXXFLAGS=""
				export ELD_SOOPTIONS=""
			fi
		fi
		use shadowcallstack && append-flags -fno-sanitize=safe-stack \
						-fsanitize=shadow-call-stack
	}

	use hardened && append-ldflags -Wl,-z,noexecstack
	use lto && append_lto
	if is_hardened_gcc ; then
		:;
	elif is_hardened_clang ; then
		set_cfi
	else
		set_cfi
		if use hardened ; then
			append-ldflags -Wl,-z,relro -Wl,-z,now
			if [[ -n "${USE_HARDENED_PROFILE_DEFAULTS}" \
				&& "${USE_HARDENED_PROFILE_DEFAULTS}" == "1" ]] ; then
				append-cppflags -D_FORTIFY_SOURCE=2
				append-flags $(test-flags-CC -fstack-clash-protection)
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector-strong
			else
				append-flags --param=ssp-buffer-size=4 \
						-fstack-protector
			fi
		fi
	fi

	local myeconfargs=(
		--disable-renaming
		--disable-samples
		--disable-layoutex
		$(use_enable debug)
		$(multilib_native_use_enable examples samples)
	)

	if [[ "${build_type}" == "static-libs" ]] ; then
		myeconfargs+=(
			--enable-static
			--disable-dyload
			--disable-shared
		)
	else
		myeconfargs+=(
			--disable-static
			--enable-shared
		)
	fi

	if [[ ! ( "${USE}" =~ "cfi" ) ]] ; then
		myeconfargs+=(
			--enable-extras
			--enable-tools
		)
	elif [[ "${build_type}" == "static-libs" ]] ; then
		myeconfargs+=(
			--enable-extras
			--enable-tools
		)
	else
		myeconfargs+=(
			--disable-extras
			--disable-tools
		)
	fi

	tc-is-cross-compiler && myeconfargs+=(
		--with-cross-build="${WORKDIR}"/host
	)

	# work around cross-endian testing failures with LTO #757681
	if tc-is-cross-compiler && is-flagq '-flto*' ; then
		myeconfargs+=( --disable-strict )
	fi

	# icu tries to use clang by default
	tc-export CC CXX

	# make sure we configure with the same shell as we run icu-config
	# with, or ECHO_N, ECHO_T and ECHO_C will be wrongly defined
	export CONFIG_SHELL="${EPREFIX}/bin/sh"
	# probably have no /bin/sh in prefix-chain
	[[ -x ${CONFIG_SHELL} ]] || CONFIG_SHELL="${BASH}"

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_compile() {
	export VERBOSE=1
	compile_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die

			default

			if multilib_is_native_abi && use doc; then
				doxygen -u Doxyfile || die
				doxygen Doxyfile || die
			fi
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			# INTLTEST_OPTS: intltest options
			#   -e: Exhaustive testing
			#   -l: Reporting of memory leaks
			#   -v: Increased verbosity
			# IOTEST_OPTS: iotest options
			#   -e: Exhaustive testing
			#   -v: Increased verbosity
			# CINTLTST_OPTS: cintltst options
			#   -e: Exhaustive testing
			#   -v: Increased verbosity
			emake -j1 VERBOSE="1" check
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			default
			if multilib_is_native_abi && use doc; then
				docinto html
				dodoc -r doc/html/*
			fi
		done
	}
	multilib_foreach_abi install_abi

	einstalldocs
	docinto html
	dodoc ../readme.html
}

pkg_postinst() {
	if use static-libs ; then
ewarn
ewarn "static-lib consumers require -DU_STATIC_IMPLEMENTATION"
ewarn
	fi

	if use cfi-cross-dso ; then
ewarn "Using cfi-cross-dso requires a rebuild of the app with only the clang"
ewarn "compiler."
	fi

	if [[ "${USE}" =~ "cfi" ]] && use static-libs ; then
ewarn "Using cfi with static-libs requires the app be built with only the clang"
ewarn "compiler."
	fi

	if use lto && use static-libs ; then
		if tc-is-clang ; then
ewarn "You are only allowed to static link this library with clang."
		elif tc-is-gcc ; then
ewarn "You are only allowed to static link this library with gcc."
		else
ewarn "You are only allowed to static link this library with CC=${CC}"
ewarn "CXX=${CXX}."
		fi
	fi
}

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
IUSE+=" cfi cfi-vcall cfi-cast cfi-icall full-relro libcxx lto noexecstack shadowcallstack ssp"
REQUIRED_USE="
	cfi? ( lto static-libs )
	cfi-cast? ( lto cfi-vcall static-libs )
	cfi-icall? ( lto cfi-vcall static-libs )
	cfi-vcall? ( lto static-libs )"

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
			=sys-libs/compiler-rt-sanitizers-${v}*[cfi]
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
			=sys-libs/compiler-rt-sanitizers-${v}*[shadowcallstack?]
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
			libcxx? ( >=sys-libs/libcxx-${v}:=[cfi?,cfi-cast?,cfi-icall?,cfi-vcall?,full-relro?,noexecstack?,shadowcallstack?,ssp?,${MULTILIB_USEDEP}] )
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
BDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
BDEPEND+=" lto? ( || ( $(gen_lto_bdepend 11 14) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+=" ${PYTHON_DEPS}
	virtual/pkgconfig
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
		-e 's:icudefs.mk:icudefs.mk Doxyfile:' \
		configure.ac || die

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
	filter-flags '-flto*'
	append-flags -flto=thin
	append-ldflags -fuse-ld=lld -flto=thin
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

_configure_abi() {
	if use lto || use shadowcallstack ; then
		export CC="clang $(get_abi_CFLAGS ${ABI})"
		export CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		export AR=llvm-ar
		export AS=llvm-as
		export NM=llvm-nm
		export RANLIB=llvm-ranlib
		export READELF=llvm-readelf
		export LD="${CC}"
	fi

	filter-flags \
		'-fsanitize=*' \
		'-fvisibility=hidden' \
		--param=ssp-buffer-size=4 \
		-fno-sanitize=safe-stack \
		-fstack-protector \
		-Wl,-z,noexecstack \
		-Wl,-z,now \
		-Wl,-z,relro \
		-stdlib=libc++

	if tc-is-clang ; then
		filter-flags -fprefetch-loop-arrays \
			'-fopt-info*' \
			-frename-registers
	fi

	if tc-is-clang && use libcxx ; then
		append-cxxflags -stdlib=libc++
		append-ldflags -stdlib=libc++
	elif ! tc-is-clang && use libcxx ; then
		die "libcxx requires clang++"
	fi

	if [[ "${build_type}" == "static-libs" ]] ; then
		if use cfi ; then
			append_all -fvisibility=hidden \
					-fsanitize=cfi
		else
			use cfi-cast && append_all -fvisibility=hidden \
						-fsanitize=cfi-derived-cast \
						-fsanitize=cfi-unrelated-cast
			use cfi-icall && append_all -fvisibility=hidden \
						-fsanitize=cfi-icall
			use cfi-vcall && append_all -fvisibility=hidden \
						-fsanitize=cfi-vcall
		fi
	fi
	use lto && append_lto
	use full-relro && append-ldflags -Wl,-z,relro -Wl,-z,now
	use noexecstack && append-ldflags -Wl,-z,noexecstack
	use shadowcallstack && append-flags -fno-sanitize=safe-stack \
					-fsanitize=shadow-call-stack
	use ssp && append-ldflags --param=ssp-buffer-size=4 \
				-fstack-protector

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
			--disable-shared
		)
	else
		myeconfargs+=(
			--disable-static
			--enable-shared
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
	if [[ "${USE}" =~ "cfi" ]] ; then
ewarn
ewarn "cfi, cfi-cast, cfi-icall, cfi-vcall require static linking of this"
ewarn "library."
ewarn
ewarn "If you do \`ldd <path to exe>\` and you still see libicui18n.so"
ewarn "libicuuc.so, libicudata.so, then it breaks the CFI runtime protection"
ewarn "spec as if that scheme of CFI was never used.  For details, see"
ewarn "https://clang.llvm.org/docs/ControlFlowIntegrity.html with"
ewarn "\"statically linked\" keyword search."
ewarn
	fi
}

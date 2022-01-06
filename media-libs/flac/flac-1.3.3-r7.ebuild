# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal toolchain-funcs
inherit autotools

DESCRIPTION="free lossless audio encoder and decoder"
HOMEPAGE="https://xiph.org/flac/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.xz"

LICENSE="BSD FDL-1.2 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cxx debug ogg cpu_flags_ppc_altivec cpu_flags_ppc_vsx cpu_flags_x86_sse static-libs"
IUSE+=" cfi cfi-cast cfi-cross-dso cfi-icall cfi-vcall clang hardened libcxx lto shadowcallstack"
RDEPEND="ogg? ( >=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )"
# Link utilities with CFI Cross-DSO (.so) or CFI Basic Mode (.a)
REQUIRED_USE="
	!cfi-cross-dso? (
		cfi? ( static-libs )
		cfi-cast? ( static-libs )
		cfi-icall? ( static-libs )
		cfi-vcall? ( static-libs )
	)
	cfi? ( clang lto )
	cfi-cast? ( clang lto cfi-vcall )
	cfi-cross-dso? ( || ( cfi cfi-vcall ) )
	cfi-icall? ( clang lto cfi-vcall )
	cfi-vcall? ( clang lto )
"

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
			=sys-libs/compiler-rt-sanitizers-${v}*:=[cfi]
			cfi-cross-dso? ( sys-devel/clang:${v}[${MULTILIB_USEDEP},experimental] )
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
			=sys-libs/compiler-rt-sanitizers-${v}*:=[shadowcallstack?]
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

gen_libcxx_depend() {
	local min=${1}
	local max=${2}
	local v
	for v in $(_seq ${min} ${max}) ; do
		echo "
		(
			sys-devel/llvm:${v}[${MULTILIB_USEDEP}]
			>=sys-libs/libcxx-${v}:=[cfi?,cfi-cast?,cfi-cross-dso?,cfi-icall?,cfi-vcall?,clang?,hardened?,shadowcallstack?,static-libs?,${MULTILIB_USEDEP}]
		)
		"
	done
}

RDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
DEPEND+=" ${RDEPEND}"

BDEPEND+=" clang? ( || ( $(gen_lto_bdepend 11 14) ) )"
BDEPEND+=" cfi? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-cast? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-icall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" cfi-vcall? ( || ( $(gen_cfi_bdepend 12 14) ) )"
BDEPEND+=" libcxx? ( || ( $(gen_libcxx_depend 10 14) ) )"
BDEPEND+=" lto? ( clang? ( || ( $(gen_lto_bdepend 11 14) ) ) )"
BDEPEND+=" shadowcallstack? ( arm64? ( || ( $(gen_shadowcallstack_bdepend 10 14) ) ) )"

BDEPEND+="
	app-arch/xz-utils
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	abi_x86_32? ( dev-lang/nasm )
	!elibc_uclibc? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${P}-fix-zero-first-byte-md5sum-check.patch"
	"${FILESDIR}/${PN}-1.3.3-fPIC.patch"
)
S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"

get_build_types() {
	echo "shared-libs"
	use static-libs && echo "static-libs"
}

src_prepare() {
	default

	if is_hardened_clang || is_hardened_gcc ; then
		:;
	elif use hardened ; then
		eapply "${FILESDIR}/flac-1.3.3-pie.patch"
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
		[[ "${build_type}" == "static-libs" ]] \
			&& append_all -fsplit-lto-unit
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

is_cfi_supported() {
	[[ "${USE}" =~ "cfi" ]] || return 1
	if [[ "${build_type}" == "static-libs" ]] ; then
		return 0
	elif use cfi-cross-dso && [[ "${build_type}" == "shared-libs" ]] ; then
		return 0
	fi
	return 1
}

_src_configure() {
	if use clang ; then
		CC="clang $(get_abi_CFLAGS ${ABI})"
		CXX="clang++ $(get_abi_CFLAGS ${ABI})"
		AR=llvm-ar
		AS=llvm-as
		NM=llvm-nm
		RANLIB=llvm-ranlib
		READELF=llvm-readelf
		unset LD
	fi
	if tc-is-clang && ! use clang ; then
		die "You must enable the clang USE flag or remove clang/clang++ from CC/CXX."
	fi

	export CC CXX AR AS NM RANDLIB READELF LD

	filter-flags \
		'--param=ssp-buffer-size=*' \
		'-DFLAC__USE_VISIBILITY_ATTR' \
		'-f*sanitize*' \
		'-f*stack*' \
		'-f*visibility*' \
		'-fsplit-lto-unit' \
		'-lc++' \
		'-lubsan' \
		'-static-libstdc++' \
		'-stdlib=libc++' \
		'-Wl,-lubsan' \
		'-Wl,-z,noexecstack' \
		'-Wl,-z,now' \
		'-Wl,-z,relro'

	if tc-is-clang && use libcxx && [[ "${USE}" =~ "cfi" ]] ; then
		# The -static-libstdc++ is a misnomer.  It also means \
		# -static-libc++ which does not exist.
		append-cxxflags -stdlib=libc++
                append-ldflags -stdlib=libc++
		[[ "${build_type}" == "shared-libs" ]] \
			&& append-ldflags -lc++
		[[ "${build_type}" == "static-libs" ]] \
			&& append-ldflags -static-libstdc++
	elif ! tc-is-clang && use libcxx ; then
		die "libcxx requires clang++"
	fi

	autofix_flags

	set_cfi() {
		# The cfi enables all cfi schemes, but the selective tries to balance
		# performance and security while maintaining a performance limit.
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
				#use cfi-icall && append_all \
				#			-fsanitize=cfi-icall
				use cfi-vcall && append_all \
							-fsanitize=cfi-vcall
			fi
			[[ "${USE}" =~ "cfi" ]] && append-ldflags -Wl,-lubsan
			use cfi-cross-dso \
				&& [[ "${build_type}" == "shared-libs" ]] \
				&& append_all -fsanitize-cfi-cross-dso
			append_all -fno-sanitize=cfi-icall # cfi-icall breaks CEF with illegal instruction
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
		--disable-doxygen-docs
		--disable-examples
		--disable-xmms-plugin
		$([[ ${CHOST} == *-darwin* ]] && echo "--disable-asm-optimizations")
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_ppc_vsx vsx)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cxx cpplibs)
		$(use_enable debug)
		$(use_enable ogg)

		# cross-compile fix (bug #521446)
		# no effect if ogg support is disabled
		--with-ogg
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

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_configure() {
	configure_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		for build_type in $(get_build_types) ; do
			export S="${S_orig}.${ABI}_${build_type/-*}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			einfo "Running src_compile for ${build_type}"
			emake
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
			if [[ ${UID} != 0 ]]; then
				emake -j1 check
			else
				ewarn "Tests will fail if ran as root, skipping."
			fi
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
			emake DESTDIR="${D}" install
		done
	}
	multilib_foreach_abi install_abi
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
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

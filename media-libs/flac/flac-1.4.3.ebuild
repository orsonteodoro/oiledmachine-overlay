# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs
inherit autotools

DESCRIPTION="free lossless audio encoder and decoder"
HOMEPAGE="https://xiph.org/flac/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.xz"
LICENSE="BSD FDL-1.2 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv
~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris
"
IUSE="
+cxx debug ogg cpu_flags_x86_avx cpu_flags_x86_avx2 static-libs
"
# AVX configure switch is for both AVX & AVX2
REQUIRED_USE="
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
"
RDEPEND="
	ogg? (
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	app-arch/xz-utils
	sys-devel/gettext
	virtual/pkgconfig
	abi_x86_32? (
		dev-lang/nasm
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.4.3-fPIC.patch"
)
S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"

get_lib_types() {
	echo "shared"
	use static-libs && echo "static"
}

src_prepare() {
	default

	# Assumes we are using the hardened toolchain.
	#use hardened && eapply "${FILESDIR}/flac-1.3.3-pie.patch"
	eautoreconf

	prepare_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			einfo "Build type is ${lib_type}"
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
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

has_sanitizer() {
	local option="${1}"
	local xoption
	for xoption in $(echo "${CFLAGS}" \
		| grep -E -e "-fsanitize=[a-z,-]+" \
		| cut -f 2 -d "=" \
		| tr "," "\n") ; do
		[[ "${xoption}" == "${option}" ]] && return 0
	done
	return 1
}

_src_configure() {
	filter-flags -fsanitize=cfi-icall
	if tc-is-clang && has_version "sys-libs/compiler-rt-sanitizers[cfi]" && has_sanitizer "cfi" ; then
		append_all -fno-sanitize=cfi-icall # cfi-icall breaks CEF with illegal instruction
	fi

	local myeconfargs=(
		--disable-doxygen-docs
		--disable-examples
		$([[ ${CHOST} == *-darwin* ]] && echo "--disable-asm-optimizations")
		$(use_enable cpu_flags_x86_avx avx)
		$(use_enable cxx cpplibs)
		$(use_enable ogg)
		$(use_enable debug)

		# cross-compile fix (bug #521446)
		# no effect if ogg support is disabled
		--with-ogg
	)

	if [[ "${lib_type}" == "static" ]] ; then
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
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			einfo "Running src_compile for ${lib_type}"
			emake
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			if [[ ${UID} != 0 ]]; then
	# Parallel tests work for CMake but don't for autotools as of 1.4.3
	# https://github.com/xiph/flac/commit/aaffdcaa969c19aee9dc89be420eae470b55e405
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
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export S="${S_orig}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			export BUILD_DIR="${S}"
			cd "${BUILD_DIR}" || die
			emake DESTDIR="${D}" install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  unbreak-cfi

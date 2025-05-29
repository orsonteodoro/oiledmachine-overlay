# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DF HO IO SO"
LIBFLAC_SONAME="10"
LIBFLACXX_SONAME="12"

inherit autotools cflags-hardened flag-o-matic multilib-minimal toolchain-funcs

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
S="${WORKDIR}/${P}"
S_orig="${WORKDIR}/${P}"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.xz"

DESCRIPTION="free lossless audio encoder and decoder"
HOMEPAGE="https://xiph.org/flac/"
LICENSE="
	BSD
	FDL-1.2
	GPL-2
	LGPL-2.1
"
SLOT="0/${LIBFLAC_SONAME}-${LIBFLACXX_SONAME}"
X86_IUSE="
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
"
IUSE="
${X86_IUSE}
+cxx debug ogg static-libs
ebuild_revision_24
"
# AVX configure switch is for both AVX & AVX2
REQUIRED_USE="
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)
"
RDEPEND="
	ogg? (
		>=media-libs/libogg-1.3.5[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND+="
	>=app-arch/xz-utils-5.2.5
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/gettext-0.21
	virtual/pkgconfig
	abi_x86_32? (
		>=dev-lang/nasm-2.15.05
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.4.3-fPIC.patch"
)

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
	if tc-is-clang && has_version "llvm-runtimes/compiler-rt-sanitizers[cfi]" && has_sanitizer "cfi" ; then
		append_all -fno-sanitize=cfi-icall # cfi-icall breaks CEF with illegal instruction
	fi
	cflags-hardened_append

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

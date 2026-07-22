# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild applies a patch using AI generated code.

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY_LIBARCHIVE="CE DOS HO IO MC NPD OOBA OOBR PT RC UAF UB"

CHKL_TIMESTAMPS=(
	"app-arch/bzip2-9999"
	"app-arch/lz4-9999"
	"app-arch/xz-utils-9999"
	"dev-libs/expat-9999"
	"dev-libs/libxml2-9999"
	"dev-libs/nettle-9999"
	"app-arch/zstd-9999"
)

inherit autotools cflags-hardened chkl libtool multilib-minimal secure-version toolchain-funcs verify-sig

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="f5509ae993ac30417f81acc5118f232ae3f2d27d"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/libarchive/libarchive.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
	https://www.libarchive.de/downloads/${P}.tar.xz
	verify-sig? ( https://www.libarchive.de/downloads/${P}.tar.xz.asc )
	"
fi

DESCRIPTION="Multi-format archive and compression library"
HOMEPAGE="
	https://www.libarchive.org/
	https://github.com/libarchive/libarchive/
"

LICENSE="BSD BSD-2 BSD-4 public-domain"
SOVER="13"
SLOT="0/${SOVER}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE+="
	acl blake2 +bzip2 +e2fsprogs expat +iconv lz4 +lzma lzo nettle
	static-libs test xattr +zstd
	ebuild_revision_23
"
RESTRICT="!test? ( test )"

RDEPEND="
	$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
	>=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]
	acl? ( virtual/acl:*[${MULTILIB_USEDEP}] )
	blake2? ( >=app-crypt/libb2-${LIBB2_PV}:=[${MULTILIB_USEDEP}] )
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:=[${MULTILIB_USEDEP}] )
	expat? ( >=dev-libs/expat-${EXPAT_PV}:=[${MULTILIB_USEDEP}] )
	!expat? ( >=dev-libs/libxml2-${LIBXML2_PV}:=[${MULTILIB_USEDEP}] )
	iconv? ( virtual/libiconv:*[${MULTILIB_USEDEP}] )
	lz4? ( >=app-arch/lz4-${LZ4_PV}:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-${XZ_UTILS_PV}:=[${MULTILIB_USEDEP}] )
	lzo? ( >=dev-libs/lzo-2:=[${MULTILIB_USEDEP}] )
	nettle? ( >=dev-libs/nettle-${NETTLE_PV}:=[${MULTILIB_USEDEP}] )
	zstd? ( >=app-arch/zstd-${ZSTD_PV}:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	kernel_linux? (
		virtual/os-headers:*
		e2fsprogs? ( sys-fs/e2fsprogs:=[${MULTILIB_USEDEP}] )
	)
	test? (
		app-arch/lrzip:=
		>=app-arch/lz4-${LZ4_PV}:=
		app-arch/lzip:=
		app-arch/lzop:=
		>=app-arch/xz-utils-${XZ_UTILS_PV}:=
		>=app-arch/zstd-${ZSTD_PV}:=
		lzma? ( >=app-arch/xz-utils-${XZ_UTILS_PV}:=[extra-filters(+)] )
	)
"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( >=sec-keys/openpgp-keys-libarchive-20221209 )
	elibc_musl? ( sys-libs/queue-standalone )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libarchive.org.asc

# false positives (checks for libc-defined hash functions)
QA_CONFIG_IMPL_DECL_SKIP=(
	SHA256_Init SHA256_Update SHA256_Final
	SHA384_Init SHA384_Update SHA384_Final
	SHA512_Init SHA512_Update SHA512_Final
)

PATCHES=(
	# https://github.com/libarchive/libarchive/issues/2069
	# (we can simply update the command since we don't support old lrzip)
	"${FILESDIR}/${PN}-f5509ae-lrzip.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
	# TODO add verify-sig
		unpack ${A}
	fi
	local actual_sover=$(grep "math.*INTERFACE_VERSION" "${S}/CMakeLists.txt" | head -n 1 | grep -E -o -e "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update the SOVER in the ebuild."
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default

	eautoreconf

	# Needed for flags to be respected w/ LTO
	elibtoolize
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	export ac_cv_header_ext2fs_ext2_fs_h=$(usex e2fsprogs) #354923

	local myconf=(
		$(use_enable acl)
		$(use_enable static-libs static)
		$(use_enable xattr)
		$(use_with blake2 libb2)
		$(use_with bzip2 bz2lib)
		$(use_with expat)
		$(use_with !expat xml2)
		$(use_with iconv)
		$(use_with lz4)
		$(use_with lzma)
		$(use_with lzo lzo2)
		$(use_with nettle)
		--with-zlib
		$(use_with zstd)

		# Windows-specific
		--without-cng
	)
	if multilib_is_native_abi ; then
		myconf+=(
			--enable-bsdcat="$(tc-is-static-only && echo static || echo shared)"
			--enable-bsdcpio="$(tc-is-static-only && echo static || echo shared)"
			--enable-bsdtar="$(tc-is-static-only && echo static || echo shared)"
			--enable-bsdunzip="$(tc-is-static-only && echo static || echo shared)"
		)
	else
		myconf+=(
			--disable-bsdcat
			--disable-bsdcpio
			--disable-bsdtar
			--disable-bsdunzip
		)
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		emake
	else
		emake libarchive.la
	fi
}

src_test() {
	mkdir -p "${T}"/bin || die
	# tests fail when lbzip2[symlink] is used in place of ref bunzip2
	ln -s "${BROOT}/bin/bunzip2" "${T}"/bin || die
	# workaround lrzip broken on 32-bit arches with >= 10 threads
	# https://bugs.gentoo.org/927766
	cat > "${T}"/bin/lrzip <<-EOF || die
		#!/bin/sh
		exec "$(type -P lrzip)" -p1 "\${@}"
	EOF
	chmod +x "${T}/bin/lrzip" || die
	local -x PATH=${T}/bin:${PATH}
	multilib-minimal_src_test
}

multilib_src_test() {
	# sandbox is breaking long symlink behavior
	local -x SANDBOX_ON=0
	local -x LD_PRELOAD=
	# some locales trigger different output that breaks tests
	local -x LC_ALL=C.UTF-8
	emake check
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		emake DESTDIR="${D}" install
	else
		local install_targets=(
			install-includeHEADERS
			install-libLTLIBRARIES
			install-pkgconfigDATA
		)
		emake DESTDIR="${D}" "${install_targets[@]}"
	fi

	# Libs.private: should be used from libarchive.pc instead
	find "${ED}" -type f -name "*.la" -delete || die
	# https://github.com/libarchive/libarchive/issues/1766
	sed -e '/Requires\.private/s:iconv::' \
		-i "${ED}/usr/$(get_libdir)/pkgconfig/libarchive.pc" || die
}

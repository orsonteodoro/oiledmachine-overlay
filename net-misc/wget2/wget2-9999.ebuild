# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="AW CRSH IV MC PT SO"

CHKL_TIMESTAMPS=(
	"app-arch/brotli-9999"
	"app-arch/bzip2-9999"
	"app-arch/xz-utils-9999"
	"dev-libs/libgcrypt-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
	"net-libs/nghttp2-9999"
)

inherit autotools cflags-hardened chkl secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="172b13b0ef52a3b075d6a236207c8d3870a2c415"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.com/gnuwget/wget2.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="FIXME"
fi

DESCRIPTION="GNU Wget2 is a file and recursive website downloader"
HOMEPAGE="https://gitlab.com/gnuwget/wget2"

# LGPL for libwget
LICENSE="GPL-3+ LGPL-3+"
SLOT="0/0" # subslot = libwget.so version
IUSE+="
brotli bzip2 doc +gnutls gpgme +http2 idn lzip lzma nls pcre psl +ssl test xattr zlib
ebuild_revision_1
"

RDEPEND="
	brotli? ( >=app-arch/brotli-${BROTLI_PV}:= )
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:= )
	!gnutls? ( >=dev-libs/libgcrypt-${LIBGCRYPT_PV}:= )
	ssl? (
		gnutls? ( >=net-libs/gnutls-${GNUTLS_PV}:= )
		!gnutls? (
			$(secure-version_gen_openssl_depends)
		)
	)
	gpgme? (
		app-crypt/gpgme:=
		dev-libs/libassuan:=
		dev-libs/libgpg-error:=
	)
	http2? ( >=net-libs/nghttp2-${NGHTTP2_PV}:= )
	idn? ( >=net-dns/libidn2-${LIBIDN2_PV}:= )
	lzip? ( app-arch/lzlib:= )
	lzma? ( >=app-arch/xz-utils-${XZ_UTILS_PV}:= )
	pcre? ( >=dev-libs/libpcre2-${LIBPCRE2_PV}:= )
	psl? ( net-libs/libpsl:= )
	xattr? ( sys-apps/attr:= )
	zlib? ( >=virtual/zlib-${ZLIB_PV}:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lzip
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

RESTRICT="!test? ( test )"
PATCHES=(
	"${FILESDIR}/${PN}-172b13b-compat-for-nettle-live.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		unpack ${A}
	fi

}

src_prepare() {
	default

	local bootstrap_opts=(
		--gnulib-srcdir="${S}/gnulib"
		--no-bootstrap-sync
		--copy
		--no-git
		$(usex nls '' '--skip-po')
	)
	AUTORECONF="/bin/true" \
	LIBTOOLIZE="/bin/true" \
	sh ./bootstrap "${bootstrap_opts[@]}" || die
	eautoreconf
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local myeconfargs=(
		--disable-static
		--disable-valgrind-tests
		--with-plugin-support
		--with-ssl="$(usex ssl $(usex gnutls gnutls openssl) none)"
		--without-libidn
		--without-libmicrohttpd
		$(use_enable doc)
		$(use_enable xattr)
		$(use_with brotli brotlidec)
		$(use_with bzip2)
		$(use_with gpgme)
		$(use_with http2 libnghttp2)
		$(use_with idn libidn2)
		$(use_with lzip)
		$(use_with lzma)
		$(use_with pcre libpcre2)
		$(use_with psl libpsl)
		$(use_with zlib)

		# Avoid calling ldconfig
		LDCONFIG=:
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if [[ ${PV} == *9999 ]] ; then
		if use doc ; then
			local mpage
			for mpage in $(find docs/man -type f -regextype grep -regex ".*\.[[:digit:]]$") ; do
				doman ${mpage}
			done
		fi
	else
		doman docs/man/man{1/*.1,3/*.3}
	fi

	find "${D}" -type f -name '*.la' -delete || die
	rm "${ED}"/usr/bin/${PN}_noinstall || die
}

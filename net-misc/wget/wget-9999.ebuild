# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild fork used AI to partly resolve an issue.

CFLAGS_HARDENED_ASSEMBLERS="gas inline"
CFLAGS_HARDENED_USE_CASES="security-critical system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DOS SO"
PYTHON_COMPAT=( "python3_"{10..13} )
# gnulib FPs \
QA_CONFIG_IMPL_DECL_SKIP=( "unreachable" "MIN" "alignof" "static_assert" "fpurge" )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/wget.asc"

CHKL_TIMESTAMPS=(
	"dev-libs/libpcre2-9999"
	"app-arch/xz-utils-9999"
)

inherit autotools cflags-hardened check-compiler-switch chkl flag-o-matic python-any-r1 secure-version toolchain-funcs unpacker verify-sig

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="705e9e3a749f9f0430c1fad9892227c210c66dee"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://https.git.savannah.gnu.org/git/wget.git"
	if [[ "${PV}" =~ "9999" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="mirror://gnu/wget/${P}.tar.lz"
	SRC_URI+=" verify-sig? ( mirror://gnu/wget/${P}.tar.lz.sig )"
fi

DESCRIPTION="Network utility to retrieve files from the WWW"
HOMEPAGE="https://www.gnu.org/software/wget/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="
~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc
x86 ~arm64-macos ~x64-macos ~x64-solaris
"
IUSE+="
cookie-check debug gnutls idn libproxy metalink nls ntlm pcre +ssl static
test uuid zlib
ebuild_revision_23
"
REQUIRED_USE="
	ntlm? (
		!gnutls
		ssl
	)
	gnutls? (
		ssl
	)
"
RESTRICT="
	!test? (
		test
	)
"

# * Force a newer libidn2 to avoid libunistring deps.  bug #612498
# * Metalink can use gpgme automagically (so let's always depend on it)
#   for signed metalink resources.
LIB_DEPEND="
	cookie-check? (
		net-libs/libpsl
	)
	idn? (
		>=net-dns/libidn2-${LIBIDN2_PV}:=[static-libs(+)]
	)
	libproxy? (
		net-libs/libproxy
	)
	metalink? (
		app-crypt/gpgme:=
		media-libs/libmetalink
	)
	pcre? (
		>=dev-libs/libpcre2-${LIBPCRE2_PV}[static-libs(+)]
	)
	ssl? (
		!gnutls? (
			$(secure-version_gen_openssl_depends '3.0-4.0' '[static-libs(+)]')
		)
		gnutls? (
			>=net-libs/gnutls-${GNUTLS_PV}:=[static-libs(+)]
		)
	)
	uuid? (
		sys-apps/util-linux[static-libs(+)]
	)
	zlib? (
		>=virtual/zlib-${ZLIB_PV}:=[static-libs(+)]
	)
"
RDEPEND="
	!static? (
		${LIB_DEPEND//\[static-libs(+)]}
	)
"
DEPEND="
	${RDEPEND}
	static? (
		${LIB_DEPEND}
	)
"
BDEPEND="
	$(unpacker_src_uri_depends)
	>=app-arch/xz-utils-${XZ_UTILS_PV}
	>=dev-lang/perl-${PERL_PV}
	sys-apps/texinfo
	virtual/pkgconfig
	nls? (
		sys-devel/gettext
	)
	test? (
		${PYTHON_DEPS}
		>=dev-perl/HTTP-Daemon-6.60.0
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-SSL
	)
	verify-sig? (
		>=sec-keys/openpgp-keys-wget-20241111
	)
"

DOCS=( "AUTHORS" "MAILING-LIST" "NEWS" "README" )

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
	# IMO the security is verify-sig pattern is wrong.  If the server is
	# compromised, you are using the attacker controlled signature and
	# attacker controlled tarball.  The both pieces should be indepdenent.
	# The proper way is to have the distro keep the copy of the signature
	# on their server(s).  You cannot have wget devs have the signature
	# because of the possibility of a compromised wget ftp key or
	# compromised wget web infra.
	#
	# The proper fix is to place the verify-sigs (${P}.tar.lz.sig) in
	# the files/${P}.tar.lz.sig folder or in another repo with independent
	# contributors under similiar layout
	# ({CATEGORY}/${PN}/${P}.tar.lz.sig).  If upstream is attacked
	# by supply chain attack, then the sig is not affected.  However if a
	# contributor is working for both upstream and the distro, it is not
	# proper isolation.  The type of vulnerability is maybe improper
	# security design or improper implementation for verify-sig on the
	# distro.
	#
		use verify-sig && verify-sig_verify_detached "${DISTDIR}/${P}.tar.lz"{"",".sig"}
		unpacker "${P}.tar.lz"
	fi
}

src_prepare() {
	default
	if [[ -n "${EVCS_OFFLINE}" ]] && use nls ; then
eerror "The nls USE flag must be disabled for EVCS_OFFLINE=1 to work properly for ${CATEGORY}/${P}."
		die
	fi
	./bootstrap $(usex nls "" "--skip-po") || die
	sed -i -e "s:/usr/local/etc:${EPREFIX}/etc:g" "doc/"{"sample.wgetrc","wget.texi"} || die
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	chkl_check_many_timestamps
	cflags-hardened_append

	# Fix compilation on Solaris, we need filio.h for FIONBIO as used in
	# the included gnutls -- force ioctl.h to include this header
	[[ "${CHOST}" == *"-solaris"* ]] && append-cppflags -DBSD_COMP=1

	if use static ; then
		append-ldflags -static
		tc-export PKG_CONFIG
		PKG_CONFIG+=" --static"
	fi

	# There is no flag that controls this.  libunistring-prefix only
	# controls the search path (which is why we turn it off below).
	# Further, libunistring is only needed w/older libidn2 installs,
	# and since we force the latest, we can force off libunistring. # bug #612498
	local myeconfargs=(
		ac_cv_libunistring="no"
		$(use_enable debug)
		$(use_enable idn iri)
		$(use_enable libproxy)
		$(use_enable nls)
		$(use_enable ntlm)
		$(use_enable pcre pcre2)
		$(use_enable ssl digest)
		$(use_enable ssl opie)
		$(use_with cookie-check libpsl)
		$(use_with metalink)
		$(use_with ssl ssl $(usex gnutls gnutls openssl))
		$(use_with uuid libuuid)
		$(use_with zlib)
		--enable-ipv6
		--disable-assert
		--disable-pcre
		--disable-rpath
		--without-included-libunistring
		--without-libunistring-prefix
	)

	econf "${myeconfargs[@]}"
	if ! use nls ; then
		sed -i -e "s|po gnulib_po util|po util|g" Makefile || die
	fi
}

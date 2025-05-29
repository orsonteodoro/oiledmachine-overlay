# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="pcre2-${PV/_rc/-RC}"

# Breaks /usr/lib64/qt6/libexec/moc
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT="clang gcc"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="security-critical jit sensitive-data untrusted-data"
MULTILIB_CHOST_TOOLS=(
	"/usr/bin/pcre2-config"
)
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/nicholaswilson.asc"

inherit cflags-hardened flag-o-matic libtool multilib multilib-minimal
inherit toolchain-funcs verify-sig

if [[ "${PV}" != *"_rc"* ]] ; then
	KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
	"
fi
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/PCRE2Project/pcre2/releases/download/${MY_P}/${MY_P}.tar.bz2
https://ftp.pcre.org/pub/pcre/${MY_P}.tar.bz2
	verify-sig? (
https://github.com/PCRE2Project/pcre2/releases/download/${MY_P}/${MY_P}.tar.bz2.sig
	)
"

DESCRIPTION="Perl-compatible regular expression library"
HOMEPAGE="https://pcre2project.github.io/pcre2/ https://www.pcre.org/"
LICENSE="BSD"
SLOT="0/3" # libpcre2-posix.so version
IUSE="
bzip2 +jit libedit +pcre16 +pcre32 +readline static-libs unicode valgrind zlib
ebuild_revision_31
"
REQUIRED_USE="
	?? (
		libedit
		readline
	)
"
RDEPEND="
	bzip2? (
		app-arch/bzip2
	)
	libedit? (
		dev-libs/libedit
	)
	readline? (
		sys-libs/readline:=
	)
	zlib? (
		sys-libs/zlib
	)
"
DEPEND="
	${RDEPEND}
	valgrind? (
		dev-debug/valgrind
	)
"
BDEPEND="
	virtual/pkgconfig
	verify-sig? (
		sec-keys/openpgp-keys-nicholaswilson
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-10.10-000-Fix-multilib.patch"
)

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	cflags-hardened_append
	if tc-is-clang && is-flagq "-fsanitize=undefined" ; then
		append-flags "-fno-sanitize=function"
	fi
	local myeconfargs=(
		$(multilib_native_use_enable bzip2 pcre2grep-libbz2)
		$(multilib_native_use_enable libedit pcre2test-libedit)
		$(multilib_native_use_enable readline pcre2test-libreadline)
		$(multilib_native_use_enable valgrind)
		$(multilib_native_use_enable zlib pcre2grep-libz)
		$(use_enable jit)
		$(use_enable jit pcre2grep-jit)
		$(use_enable pcre16 pcre2-16)
		$(use_enable pcre32 pcre2-32)
		$(use_enable static-libs static)
		$(use_enable unicode)
		--enable-pcre2-8
		--enable-shared
	)
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake V=1 $(multilib_is_native_abi || echo "bin_PROGRAMS=")
}

multilib_src_test() {
	emake check VERBOSE="yes"
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		$(multilib_is_native_abi || echo "bin_PROGRAMS= dist_html_DATA=") \
		install

	# bug #934977
	if \
		! tc-is-static-only \
			&& \
		[[ ! -f "${ED}/usr/$(get_libdir)/libpcre2-8$(get_libname)" ]] \
	; then
eerror "Sanity check for libpcre2-8$(get_libname) failed."
eerror "Shared library wasn't built, possible libtool bug"
		if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]] ; then
eerror "libpcre2-8$(get_libname) not found in build, aborting"
			die
		fi
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (10.45, 20250503)
# test-suite gcc:  passed with asan, ubsan
# test-suite clang:  passed with asan, ubsan

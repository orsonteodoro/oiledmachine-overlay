# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# GCC breaks with asan
# CVE-2021-46848:  off-by-one read (ASAN)
CFLAGS_HARDENED_ASSEMBLERS="gas inline"
CFLAGS_HARDENED_CI_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="10"
CFLAGS_HARDENED_LANGS="assembly c-lang"
CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
CFLAGS_HARDENED_SANITIZERS_COMPAT="clang"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="security-critical network system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO DOS NPD SO"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/libtasn1.asc"

inherit cflags-hardened multilib-minimal libtool toolchain-funcs verify-sig

KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"
SRC_URI="
mirror://gnu/${PN}/${P}.tar.gz
	verify-sig? (
mirror://gnu/${PN}/${P}.tar.gz.sig
	)
"

DESCRIPTION="ASN.1 library"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"
LICENSE="LGPL-2.1+"
SLOT="0/6" # subslot = libtasn1 soname version
IUSE="
static-libs test
ebuild_revision_35
"
RESTRICT="
	!test? (
		test
	)
"
BDEPEND="
	app-alternatives/yacc
	sys-apps/help2man
	verify-sig? (
		>=sec-keys/openpgp-keys-libtasn1-20250209
	)
"
DOCS=( "AUTHORS" "ChangeLog" "NEWS" "README.md" "THANKS" )

src_prepare() {
	default
	# For Solaris shared library
	elibtoolize
}

multilib_src_configure() {
	cflags-hardened_append
	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer="no"
	local myeconfargs=(
		--disable-valgrind-tests
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}

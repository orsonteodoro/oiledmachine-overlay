# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="pcre2-${PV/_rc/-RC}"

# Breaks /usr/lib64/qt6/libexec/moc
CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_CI_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="18" # U24
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="13" # U24
CFLAGS_HARDENED_LANGS="asm c-lang"
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT="clang gcc"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="security-critical jit sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS"

# https://pcre2project.github.io/pcre2/project/security/
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/nicholaswilson.asc

inherit autotools cflags-hardened check-compiler-switch dot-a libtool multilib multilib-minimal secure-version toolchain-funcs verify-sig

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="ff92e0b9cea5b5ae3af12ba930d03556684f098b"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
	EGIT_REPO_URI="https://github.com/PCRE2Project/pcre2.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
		https://github.com/PCRE2Project/pcre2/releases/download/${MY_P}/${MY_P}.tar.bz2
		https://ftp.pcre.org/pub/pcre/${MY_P}.tar.bz2
		verify-sig? ( https://github.com/PCRE2Project/pcre2/releases/download/${MY_P}/${MY_P}.tar.bz2.sig )
	"
fi

DESCRIPTION="Perl-compatible regular expression library"
HOMEPAGE="https://pcre2project.github.io/pcre2/ https://www.pcre.org/"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SOVER="3"
SLOT="0/${SOVER}" # libpcre2-posix.so version
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE+="
bzip2 +jit libedit +pcre16 +pcre32 +readline static-libs unicode valgrind zlib
ebuild_revision_13
"
REQUIRED_USE="?? ( libedit readline )"

RDEPEND="
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:= )
	libedit? ( dev-libs/libedit:= )
	readline? ( sys-libs/readline:= )
	zlib? ( >=virtual/zlib-${ZLIB_PV}:= )
"
DEPEND="
	${RDEPEND}
	valgrind? ( dev-debug/valgrind:= )
"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( >=sec-keys/openpgp-keys-nicholaswilson-20250910 )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pcre2-config
)

PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
}

verify_sover() {
	which grep || return
	grep --version || return
	local c=$(grep -e "libpcre2_posix_version" "${S}/configure.ac" | head -n 1 | cut -f 2 -d "[" | sed -r -e "s|[])]||g" | cut -f 1 -d ":")
	local a=$(grep -e "libpcre2_posix_version" "${S}/configure.ac" | head -n 1 | cut -f 2 -d "[" | sed -r -e "s|[])]||g" | cut -f 3 -d ":")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update the SOVER."
eerror "QA:  Actual sover:  ${actual_sover}"
eerror "QA:  Expected sover:  ${expected_sover}"
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	verify_sover
}

src_prepare() {
	default

	eautoreconf
	elibtoolize
}

src_configure() {
	use static-libs && lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append
	if tc-is-clang && is-flagq "-fsanitize=undefined" ; then
	# TODO:  review removal
		append-flags "-fno-sanitize=function"
	fi
	local myeconfargs=(
		--enable-pcre2-8
		--enable-shared
		--disable-symvers # oiledmachine-overlay:  Unbreak webkit-gtk, glib, qtcore
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
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake V=1 $(multilib_is_native_abi || echo "bin_PROGRAMS=")
}

multilib_src_test() {
	emake check VERBOSE=yes
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		$(multilib_is_native_abi || echo "bin_PROGRAMS= dist_html_DATA=") \
		install

	# bug #934977
	if ! tc-is-static-only && [[ ! -f "${ED}/usr/$(get_libdir)/libpcre2-8$(get_libname)" ]] ; then
		eerror "Sanity check for libpcre2-8$(get_libname) failed."
		eerror "Shared library wasn't built, possible libtool bug"
		[[ -z ${I_KNOW_WHAT_I_AM_DOING} ]] && die "libpcre2-8$(get_libname) not found in build, aborting"
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
	strip-lto-bytecode
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 32-bit breaks with asan and ubsan sanitizers on
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="network security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DF HO IO UAF"
#CFLAGS_HARDENED_USE_LLVM_SANITIZERS=1
QA_CONFIG_IMPL_DECL_SKIP=(
	# gnulib FPs
	MIN
	alignof
	static_assert
)
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/gnutls.asc"

inherit autotools cflags-hardened multilib-minimal verify-sig

SRC_URI="
mirror://gnupg/gnutls/v$(ver_cut 1-2)/${P}.tar.xz
	verify-sig? (
mirror://gnupg/gnutls/v$(ver_cut 1-2)/${P}.tar.xz.sig
	)
"

DESCRIPTION="A secure communications library implementing the SSL, TLS and DTLS protocols"
HOMEPAGE="https://www.gnutls.org/"
LICENSE="GPL-3 LGPL-2.1+"
# As of 3.8.0, the C++ library is header-only, but we won't drop the subslot
# component for it until libgnutls.so breaks ABI, to avoid pointless rebuilds.
# Subslot format:
# <libgnutls.so number>.<libgnutlsxx.so number>
SLOT="0/30.30"
KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"
IUSE="
brotli +cxx dane doc examples +idn nls +openssl pkcs11 sslv2 sslv3 static-libs
test test-full +tls-heartbeat tools zlib zstd
ebuild_revision_28
"
REQUIRED_USE="
	test-full? (
		cxx
		dane
		doc
		examples
		idn
		nls
		openssl
		pkcs11
		tls-heartbeat
		tools
	)
"
#RESTRICT="
#	!test? (
#		test
#	)
#"
# >=nettle-3.10 as a workaround for bug #936011
RDEPEND="
	>=dev-libs/libtasn1-4.9:=[${MULTILIB_USEDEP}]
	>=dev-libs/nettle-3.10:=[gmp,${MULTILIB_USEDEP}]
	>=dev-libs/gmp-5.1.3-r1:=[${MULTILIB_USEDEP}]
	dev-libs/libunistring:=[${MULTILIB_USEDEP}]
	brotli? (
		>=app-arch/brotli-1.0.0:=[${MULTILIB_USEDEP}]
	)
	dane? (
		>=net-dns/unbound-1.4.20:=[${MULTILIB_USEDEP}]
	)
	nls? (
		>=virtual/libintl-0-r1:=[${MULTILIB_USEDEP}]
	)
	pkcs11? (
		>=app-crypt/p11-kit-0.23.1[${MULTILIB_USEDEP}]
	)
	idn? (
		>=net-dns/libidn2-0.16-r1:=[${MULTILIB_USEDEP}]
	)
	zlib? (
		sys-libs/zlib[${MULTILIB_USEDEP}]
	)
	zstd? (
		>=app-arch/zstd-1.3.0:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	test-full? (
		sys-libs/libseccomp
	)
"
BDEPEND="
	>=virtual/pkgconfig-0-r1
	dev-build/gtk-doc-am
	doc? (
		dev-util/gtk-doc
	)
	nls? (
		sys-devel/gettext
	)
	test-full? (
		app-crypt/dieharder
		|| (
			sys-libs/libfaketime
			>=app-misc/datefudge-1.22
		)
		dev-libs/softhsm:2[-bindist(-)]
		net-dialup/ppp
		net-misc/socat
	)
	verify-sig? (
		>=sec-keys/openpgp-keys-gnutls-20240415
	)
"
DOCS=( "README.md" "doc/certtool.cfg" )
HTML_DOCS=()

src_prepare() {
	default

	# bug #520818
	export TZ="UTC"

	use doc && HTML_DOCS+=( "doc/gnutls.html" )

	# don't try to use system certificate store on macOS, it is
	# confusingly ignoring our ca-certificates and more importantly
	# fails to compile in certain configurations
	sed -i -e "s/__APPLE__/__NO_APPLE__/" "lib/system/certs.c" || die

	# Use sane .so versioning on FreeBSD.
	#elibtoolize

	# Switch back to elibtoolize after 3.8.7.1
	eautoreconf
}

multilib_src_configure() {
	cflags-hardened_append
	LINGUAS="${LINGUAS//en/en@boldquot en@quot}"

	local libconf=()

	# TPM needs to be tested before being enabled
	# Note that this may add a libltdl dep when enabled. Check configure.ac.
	libconf+=(
		--without-tpm
		--without-tpm2
	)

	# hardware-accel is disabled on OSX because the asm files force
	#   GNU-stack (as doesn't support that) and when that's removed ld
	#   complains about duplicate symbols
	if [[ "${CHOST}" == *"-darwin"* ]] ; then
		libconf+=(
			--disable-hardware-acceleration
		)
	fi

	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer="no"

	local myeconfargs=(
		$(multilib_native_enable manpages)
		$(multilib_native_use_enable doc gtk-doc)
		$(multilib_native_use_enable doc)
		$(multilib_native_use_enable test tests)
		$(multilib_native_use_enable test-full full-test-suite)
		$(multilib_native_use_enable test-full seccomp-tests)
		$(multilib_native_use_enable tools)
		$(use_enable cxx)
		$(use_enable dane libdane)
		$(use_enable nls)
		$(use_enable openssl openssl-compatibility)
		$(use_enable sslv2 ssl2-support)
		$(use_enable sslv3 ssl3-support)
		$(use_enable static-libs static)
		$(use_enable tls-heartbeat heartbeat-support)
		$(use_with brotli '' link)
		$(use_with idn)
		$(use_with pkcs11 p11-kit)
		$(use_with zlib '' link)
		$(use_with zstd '' link)
		--disable-rpath
		--disable-valgrind-tests
		--with-default-trust-store-file="${EPREFIX}/etc/ssl/certs/ca-certificates.crt"
		--with-unbound-root-key-file="${EPREFIX}/etc/dnssec/root-anchors.txt"
		--without-included-libtasn1
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)

	ECONF_SOURCE="${S}" \
	econf "${libconf[@]}" "${myeconfargs[@]}"

	if [[ "${CHOST}" == *"-solaris"* ]] ; then
		# gnulib ends up defining its own pthread_mutexattr_gettype
		# otherwise, which is causing versioning problems
		echo "#define PTHREAD_IN_USE_DETECTION_HARD 1" >> config.h || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
	if use examples; then
		docinto "examples"
		dodoc "doc/examples/"*".c"
	fi
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.8.9, 20250501)

# With asan/ubsan sanitizers (32-bit)
# ============================================================================
# Testsuite summary for GnuTLS 3.8.9
# ============================================================================
# # TOTAL: 201
# # PASS:  180
# # SKIP:  11
# # XFAIL: 0
# # FAIL:  10
# # XPASS: 0
# # ERROR: 0
# ============================================================================

# Without sanitizers (32-bit)
# ============================================================================
# Testsuite summary for GnuTLS 3.8.9
# ============================================================================
# # TOTAL: 201
# # PASS:  192
# # SKIP:  9
# # XFAIL: 0
# # FAIL:  0
# # XPASS: 0
# # ERROR: 0
# ============================================================================

# ASAN only (32-bit)
# ============================================================================
# Testsuite summary for GnuTLS 3.8.9
# ============================================================================
# # TOTAL: 201
# # PASS:  182
# # SKIP:  11
# # XFAIL: 0
# # FAIL:  8
# # XPASS: 0
# # ERROR: 0
# ============================================================================

# Ubsan only (32-bit)
# ============================================================================
# Testsuite summary for GnuTLS 3.8.9
# ============================================================================
# # TOTAL: 201
# # PASS:  187
# # SKIP:  11
# # XFAIL: 0
# # FAIL:  3
# # XPASS: 0
# # ERROR: 0
# ============================================================================

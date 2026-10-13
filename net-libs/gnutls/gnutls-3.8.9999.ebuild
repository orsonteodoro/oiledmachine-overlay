# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild fork uses AI inference for clarification and synthetic data.

# 32-bit breaks with asan and ubsan sanitizers on
CFLAGS_HARDENED_ASSEMBLERS="gas inline"
CFLAGS_HARDENED_CI_SANITIZERS="asan lsan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="14"
CFLAGS_HARDENED_LANGS="asm c-lang"
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="network security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE DF DOS HO IO MC NPD UAF"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnutls.asc

CHKL_TIMESTAMPS=(
	"app-arch/brotli-9999"
	"dev-libs/nettle-9999"
	"app-arch/zstd-9999"
)

inherit autotools cflags-hardened check-compiler-switch chkl libtool multilib-minimal sandbox-changes secure-version verify-sig

DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols"
HOMEPAGE="https://www.gnutls.org/"

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_PV="3.8.13"
	FALLBACK_COMMIT="4e84948a5e89689edbab2c5920db7fc32f31a985"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.com/gnutls/gnutls.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="mirror://gnupg/gnutls/v$(ver_cut 1-2)/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( mirror://gnupg/gnutls/v$(ver_cut 1-2)/${P}.tar.xz.sig )"
fi

LICENSE="GPL-3 LGPL-2.1+"
# As of 3.8.0, the C++ library is header-only, but we won't drop the subslot
# component for it until libgnutls.so breaks ABI, to avoid pointless rebuilds.
# Subslot format:
# <libgnutls.so number>.<libgnutlsxx.so number>
LIBGNUTLS_SOVER="30"
LIBGNUTLSXX_SOVER="30"
SOVER="${LIBGNUTLS_SOVER}.${LIBGNUTLSXX_SOVER}"
SLOT="0/${SOVER}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="brotli +cxx dane doc examples +idn nls +openssl pkcs11 +post-quantum sslv2 sslv3"
IUSE+=" systemtap static-libs test test-full +tls-heartbeat tools zlib zstd"
IUSE+=" ebuild_revision_3"
REQUIRED_USE="test-full? ( cxx dane doc examples idn nls openssl pkcs11 tls-heartbeat tools )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libtasn1-4.9:=[${MULTILIB_USEDEP}]
	dev-libs/libunistring:=[${MULTILIB_USEDEP}]
	>=dev-libs/nettle-${NETTLE_PV}:=[gmp,${MULTILIB_USEDEP}]
	>=dev-libs/gmp-${GMP_PV}:=[${MULTILIB_USEDEP}]
	brotli? ( >=app-arch/brotli-${BROTLI_PV}:=[${MULTILIB_USEDEP}] )
	dane? ( >=net-dns/unbound-1.4.20:=[${MULTILIB_USEDEP}] )
	nls? ( >=virtual/libintl-0-r1:*[${MULTILIB_USEDEP}] )
	pkcs11? ( >=app-crypt/p11-kit-0.23.1[${MULTILIB_USEDEP}] )
	post-quantum? ( >=dev-libs/leancrypto-1.2.0:=[${MULTILIB_USEDEP}] )
	idn? ( >=net-dns/libidn2-${LIBIDN2_PV}:=[${MULTILIB_USEDEP}] )
	zlib? ( >=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}] )
	zstd? ( >=app-arch/zstd-${ZSTD_PV}:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test-full? ( >=sys-libs/libseccomp-${LIBSECCOMP_PV}:= )
	systemtap? ( dev-debug/systemtap:= )
"
BDEPEND="
	dev-build/gtk-doc-am
	>=virtual/pkgconfig-0-r1
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	test-full? (
		app-crypt/dieharder
		|| ( sys-libs/libfaketime >=app-misc/datefudge-1.22 )
		dev-libs/softhsm:2[-bindist(-)]
		net-dialup/ppp
		net-misc/socat
	)
	verify-sig? ( >=sec-keys/openpgp-keys-gnutls-20240415 )
"

DOCS=( README.md doc/certtool.cfg )

HTML_DOCS=()

QA_CONFIG_IMPL_DECL_SKIP=(
	# gnulib FPs
	MIN
	alignof
	static_assert
)

pkg_setup() {
	check-compiler-switch_start
	use nls && sandbox-changes_no_network_sandbox "To download/update .po translation files for USE=nls"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		verify-sig_src_unpack
	fi

	local c_c=$(grep -e "LT_CURRENT" "${S}/m4/hooks.m4" | head -n 1 | grep -E -o -e "[0-9]+")
	local c_a=$(grep -e "LT_AGE" "${S}/m4/hooks.m4" | head -n 1 | grep -E -o -e "[0-9]+")
	local cxx_c=$(grep -e "CXX_LT_CURRENT" "${S}/m4/hooks.m4" | head -n 1 | grep -E -o -e "[0-9]+")
	local cxx_a=$(grep -e "CXX_LT_AGE" "${S}/m4/hooks.m4" | head -n 1 | grep -E -o -e "[0-9]+")
#einfo "libgnutls.so current:  ${c_c}"
#einfo "libgnutls.so age:  ${c_a}"
#einfo "libgnutlsxx.so current:  ${cxx_c}"
#einfo "libgnutlsxx.so age:  ${cxx_a}"
	local actual_libgnutls_sover=$((${c_c} - ${c_a}))
	local actual_libgnutlsxx_sover=$((${cxx_c} - ${cxx_a}))
	local actual_sover="${actual_libgnutls_sover}.${actual_libgnutlsxx_sover}"
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump LIBGNUTLS_SOVER, LIBGNUTLSXX_SOVER in ebuild"
eerror "Actual sover:  ${actual_sover}"
eerror "Expected sover:  ${expected_sover}"
		die
	fi

	if [[ "${PV}" =~ "9999" ]] ; then
		local actual_pv=$(grep -e "^AC_INIT" "${S}/configure.ac" | grep -E -o -e "[0-9.]+")
#einfo "Actual pv: ${actual_pv}"
		local expected_pv="${INTERNAL_PV}"
		local actual_slot=$(ver_cut "1-2" "${actual_pv}")
		local expected_slot=$(ver_cut "1-2" "${PV}")
		if ver_test "${actual_slot}" "-ne" "${expected_slot}" ; then
eerror "Update PV, INTERNAL_PV"
eerror "Actual PV:  ${actual_slot}.9999"
eerror "Expected PV:  ${PV}"
			die
		fi
	fi
}

src_prepare() {
	default

	if [[ -n "${EVCS_OFFLINE}" ]] && use nls ; then
eerror "The nls USE flag must be disabled for EVCS_OFFLINE=1 to work properly for ${CATEGORY}/${P}."
		die
	fi

	local bootstrap_opts=(
		--gnulib-srcdir="${S}/gnulib"
		--no-bootstrap-sync
		--copy
		--no-git
		$(usex nls '' '--skip-po')
	)

	if [[ "${PV}" =~ "9999" ]] ; then
		cd "${S}" || die
		./bootstrap "${bootstrap_opts[@]}" || die
	fi

	# bug #520818
	export TZ=UTC

	use doc && HTML_DOCS+=( doc/gnutls.html )

	# don't try to use system certificate store on macOS, it is
	# confusingly ignoring our ca-certificates and more importantly
	# fails to compile in certain configurations
	sed -i -e 's/__APPLE__/__NO_APPLE__/' lib/system/certs.c || die

	# Fails with some combinations of USE="brotli zlib zstd"
	# https://gitlab.com/gnutls/gnutls/-/issues/1721
	# https://gitlab.com/gnutls/gnutls/-/merge_requests/1980
	cat <<-EOF > tests/system-override-compress-cert.sh || die
	#!/bin/sh
	exit 77
	EOF
	chmod +x tests/system-override-compress-cert.sh || die

	elibtoolize
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if use tls-heartbeat ; then
ewarn "TLS heartbeat extension:  Y"
ewarn "Estimated CVSS severity:  5.0-7.5"
ewarn "Vulnerable build:  Y"
ewarn "Denial of Service:  Y"
ewarn "Information disclosure:  Y"
ewarn "Disable the tls-heartbeat USE flag for ${CATEGORY}/${P} to harden the build."
	else
einfo "TLS heartbeat extension:  N"
einfo "Estimated CVSS severity:  0.0"
einfo "Vulnerable build:  N"
einfo "Denial of Service:  N"
einfo "Information disclosure:  N"
	fi

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
	[[ ${CHOST} == *-darwin* ]] && libconf+=( --disable-hardware-acceleration )

	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer=no

	local myeconfargs=(
		--disable-valgrind-tests
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
		$(use_enable systemtap crypto-auditing)
		$(use_enable tls-heartbeat heartbeat-support)
		$(use_with brotli '' link)
		$(use_with idn)
		$(use_with pkcs11 p11-kit)
		$(use_with post-quantum leancrypto)
		$(use_with zlib '' link)
		$(use_with zstd '' link)
		--disable-rpath
		--with-default-trust-store-file="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
		--with-unbound-root-key-file="${EPREFIX}"/etc/dnssec/root-anchors.txt
		--without-included-libtasn1
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)

	ECONF_SOURCE="${S}" econf "${libconf[@]}" "${myeconfargs[@]}"

	if [[ ${CHOST} == *-solaris* ]] ; then
		# gnulib ends up defining its own pthread_mutexattr_gettype
		# otherwise, which is causing versioning problems
		echo "#define PTHREAD_IN_USE_DETECTION_HARD 1" >> config.h || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}

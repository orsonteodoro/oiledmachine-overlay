# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_CI_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="12" # D12
CFLAGS_HARDENED_LANGS="c-lang"
# Sanitizers disabled because it breaks gnutls tests
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS MC"
# CVE-2023-36660 - out of bounds write, memory corruption (ASAN)
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/nettle.asc

CHKL_TIMESTAMPS=(
	"dev-libs/gmp-9999"
)

inherit autotools cflags-hardened chkl flag-o-matic multilib-build multilib-minimal secure-version toolchain-funcs verify-sig

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="66c7ef01faabe7ad6293d6b738d4103de77437b4"
	EGIT_BRANCH="master"
	# Backup mirror:  https://github.com/gnutls/nettle/commits/master/
	EGIT_REPO_URI="https://git.lysator.liu.se/nettle/nettle.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )"
fi

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="https://www.lysator.liu.se/~nisse/nettle/ https://git.lysator.liu.se/nettle/nettle"

LICENSE="|| ( GPL-2+ LGPL-3+ )"
# Subslot = libnettle - libhogweed soname version
LIBNETTLE_SOVER="9"
LIBHOGWEED_SOVER="7"
SLOT="0/${LIBNETTLE_SOVER}-${LIBHOGWEED_SOVER}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="
+asm doc +gmp static-libs cpu_flags_arm_neon cpu_flags_arm_aes cpu_flags_arm_sha1 cpu_flags_arm_sha2 cpu_flags_ppc_altivec cpu_flags_ppc_vsx2 cpu_flags_ppc_vsx3 cpu_flags_x86_aes cpu_flags_x86_sha cpu_flags_x86_pclmul
ebuild_revision_9
"
# The arm64 crypto option controls AES, SHA1, and SHA2 usage.
REQUIRED_USE="
	cpu_flags_arm_aes? ( cpu_flags_arm_sha1 cpu_flags_arm_sha2 )
	cpu_flags_arm_sha1? ( cpu_flags_arm_aes cpu_flags_arm_sha2 )
	cpu_flags_arm_sha2? ( cpu_flags_arm_aes cpu_flags_arm_sha1 )
"

DEPEND="gmp? ( >=dev-libs/gmp-${GMP_PV}:=[static-libs?,${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/m4
	doc? ( sys-apps/texinfo )
	verify-sig? ( >=sec-keys/openpgp-keys-nettle-20250628 )
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/nettle/version.h
)

DOCS=()
HTML_DOCS=()

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

	local actual_libnettle_sover=$(grep -e "LIBNETTLE_MAJOR=" "${S}/configure.ac" | cut -f 2 -d "=")
	local expected_libnettle_sover="${LIBNETTLE_SOVER}"
	local actual_libhogweed_sover=$(grep -e "LIBHOGWEED_MAJOR=" "${S}/configure.ac" | cut -f 2 -d "=")
	local expected_libhogweed_sover="${LIBHOGWEED_SOVER}"
	if ver_test "${actual_libnettle_sover}" "-ne" "${expected_libnettle_sover}" ; then
eerror "QA:  Update LIBNETTLE_SOVER in ebuild."
eerror "QA:  Actual libnettle sover:  ${actual_libnettle_sover}"
eerror "QA:  Expected libnettle sover:  ${expected_libnettle_sover}"
		die
	fi
	if ver_test "${actual_libhogweed_sover}" "-ne" "${expected_libhogweed_sover}" ; then
eerror "QA:  Update LIBHOGWEED_SOVER in ebuild."
eerror "QA:  Actual libhogweed sover:  ${actual_libhogweed_sover}"
eerror "QA:  Expected libhogweed sover:  ${expected_libhogweed_sover}"
		die
	fi
}

src_prepare() {
	default

	eautoreconf

	# I do not see in config.sub reference to sunldsolaris.
	# if someone complains readd
	# -e 's/solaris\*)/sunldsolaris*)/' \
	sed -e '/CFLAGS=/s: -ggdb3::' \
		-i configure.ac configure || die

	if use doc ; then
		DOCS+=( nettle.pdf )
		HTML_DOCS+=( nettle.html )
	fi
}

multilib_src_configure() {
	# We don't want to run Valgrind within ebuilds, it often gets
	# confused by sandbox, etc.
	export nettle_cv_prog_valgrind=no

	use elibc_musl && append-cppflags -D__GNU_LIBRARY__ #945970

	chkl_check_many_timestamps
	cflags-hardened_append

	# TODO: USE=debug w/ --enable-extra-asserts?
	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"

		$(tc-is-static-only && echo --disable-shared)

		# Intrinsics
		$(use_enable cpu_flags_arm_neon arm-neon)
		$(use_enable cpu_flags_arm_aes arm64-crypto)
		$(use_enable cpu_flags_ppc_altivec power-altivec)
		$(use_enable cpu_flags_ppc_vsx2 power-crypto-ext)
		$(use_enable cpu_flags_ppc_vsx3 power9)
		$(use_enable cpu_flags_x86_aes x86-aesni)
		$(use_enable cpu_flags_x86_sha x86-sha-ni)
		$(use_enable cpu_flags_x86_pclmul x86-pclmul)
		$([[ ${CHOST} == *-solaris* ]] && echo '--disable-symbol-versions')
		# TODO: cpu_flags_s390?
		--disable-s390x-vf
		--disable-s390x-msa

		$(use_enable asm assembler)
		$(multilib_native_use_enable doc documentation)
		$(use_enable gmp public-key)
		$(use_enable static-libs static)
		--disable-fat

		# openssl is just used for benchmarks (bug #427526)
		--disable-openssl
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

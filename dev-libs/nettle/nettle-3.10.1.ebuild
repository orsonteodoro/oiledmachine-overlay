# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_CF_PROTECTION=0											# Untested or unverified
CFLAGS_HARDENED_CI_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_CI_SANITIZERS_GCC_COMPAT="12" # D12
CFLAGS_HARDENED_FHARDENED=0											# Untested or unverified
CFLAGS_HARDENED_LANGS="c-lang"
# Sanitizers disabled because it breaks gnutls tests
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="crypto security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS MC"
# CVE-2023-36660 - out of bounds write, memory corruption (ASAN)
CPU_FLAGS_ARM=(
	"cpu_flags_arm_aes"
	"cpu_flags_arm_neon"
	"cpu_flags_arm_sha1"
	"cpu_flags_arm_sha2"
)
CPU_FLAGS_PPC=(
	"cpu_flags_ppc_altivec"
	"cpu_flags_ppc_vsx2"
	"cpu_flags_ppc_vsx3"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_aes"
	"cpu_flags_x86_pclmul"
	"cpu_flags_x86_sha"
)
MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/nettle/version.h"
)
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/nettle.asc"

inherit cflags-hardened multilib-build multilib-minimal toolchain-funcs
inherit verify-sig flag-o-matic

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

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="
	https://www.lysator.liu.se/~nisse/nettle/
	https://git.lysator.liu.se/nettle/nettle
"
LICENSE="
	|| (
		LGPL-2.1
		LGPL-3
	)
"
# Subslot = libnettle - libhogweed soname version
SLOT="0/8-6"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_X86[@]}
+asm doc +gmp static-libs
ebuild_revision_30
"
# The arm64 crypto option controls AES, SHA1, and SHA2 usage.
REQUIRED_USE="
	cpu_flags_arm_aes? (
		cpu_flags_arm_sha1
		cpu_flags_arm_sha2
	)
	cpu_flags_arm_sha1? (
		cpu_flags_arm_aes
		cpu_flags_arm_sha2
	)
	cpu_flags_arm_sha2? (
		cpu_flags_arm_aes
		cpu_flags_arm_sha1
	)
"
DEPEND="
	gmp? (
		>=dev-libs/gmp-6.1:=[static-libs?,${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-devel/m4
	doc? (
		sys-apps/texinfo
	)
	verify-sig? (
		sec-keys/openpgp-keys-nettle
	)
"
DOCS=()
HTML_DOCS=()

src_prepare() {
	default

	# I do not see in config.sub reference to sunldsolaris.
	# if someone complains readd
	# -e 's/solaris\*)/sunldsolaris*)/' \
	sed -i \
		-e '/CFLAGS=/s: -ggdb3::' \
		"configure" \
		"configure.ac" \
		|| die

	if use doc ; then
		DOCS+=(
			"nettle.pdf"
		)
		HTML_DOCS+=(
			"nettle.html"
		)
	fi
}

multilib_src_configure() {
	# We don't want to run Valgrind within ebuilds, it often gets
	# confused by sandbox, etc.
	export nettle_cv_prog_valgrind="no"

	use elibc_musl && append-cppflags -D__GNU_LIBRARY__ #945970

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

	# https://git.lysator.liu.se/nettle/nettle/-/issues/7
	if \
		use cpu_flags_ppc_altivec \
			&& \
		! tc-cpp-is-true "defined(__VSX__) && __VSX__ == 1" ${CPPFLAGS} ${CFLAGS} \
	; then
ewarn "cpu_flags_ppc_altivec is enabled, but nettle's asm requires >=P7."
ewarn "Disabling, sorry! See bug #920234."
		myeconfargs+=(
			--disable-power-altivec
		)
	fi

	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_test() {
	emake check || die
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (3.10.1, 20250430)
# test suite:  passed (with and without sanitizers)

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Ebuild r100 is for oiledmachine-overlay patches and anti-ambiguous deterministic dependency graph.

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/libsodium.minisig"
VERIFY_SIG_METHOD="minisig"

inherit autotools cflags-hardened multilib-minimal verify-sig

DESCRIPTION="Portable fork of NaCl, a higher-level cryptographic library"
HOMEPAGE="https://libsodium.org"

if [[ ${PV} == *9999* ]] ; then
	FALLBACK_COMMIT="931db45728f4022ec8ca0daff38831faf23d3e8e"
	EGIT_BRANCH="master"
	# master - unfuzzed, latest patches, ~14 tests
	# stable - fuzzed, missing latest security patch, ~30 tests
	EGIT_REPO_URI="https://github.com/jedisct1/libsodium.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
elif [[ ${PV} == *_p* ]] ; then
	MY_P=${PN}-$(ver_cut 1-3)-stable-$(ver_cut 5-)

	# We use _pN to represent 'stable releases'
	# These are backports from upstream to the last release branch
	# See https://download.libsodium.org/libsodium/releases/README.html
	SRC_URI="
		https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${MY_P}.tar.gz -> ${P}.tar.gz
		verify-sig? ( https://dev.gentoo.org/~sam/distfiles/dev-libs/libsodium/${MY_P}.tar.gz.minisig -> ${P}.tar.gz.minisig )
	"
	S="${WORKDIR}"/${PN}-stable
else
	SRC_URI="
		https://download.libsodium.org/${PN}/releases/${P}.tar.gz
		verify-sig? ( https://download.libsodium.org/${PN}/releases/${P}.tar.gz.minisig )
		https://github.com/jedisct1/libsodium/commit/df8802b013f9fa67e83eb90f184713477da68f32.patch -> libsodium-df8802b.patch
	"
	# libsodium-df8802b.patch - Fix deadlock
fi

LICENSE="ISC"
SOVER="26"
SLOT="0/${SOVER}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"
IUSE+="
+asm minimal static-libs +urandom
ebuild_revision_9
"

CPU_USE=( cpu_flags_x86_{aes,sse4_1} )
IUSE+=" ${CPU_USE[@]}"

BDEPEND=" verify-sig? ( sec-keys/minisig-keys-libsodium )"

QA_CONFIG_IMPL_DECL_SKIP=(
	_rdrand64_step # depends on target, bug #924154
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.19-cpuflags.patch
	"${DISTDIR}/libsodium-df8802b.patch"
)

src_unpack() {
	if [[ ${PV} == *9999* ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local c=$(grep "SODIUM_LIBRARY_VERSION=" "${S}/configure.ac" | head | cut -f 2 -d "=" | cut -f 1 -d ":")
	local a=$(grep "SODIUM_LIBRARY_VERSION=" "${S}/configure.ac" | head | cut -f 2 -d "=" | cut -f 3 -d ":")
	local actual_sover=$(( ${c} - ${a} ))
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	cflags-hardened_append
	local myeconfargs=(
		$(use_enable asm)
		$(use_enable cpu_flags_x86_aes aesni)
		$(use_enable cpu_flags_x86_sse4_1 sse4_1)
		$(use_enable minimal)
		$(use_enable static-libs static)
		$(use_enable !urandom blocking-random)
	)

	# --disable-pie is needed on x86, see bug #512734
	# TODO: Check if still needed?
	if [[ ${ABI} == x86 ]] ; then
		myeconfargs+=( --disable-pie )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}

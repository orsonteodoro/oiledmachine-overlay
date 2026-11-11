# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARNDED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
inherit cflags-hardened dot-a meson-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	INTERNAL_VERSION="1.11.1"
	SOVER=$(ver_cut 1 "${INTERNAL_VERSION}")
	FALLBACK_COMMIT="92a08d0a3eab9208183891ff0f1a5d3a8c601cde"
	EGIT_BRANCH="dev"
	EGIT_REPO_URI="https://github.com/lz4/lz4.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOVER=$(ver_cut 1 "${PV}")
	SRC_URI="https://github.com/lz4/lz4/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/lz4/lz4"

LICENSE="BSD-2 GPL-2"
SLOT="0/1.10.0-meson"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE+="
static-libs test
ebuild_revision_2
"
RESTRICT="!test? ( test )"

EMESON_SOURCE=${S}/build/meson

PATCHES=(
)

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
	local c1=$(grep -e "LZ4_VERSION_MAJOR" "${S}/lib/lz4.h" | head -n 1 | sed -E -e "s|[ ]+| |g"  | cut -f 3 -d " ")
	local c2=$(grep -e "LZ4_VERSION_MINOR" "${S}/lib/lz4.h" | head -n 1 | sed -E -e "s|[ ]+| |g"  | cut -f 3 -d " ")
	local c3=$(grep -e "LZ4_VERSION_RELEASE" "${S}/lib/lz4.h" | head -n 1 | sed -E -e "s|[ ]+| |g"  | cut -f 3 -d " ")
	local pv="${c1}.${c2}.${c3}"
einfo "Internal PV:  ${pv}"
	local actual_sover="${c1}"
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER, INTERNAL_VERSION, PV, SLOT"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_configure() {
	cflags-hardened_append
	use static-libs && lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		-Dtests=$(usex test true false)
		-Ddefault_library=$(usex static-libs both shared)
		# https://bugs.gentoo.org/940641
		-Dossfuzz=false
	)
	# with -Dprograms=false, the test suite is only rudimentary,
	# so build them for testing non-native ABI as well
	if multilib_is_native_abi || use test; then
		emesonargs+=(
			-Dprograms=true
		)
	fi

	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	strip-lto-bytecode
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a meson-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="0774d05537f9762f838f7ab541b7765f1a729cb5"
	EGIT_BRANCH="dev"
	EGIT_REPO_URI="https://github.com/lz4/lz4.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/lz4/lz4/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/lz4/lz4"

LICENSE="BSD-2 GPL-2"
SLOT="0/1.10.0-meson"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE+=" static-libs test"
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
}

src_configure() {
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

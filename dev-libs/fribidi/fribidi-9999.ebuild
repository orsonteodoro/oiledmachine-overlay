# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE CRSH DOS HO ML SO"

inherit cflags-hardened meson-multilib

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="069a7e3d31e6aa74f2068a8e0804106ce7906639"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/fribidi/fribidi.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://github.com/fribidi/fribidi/releases/download/v${PV}/${P}.tar.xz"
fi

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"
HOMEPAGE="https://fribidi.org/"

LICENSE="LGPL-2.1+"
SLOT="0"

IUSE+=" doc test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

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

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Ddeprecated=true
		$(meson_native_use_bool doc docs)
		-Dbin=true
		$(meson_use test tests)
	)
	meson_src_configure
}

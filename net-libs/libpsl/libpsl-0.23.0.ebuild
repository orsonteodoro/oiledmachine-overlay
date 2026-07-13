# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

PYTHON_COMPAT=( python3_{10..14} )

CHKL_TIMESTAMPS=(
	"dev-libs/icu-79.0.9999"
)

inherit cflags-hardened chkl meson-multilib python-any-r1 secure-version

DESCRIPTION="C library for the Public Suffix List"
HOMEPAGE="https://github.com/rockdaboot/libpsl"
SRC_URI="https://github.com/rockdaboot/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="
icu +idn test static-libs
ebuild_revision_1
"
RESTRICT="!test? ( test )"

RDEPEND="
	icu? ( !idn? ( >=dev-libs/icu-${ICU_PV}:=[${MULTILIB_USEDEP}] ) )
	idn? (
		dev-libs/libunistring:=[${MULTILIB_USEDEP}]
		>=net-dns/libidn2-${LIBIDN2_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_pretend() {
	if use icu && use idn ; then
		ewarn "\"icu\" and \"idn\" USE flags are enabled. Using \"idn\"."
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		$(meson_use test tests)
	)

	# Prefer idn even if icu is in USE as well
	if use idn ; then
		emesonargs+=(
			-Druntime=libidn2
			-Dbuiltin=true
		)
	elif use icu ; then
		emesonargs+=(
			-Druntime=libicu
			-Dbuiltin=true
		)
	else
		emesonargs+=(
			-Druntime=no
		)
	fi

	if use static-libs ; then
		emesonargs+=(
			-Ddefault_library=both
		)
	fi

	meson_src_configure
}

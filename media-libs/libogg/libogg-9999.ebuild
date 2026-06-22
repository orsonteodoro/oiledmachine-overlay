# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/ogg/config_types.h"
)

inherit autotools cflags-hardened multilib-minimal

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="06a5e0262cdc28aa4ae6797627a783b5010440f0"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.xiph.org/xiph/ogg.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://downloads.xiph.org/releases/ogg/${P}.tar.xz"
fi

DESCRIPTION="The Ogg media file format library"
HOMEPAGE="https://xiph.org/ogg/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE+="
static-libs
ebuild_revision_10
"

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

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	cflags-hardened_append
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_FLAGS="untrusted-data"

inherit cflags-hardened

DESCRIPTION="Additional image loaders for Imlib2"
HOMEPAGE="https://www.enlightenment.org/
	https://sourceforge.net/projects/enlightenment/files/imlib2-src/"
SRC_URI="https://downloads.sourceforge.net/enlightenment/${P}.tar.xz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="
xcf
ebuild_revision_1
"

RDEPEND=">=media-libs/imlib2-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	cflags-hardened_append
	local myconf=(
		--disable-static
		$(use_enable xcf)
	)

	econf "${myconf[@]}"
}

src_install() {
	V=1 emake install DESTDIR="${D}"
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}

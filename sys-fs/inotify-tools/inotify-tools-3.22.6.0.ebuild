# Copyright 2020,2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# The distro is the same as this overlay but EAPI=8 adds an implicit
# --disable-static to the distro ebuild?

inherit autotools

DESCRIPTION="a set of command-line programs providing a simple interface to inotify"
HOMEPAGE="https://github.com/inotify-tools/inotify-tools"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~sparc ~x86"
IUSE="doc static-libs"
BDEPEND="
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default
	sed -i 's/ -Werror//' {,libinotifytools/}src/Makefile.am || die #745069
	eautoreconf
}

src_configure() {
	local econfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		$(use_enable doc doxygen)
	)
	econf "${econfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f \( -name '*.la' \) -delete || die
	if ! use static-libs ; then
		find "${ED}" -type f \( -name '*.a*' -and not '*.a' \) -delete -print || die
	fi
}

# OILEDMACHINE-OVERLAY-CHANGES:  static-libs
# OILEDMACHINE-OVERLAY-META-REVDEP:  appimaged

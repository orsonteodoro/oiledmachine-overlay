# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools check-compiler-switch

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/rurban/safeclib/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="safec libc extension with all C11 Annex K functions"
HOMEPAGE="
	https://rurban.github.io/safeclib/
	https://github.com/rurban/safeclib
"
LICENSE="MIT"
SLOT="0"
IUSE="
doc static-libs
"
RDEPEND="
"
DEPEND="
"
BDEPEND="
	dev-build/autoconf:2.69
	dev-build/automake
	dev-build/libtool
	dev-build/make
	dev-perl/Text-Diff
	sys-apps/file
	sys-devel/gcc
	virtual/pkgconfig
"

pkg_setup() {
	check-compiler-switch_start
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CC} -E"
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Removing LTO."
		filter-lto
	fi
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable doc)
		$(use_enable static-libs static)
	)
	econf ${myconf[@]}
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}

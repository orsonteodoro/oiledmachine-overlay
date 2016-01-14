# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils toolchain-funcs

DESCRIPTION="WebP import export"
HOMEPAGE="http://registry.gimp.org/node/25874?page=1"
SRC_URI="http://registry.gimp.org/files/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="media-gfx/gimp"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}_${PV}"

src_compile() {
	emake
}

src_install() {
	exeinto "$(gimptool-2.0 --gimpplugindir)/plug-ins"
	doexe file-webp || die "file-webp doesn't exist"
}


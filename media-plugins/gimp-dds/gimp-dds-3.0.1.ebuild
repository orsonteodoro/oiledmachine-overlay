# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="DirectDraw Surface (DDS) format plugin for Gimp 2"
HOMEPAGE="http://code.google.com/p/gimp-dds/"
SRC_URI="http://gimp-dds.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-gfx/gimp-2.6"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	exeinto "$(pkg-config --variable=gimplibdir gimp-2.0)/plug-ins"
	doexe dds || die "Installation failed"

	# No need to install the gimp-dds.odt or the images, as they have the same
	# content as the gimp-dds.pdf
	dodoc README TODO doc/gimp-dds.pdf || die
}

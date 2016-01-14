# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib multilib-minimal

DESCRIPTION="ALTLinux hyphenation library"
HOMEPAGE="http://hunspell.sf.net"
SRC_URI="mirror://sourceforge/hunspell/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="app-text/hunspell"
DEPEND="${RDEPEND}"

#DOCS="AUTHORS ChangeLog NEWS README* THANKS TODO"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf $(use_enable static-libs static)
}

multilib_src_install() {
	default

	rm -f "${ED}"usr/lib*/libhyphen.la

	docinto pdf
        cd "${WORKDIR}/${P}"
	dodoc doc/*.pdf
	dodoc AUTHORS ChangeLog NEWS README* THANKS TODO
}

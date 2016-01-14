# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib-minimal

DESCRIPTION="dot.conf configuration file parser"
HOMEPAGE="https://www.github.com/williamh/dotconf"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=">=sys-devel/autoconf-2.58"
RDEPEND=""

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf || die
}

multilib_src_compile() {
	CC=$(tc-getCC) \
	emake || die
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	ewarn 'This version requires that you run revdep-rebuild after'
	ewarn 'the upgrade.'
}

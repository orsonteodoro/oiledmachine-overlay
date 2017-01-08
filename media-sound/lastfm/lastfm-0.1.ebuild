# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="lastfm is a Python interface to Last.fm web services (API 2.0)."
HOMEPAGE="http://code.google.com/p/python-lastfm/"
SRC_URI="http://dev.gentoo.org/~nerdboy/${P}.tar.gz"
LICENSE="LGPL"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND=">=dev-lang/python-2.5
	dev-python/setuptools
        dev-python/stdeb
	!media-sound/lastfmsubmitd"

RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
}

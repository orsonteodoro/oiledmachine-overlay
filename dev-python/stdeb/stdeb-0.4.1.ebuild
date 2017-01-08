# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

commit="246b2b7"
MY_PN="astraw-${PN}-${commit}"

DESCRIPTION="Python to Debian source package conversion utility"
HOMEPAGE="http://github.com/astraw/stdeb"
SRC_URI="http://github.com/astraw/${PN}/tarball/release-${PV}/${MY_PN}.tar.gz"
LICENSE="LGPL"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE="doc"

DEPEND="dev-python/setuptools
	>=dev-util/debhelper-7"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	cd "${WORKDIR}"
	unpack ${MY_PN}.tar.gz
}

src_prepare() {
	eapply_user
}

src_install() {
	distutils-r1_src_install

	use doc && dodoc RELEASE_NOTES.txt CHANGELOG.txt
}


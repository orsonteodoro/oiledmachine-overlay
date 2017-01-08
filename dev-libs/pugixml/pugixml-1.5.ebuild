# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="http://pugixml.org/ https://github.com/zeux/pugixml/"
SRC_URI="https://github.com/zeux/${PN}/releases/download/v${PV}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux static"
IUSE="static"

S=${WORKDIR}/${P}/scripts

src_prepare() {
	eapply_user
}

src_configure() {
	local mycmakeargs=( )
	if use static; then
		mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
	else
		mycmakeargs=( -DBUILD_SHARED_LIBS=ON )
	fi

	cmake-utils_src_configure
}

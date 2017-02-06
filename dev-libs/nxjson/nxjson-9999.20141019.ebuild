# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Very small JSON parser written in C."
HOMEPAGE="https://bitbucket.org/yarosla/nxjson/overview"
BB_USER="yarosla"
COMMIT="afaf7f999a95"
SRC_URI="https://bitbucket.org/${BB_USER}/nxjson/get/${COMMIT}.zip -> ${P}.zip"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux static"
IUSE="static"

S="${WORKDIR}/${BB_USER}-${PN}-${COMMIT}"

src_prepare() {
	eapply "${FILESDIR}/nxjson-9999.20141019-create-libs.patch"

	eapply_user
}

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/bin
	doexe nxjson

	insinto /usr/$(get_libdir)
	doins libnxjson.so
	if use static ; then
		doins libnxjson.a
	fi

	insinto /usr/include
	doins nxjson.h
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="TurboTurtle is a Logo compiler designed for high-performance Turtle Graphics using OpenGL"
HOMEPAGE="http://www.fascinationsoftware.com/FS/html/TurboTurtle.html"
SRC_URI="https://github.com/richard42/turboturtle/releases/download/March2009/TurboTurtle-${PV}-source.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

RDEPEND="media-libs/libsdl[opengl]
	 dev-lang/python:2.7
	 "
DEPEND="${RDEPEND}"

S="${WORKDIR}/TurboTurtle-${PV}-source"

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/turboturtle"
	cp -r "${S}"/* "${D}/usr/$(get_libdir)/turboturtle"

	if use examples; then
		mkdir -p "${D}/usr/share/turboturtle"
		mv "${D}/usr/$(get_libdir)/turboturtle/logocode" "${D}/usr/share/turboturtle"
	else
		rm -rf "${D}/usr/$(get_libdir)/turboturtle/logocode"
	fi

	chmod o+w "${D}/usr/$(get_libdir)/turboturtle"
	mkdir -p "${D}/usr/bin"

	echo '#!/bin/bash' > "${D}/usr/bin/turboturtle"
	echo 'OLDDIR=`pwd`' >> "${D}/usr/bin/turboturtle"
	echo "cp \$1 /usr/$(get_libdir)/turboturtle" >> "${D}/usr/bin/turboturtle"
	echo "cd /usr/$(get_libdir)/turboturtle" >> "${D}/usr/bin/turboturtle"
	echo './runlogo.sh $@' >> "${D}/usr/bin/turboturtle"
	echo 'name=`basename "$1"`' >> "${D}/usr/bin/turboturtle"
	echo 'destdir=`dirname "$1"`' >> "${D}/usr/bin/turboturtle"
	echo 'basename=${name%%.*}' >> "${D}/usr/bin/turboturtle"
	echo 'cp $basename ${OLDDIR}' >> "${D}/usr/bin/turboturtle"
	echo "rm -f /usr/$(get_libdir)/turboturtle/\$basename{.o,.cpp,.logo,}" >> "${D}/usr/bin/turboturtle"
	chmod +x "${D}/usr/bin/turboturtle"

	sed -i 's|#!/usr/bin/env python|#!/usr/bin/env python2|g' "${D}/usr/$(get_libdir)/turboturtle/turboturtle.py"
	sed -i "s|glXSwapIntervalSGI(1);|;//glXSwapIntervalSGI(1);|g" "${D}/usr/$(get_libdir)/turboturtle/wrapper_main.cpp"
}

pkg_postinst() {
	einfo "The wrapper script /usr/bin/turboturtle  dumps the compiled exe to the current working directorty."
}

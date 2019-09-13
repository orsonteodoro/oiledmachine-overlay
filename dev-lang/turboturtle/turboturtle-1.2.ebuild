# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

DESCRIPTION="TurboTurtle is a Logo compiler designed for high-performance Turtle Graphics using OpenGL"
HOMEPAGE="http://www.fascinationsoftware.com/FS/html/TurboTurtle.html"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SRC_URI="https://github.com/richard42/turboturtle/releases/download/March2009/TurboTurtle-${PV}-source.tar.gz"
SLOT="0"
IUSE="examples"
RDEPEND="dev-lang/python:2.7
	 media-libs/libsdl[opengl]"
DEPEND="${RDEPEND}"
S="${WORKDIR}/TurboTurtle-${PV}-source"

src_install() {
	insinto /usr/$(get_libdir)/turboturtle
	doins -r *

	if use examples; then
		insinto /usr/share/turboturtle
		mv "${D}/usr/$(get_libdir)/turboturtle/logocode" "${D}/usr/share/turboturtle"
	else
		rm -rf "${D}/usr/$(get_libdir)/turboturtle/logocode"
	fi

	chmod o+w "${D}/usr/$(get_libdir)/turboturtle"
	exeinto /usr/bin
	doexe "${FILESDIR}/turboturtle"
	sed -i -e "s|lib64|$(get_libdir)|g" "${D}/usr/bin/turboturtle" || die

	sed -i 's|#!/usr/bin/env python|#!/usr/bin/env python2|g' "${D}/usr/$(get_libdir)/turboturtle/turboturtle.py" || die
	sed -i "s|glXSwapIntervalSGI(1);|;//glXSwapIntervalSGI(1);|g" "${D}/usr/$(get_libdir)/turboturtle/wrapper_main.cpp" || die
}

pkg_postinst() {
	einfo "The wrapper script /usr/bin/turboturtle  dumps the compiled exe to the current working directorty."
}

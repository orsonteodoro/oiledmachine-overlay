# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="QB64"
HOMEPAGE="http://www.qb64.net/"
SRC_URI="http://www.qb64.net/release/official/2015_03_12__02_08_19__v0000/linux/qb64v1000-lnx.tar.gz"

LICENSE="QB64"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="samples android"

RDEPEND="android? ( dev-util/android-studio )
         media-libs/libsdl
	 media-libs/sdl-image
	 media-libs/sdl-mixer
         media-libs/sdl-net
	 media-libs/sdl-ttf
	 "
DEPEND="${RDEPEND}"

FEATURES=""

S="${WORKDIR}/qb64"

src_compile() {
	sed -i "s|./qb64 &||g" "${S}"/setup_lnx.sh
	sed -i 's|cat > ~/.local/share/applications/qb64.desktop <<EOF|_T= <<EOF|g' "${S}"/setup_lnx.sh
	./setup_lnx.sh
}

src_install() {
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/$(get_libdir)/qb64"
	cp qb64 "${D}/usr/$(get_libdir)/qb64"/
	cp -r internal "${D}/usr/$(get_libdir)/qb64"/
	mkdir -p "${D}/usr/share/qbasic"

	if use samples; then
		cp -r "${S}/programs/samples" "${D}/usr/share/qbasic"/
	fi
	if use android; then
		cp -r "${S}/programs/android" "${D}/usr/share/qbasic"/
	fi

	echo '#!/bin/bash' > "${D}/usr/bin/qb64"
	echo "cd /usr/$(get_libdir)/qb64" >> "${D}/usr/bin/qb64"
	echo "./qb64" >> "${D}/usr/bin/qb64"
	chmod +x "${D}/usr/bin/qb64"

	#we need to get IDE to work properly
	chmod o+w "${D}/usr/$(get_libdir)/qb64/internal/c/parts/core/gl_header_for_parsing/temp/gl_helper_code.h"
	chmod o+w "${D}/usr/$(get_libdir)/qb64/internal/temp"/*.bin
	chmod o+w "${D}/usr/$(get_libdir)/qb64/internal/temp"/*.txt
	chmod o+w "${D}/usr/$(get_libdir)/qb64/internal/temp"

	#get it to compile correctly
	chmod o+w "${D}/usr/$(get_libdir)/qb64/internal/c/libqb/os/lnx"

	#allow run basic program
	chmod o+w "${D}/usr/$(get_libdir)/qb64"

	cp "${S}"/internal/source/qb64icon32.png "${D}"/usr/share/qbasic
	make_desktop_entry "/usr/bin/qb64" "QB64 Programming IDE" "/usr/share/qbasic/qb64icon32.png" "Development;IDE"
}



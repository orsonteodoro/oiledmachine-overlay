# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils versionator

DESCRIPTION="QB64"
HOMEPAGE="http://www.qb64.net/"
#1.2.20180102.84.2018.01.06.05.07.34
PV_A="$(get_version_component_range 1-2 ${PV})" #1.2
PV_B="$(get_version_component_range 3 ${PV})" #20180102
PV_C="$(get_version_component_range 4 ${PV})" #84
PV_D="$(get_version_component_range 5-7 ${PV})" #2018.01.06
PV_E="$(get_version_component_range 8-10 ${PV})" #05.07.34
SRC_URI="http://www.qb64.net/release/dirty/${PV_D//./_}__${PV_E//./_}-${PV_A}-${PV_B}.${PV_C}/linux/qb64-${PV_A}-${PV_B}.${PV_C}-lnx.tar.gz"

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

S="${WORKDIR}/qb64"

src_prepare() {
	eapply_user
	find . -name '*.sh' -exec sed -i "s/\r//g" {} \;
}

src_compile() {
	sed -i "s|./qb64 &||g" "${S}"/setup_lnx.sh || die
	sed -i 's|cat > ~/.local/share/applications/qb64.desktop <<EOF|_T= <<EOF|g' "${S}"/setup_lnx.sh || die
	./setup_lnx.sh
}

src_install() {
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/$(get_libdir)/qb64"
	cp qb64 "${D}/usr/$(get_libdir)/qb64"/ || die
	cp -r internal "${D}/usr/$(get_libdir)/qb64"/
	cp -r source "${D}/usr/$(get_libdir)/qb64"/
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



# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	find . -name '*.sh' -exec sed -i "s/\r//g" {} \;
	eapply_user
}

src_compile() {
	sed -i "s|./qb64 &||g" "${S}"/setup_lnx.sh || die
	sed -i 's|cat > ~/.local/share/applications/qb64.desktop <<EOF|_T= <<EOF|g' "${S}"/setup_lnx.sh || die
	./setup_lnx.sh
}

src_install() {
	dodir /usr/bin
	dodir /usr/$(get_libdir)/qb64
	insinto /usr/$(get_libdir)/qb64
	doins qb64
	doins -r internal
	doins -r source
	dodir /usr/share/qbasic
	insinto /usr/share/qbasic

	if use samples; then
		doins -r "${S}/programs/samples"
	fi
	if use android; then
		doins -r "${S}/programs/android"
	fi

	echo '#!/bin/bash' > "${D}/usr/bin/qb64" || die
	echo "cd /usr/$(get_libdir)/qb64" >> "${D}/usr/bin/qb64" || die
	echo "./qb64" >> "${D}/usr/bin/qb64" || die
	fperms +x /usr/bin/qb64

	#we need to get IDE to work properly
	fperms o+w /usr/$(get_libdir)/qb64/internal/c/parts/core/gl_header_for_parsing/temp/gl_helper_code.h
	fperms o+w $(ls "${D}"/usr/$(get_libdir)/qb64/internal/temp/*.bin | sed -e "s|${D}||")
	fperms o+w $(ls "${D}"/usr/$(get_libdir)/qb64/internal/temp/*.txt | sed -e "s|${D}||")
	fperms o+w /usr/$(get_libdir)/qb64/internal/temp

	#get it to compile correctly
	fperms o+w /usr/$(get_libdir)/qb64/internal/c/libqb/os/lnx

	#allow run basic program
	fperms o+w /usr/$(get_libdir)/qb64

	dodir /usr/share/qbasic
	insinto /usr/share/qbasic
	doins internal/source/qb64icon32.png
	make_desktop_entry "/usr/bin/qb64" "QB64 Programming IDE" "/usr/share/qbasic/qb64icon32.png" "Development;IDE"
}



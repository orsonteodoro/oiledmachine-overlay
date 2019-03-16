# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils versionator

DESCRIPTION="QB64"
HOMEPAGE="http://www.qb64.net/"
# 1.2.20181101.14.32.33.2398884
PV_A="$(get_version_component_range 1-2 ${PV})" # 1.2
PV_B="$(get_version_component_range 3 ${PV})" # 20181101
PV_B_Y="${PV_B:0:4}" # 2018
PV_B_M="${PV_B:4:2}" # 11
PV_B_D="${PV_B:6:2}" # 01
PV_C="$(get_version_component_range 4 ${PV})" # 14
PV_D="$(get_version_component_range 5 ${PV})" # 32
PV_E="$(get_version_component_range 6 ${PV})" # 33
PV_F="$(get_version_component_range 7 ${PV})" # 2398884
SRC_URI="https://www.qb64.org/autobuilds/master/qb64_${PV_B_Y}-${PV_B_M}-${PV_B_D}-${PV_C}-${PV_D}-${PV_E}_${PV_F}-master_lnx.tar.gz"

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
	fperms +x /usr/$(get_libdir)/qb64/qb64

	#we need to get IDE to work properly
	fperms o+w /usr/$(get_libdir)/qb64/internal/c/parts/core/gl_header_for_parsing/temp/gl_helper_code.h
	fperms o+w $(find "${D}"/usr/$(get_libdir)/qb64/internal/temp/ -name "*.bin" | sed -e "s|${D}||")
	fperms o+w $(find "${D}"/usr/$(get_libdir)/qb64/internal/temp/ -name "*.txt" | sed -e "s|${D}||")
	fperms o+w $(find "${D}"/usr/$(get_libdir)/qb64/internal/temp/ -name "*.rc" | sed -e "s|${D}||")
	fperms o+w /usr/$(get_libdir)/qb64/internal/temp
	fperms o+w /usr/$(get_libdir)/qb64/internal/config.txt
	fperms o+w /usr/$(get_libdir)/qb64/internal/
	fperms o+w $(find "${D}"/usr/$(get_libdir)/qb64/source/virtual_keyboard -name "*.bas" | sed -e "s|${D}||")

	#get it to compile correctly
	fperms o+w /usr/$(get_libdir)/qb64/internal/c/libqb/os/lnx

	#allow run basic program
	fperms o+w /usr/$(get_libdir)/qb64

	dodir /usr/share/qbasic
	insinto /usr/share/qbasic
	doins internal/source/qb64icon32.png
	make_desktop_entry "/usr/bin/qb64" "QB64 Programming IDE" "/usr/share/qbasic/qb64icon32.png" "Development;IDE"
}



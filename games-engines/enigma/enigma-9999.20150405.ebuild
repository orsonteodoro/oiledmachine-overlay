# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="ENIGMA"
HOMEPAGE="http://enigma-dev.org"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="extras"

RDEPEND="games-misc/lateralgm
	 sys-libs/zlib
	 media-libs/glu
	 media-libs/glew
         media-libs/alure
	 media-libs/libvorbis
         media-libs/dumb
	 extras? ( games-misc/libmaker )
	 games-misc/lgmplugin
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/enigma-9999"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/enigma-dev/enigma-dev.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="7049b411e3f4c2f9a52c652b86a4a83a8120db05"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	sed -i -e "s|C:/ProgramData/ENIGMA/|/usr/lib/enigma|" CommandLine/programs/emake/main.cpp
}

src_compile() {
	emake ENIGMA || die
}

src_install() {
	#install the minimal required toolchain
	mkdir -p "${D}/usr/$(get_libdir)/enigma"/
	cp -r "${S}/ENIGMAsystem" "${D}/usr/$(get_libdir)/enigma"/
	cp -r "${S}/Compilers" "${D}/usr/$(get_libdir)/enigma"/
	cp "${S}/settings.ey" "${D}/usr/$(get_libdir)/enigma"/
	cp "${S}/events.res" "${D}/usr/$(get_libdir)/enigma"/

	mkdir -p "${D}/usr/bin"

	echo "#!/bin/bash" > "${D}/usr/bin/enigma"
	echo "cd /usr/$(get_libdir)/enigma" >> "${D}/usr/bin/enigma"
	echo "OUTPUTNAME=game WORKDIR=\"\$HOME/.enigma\" CXXFLAGS=\"-std=c++11 -I\$HOME/.enigma\" CFLAGS=\"-I\$HOME/.enigma\" \\" >> "${D}/usr/bin/enigma"
	echo "java -Djna.nosys=true -jar /usr/$(get_libdir)/enigma/lateralgm.jar \$*" >> "${D}/usr/bin/enigma"
	chmod +x "${D}/usr/bin/enigma"

	echo "#!/bin/bash" > "${D}/usr/bin/enigma-cli"
	echo "cd /usr/$(get_libdir)/enigma" >> "${D}/usr/bin/enigma-cli"
	echo "OUTPUTNAME=game WORKDIR=\"\$HOME/.enigma\" CXXFLAGS=\"-std=c++11 -I\$HOME/.enigma\" CFLAGS=\"-I\$HOME/.enigma\" \\" >> "${D}/usr/bin/enigma-cli"
	echo "java -Djna.nosys=true -jar /usr/$(get_libdir)/enigma/plugins/enigma.jar \$*" >> "${D}/usr/bin/enigma-cli"
	chmod +x "${D}/usr/bin/enigma-cli"

	mkdir -p "${D}/usr/$(get_libdir)/enigma"/
	cp libcompileEGMf.so "${D}/usr/$(get_libdir)/enigma"/
	cp Makefile "${D}/usr/$(get_libdir)/enigma"/
	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|.PHONY: ENIGMA||g' "${D}/usr/$(get_libdir)/enigma/Makefile"
	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|ENIGMA:\n\t\$(MAKE) -j 3 -C CompilerSource||g' "${D}/usr/$(get_libdir)/enigma/Makefile"
	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|clean:\n\t\$(MAKE) -C CompilerSource clean||g' "${D}/usr/$(get_libdir)/enigma/Makefile"

	mkdir -p "${D}/usr/share/enigma"
	cp "${S}/Resources/logo.png" "${D}/usr/share/enigma"

	make_desktop_entry "/usr/bin/enigma" "ENIGMA" "/usr/share/enigma/logo.png" "Development;IDE"
}

pkg_postinst()
{
	einfo "When you run it the first time, it will compile the /usr/$(get_libdir)/ENIGMAsystem/SHELL files.  What this means is that the Run, Debug, and Compile"
	einfo "buttons on LateralGM will not be available until ENIGMA is done.  You need to wait."
}

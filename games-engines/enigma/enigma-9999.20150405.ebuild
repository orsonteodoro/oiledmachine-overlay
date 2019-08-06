# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, is an open source cross-platform game development environment derived from that of the popular software Game Maker."
HOMEPAGE="http://enigma-dev.org"
COMMIT="7049b411e3f4c2f9a52c652b86a4a83a8120db05"
SRC_URI="https://github.com/enigma-dev/enigma-dev/archive/${COMMIT}.zip -> ${P}.zip"

RESTRICT=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="extras"

RDEPEND="games-engines/lateralgm
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

S="${WORKDIR}/enigma-${COMMIT}"

src_prepare() {
	sed -i -e "s|C:/ProgramData/ENIGMA/|/usr/lib/enigma|" CommandLine/programs/emake/main.cpp || die
}

src_compile() {
	emake ENIGMA || die
}

src_install() {
	#install the minimal required toolchain
	mkdir -p "${D}/usr/$(get_libdir)/enigma"/ || die
	cp -r "${S}/ENIGMAsystem" "${D}/usr/$(get_libdir)/enigma"/ || die
	cp -r "${S}/Compilers" "${D}/usr/$(get_libdir)/enigma"/ || die
	cp "${S}/settings.ey" "${D}/usr/$(get_libdir)/enigma"/ || die
	cp "${S}/events.res" "${D}/usr/$(get_libdir)/enigma"/ || die

	mkdir -p "${D}/usr/bin"

	echo "#!/bin/bash" > "${D}/usr/bin/enigma" || die
	echo "cd /usr/$(get_libdir)/enigma" >> "${D}/usr/bin/enigma" || die
	echo "OUTPUTNAME=game WORKDIR=\"\$HOME/.enigma\" CXXFLAGS=\" -I\$HOME/.enigma\" CFLAGS=\"-I\$HOME/.enigma\" \\" >> "${D}/usr/bin/enigma" || die
	echo "java -Djna.nosys=true -jar /usr/$(get_libdir)/enigma/lateralgm.jar \$*" >> "${D}/usr/bin/enigma" || die
	chmod +x "${D}/usr/bin/enigma" || die

	echo "#!/bin/bash" > "${D}/usr/bin/enigma-cli" || die
	echo "cd /usr/$(get_libdir)/enigma" >> "${D}/usr/bin/enigma-cli" || die
	echo "OUTPUTNAME=game WORKDIR=\"\$HOME/.enigma\" CXXFLAGS=\" -I\$HOME/.enigma\" CFLAGS=\"-I\$HOME/.enigma\" \\" >> "${D}/usr/bin/enigma-cli" || die
	echo "java -Djna.nosys=true -jar /usr/$(get_libdir)/enigma/plugins/enigma.jar \$*" >> "${D}/usr/bin/enigma-cli" || die
	chmod +x "${D}/usr/bin/enigma-cli" || die

	mkdir -p "${D}/usr/$(get_libdir)/enigma"/ || die
	cp libcompileEGMf.so "${D}/usr/$(get_libdir)/enigma"/ || die
	cp Makefile "${D}/usr/$(get_libdir)/enigma"/ || die
	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|.PHONY: ENIGMA||g' "${D}/usr/$(get_libdir)/enigma/Makefile" || die
	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|ENIGMA:\n\t\$(MAKE) -j 3 -C CompilerSource||g' "${D}/usr/$(get_libdir)/enigma/Makefile" || die
	sed -i -e ':a' -e 'N' -e '$!ba' -e 's|clean:\n\t\$(MAKE) -C CompilerSource clean||g' "${D}/usr/$(get_libdir)/enigma/Makefile" || die

	mkdir -p "${D}/usr/share/enigma" || die
	cp "${S}/Resources/logo.png" "${D}/usr/share/enigma" || die

	make_desktop_entry "/usr/bin/enigma" "ENIGMA" "/usr/share/enigma/logo.png" "Development;IDE"
}

pkg_postinst()
{
	einfo "When you run it the first time, it will compile the /usr/$(get_libdir)/ENIGMAsystem/SHELL files.  What this means is that the Run, Debug, and Compile"
	einfo "buttons on LateralGM will not be available until ENIGMA is done.  You need to wait."
}

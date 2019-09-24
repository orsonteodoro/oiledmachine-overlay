# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils toolchain-funcs

DESCRIPTION="ENIGMA, the Extensible Non-Interpreted Game Maker Augmentation, is an open source cross-platform game development environment derived from that of the popular software Game Maker."
HOMEPAGE="http://enigma-dev.org"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""
EGIT_COMMIT="7049b411e3f4c2f9a52c652b86a4a83a8120db05"
SRC_URI="https://github.com/enigma-dev/enigma-dev/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
SLOT="0"
RDEPEND="games-util/lateralgm
	 sys-libs/zlib
	 media-libs/glu
	 media-libs/glew
         media-libs/alure
	 media-libs/libvorbis
         media-libs/dumb
	 games-misc/lgmplugin"
DEPEND="${RDEPEND}"
S="${WORKDIR}/enigma-dev-${EGIT_COMMIT}"
QA_SONAME="/usr/lib64/libcompileEGMf.so"

src_prepare() {
	default
	esed "s|C:/ProgramData/ENIGMA/|/usr/lib/enigma|" CommandLine/programs/emake/main.cpp
}

src_compile() {
	emake ENIGMA
}

# new line replace
NLR=( -e ':a' -e 'N' -e '$!ba' )

src_install() {
	insinto /usr/$(get_libdir)/enigma/
	doins -r ENIGMAsystem Compilers settings.ey events.res

	exeinto /usr/bin
	doexe "${FILESDIR}/enigma" "${FILESDIR}/enigma-cli"

	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" "${D}/usr/bin/enigma" || die
	sed -i -e "s|/usr/lib64|/usr/$(get_libdir)|g" "${D}/usr/bin/enigma-cli" || die

	insinto "/usr/$(get_libdir)/enigma/"
	dolib.so libcompileEGMf.so
	doins Makefile
	sed -i ${NLR[@]} -e 's|.PHONY: ENIGMA||g' "${D}/usr/$(get_libdir)/enigma/Makefile" || die
	sed -i ${NLR[@]} -e 's|ENIGMA:\n\t\$(MAKE) -j 3 -C CompilerSource||g' "${D}/usr/$(get_libdir)/enigma/Makefile" || die
	sed -i ${NLR[@]} -e 's|clean:\n\t\$(MAKE) -C CompilerSource clean||g' "${D}/usr/$(get_libdir)/enigma/Makefile" || die

	insinto /usr/share/enigma
	doins Resources/logo.png

	make_desktop_entry "/usr/bin/enigma" "ENIGMA" "/usr/share/enigma/logo.png" "Development;IDE"
}

pkg_postinst()
{
	einfo "When you run it the first time, it will compile the /usr/$(get_libdir)/ENIGMAsystem/SHELL files.  What this means is that the Run, Debug, and Compile"
	einfo "buttons on LateralGM will not be available until ENIGMA is done.  You need to wait."
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils git-r3

DESCRIPTION=".NET build tool"
HOMEPAGE="http://nant.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-2.0"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/nant/nant.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="19bec6eca205af145e3c176669bbd57e1712be2a"
        git-r3_fetch
        git-r3_checkout

}

src_compile() {

	emake TARGET=mono-4.5 MCS="mcs -sdk:4.5"
}

src_install() {
	emake prefix="${ED}/usr" TARGET=mono-4.5 MCS="mcs -sdk:4.5" install

	# Fix ${ED} showing up in the nant wrapper script, as well as silencing
	# warnings related to the log4net library
	sed -i \
		-e "s:${ED}::" \
		-e "2iexport MONO_SILENT_WARNING=1" \
		-e "s:${ED}::" \
		"${ED}"/usr/bin/nant || die "Sed nant failed"

	dodoc README.txt
}

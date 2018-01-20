# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils check-reqs

DESCRIPTION="Alice"
HOMEPAGE="http://www.alice.org"
MY_V="${PV:0:3}"
SRC_URI="http://www.alice.org/downloads/${MY_V}/Alice${MY_V//./_}e.tar.gz"

LICENSE="ALICE2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( virtual/jre virtual/jdk  )"
DEPEND="${RDEPEND}"

CHECKREQS_DISK_BUILD="914M"
CHECKREQS_DISK_USR="475M"

FEATURES=""

S="${WORKDIR}/Alice 2.4"

src_unpack() {
	unpack "${A}"
}

src_install() {
	dodir /opt/alice2
	insinto /opt/alice2
	doins -r "${S}"/Required/*
	fperms o+x /opt/alice2/run-alice
	dodir /opt/alice2/jython-2.1/cachedir/packages
	fperms o+w opt/alice2/jython-2.1/cachedir/packages

	cd "${S}/Required/lib"
	jar xvf alice.jar "edu/cmu/cs/stage3/alice/authoringtool/images/aliceHead.gif"
	dodir /usr/share/alice2
	insinto /opt/alice2
	doins edu/cmu/cs/stage3/alice/authoringtool/images/aliceHead.gif
	rm -rf edu

	make_desktop_entry "/bin/sh -c \"cd /opt/alice2; ./run-alice\"" "Alice 2" "/usr/share/alice2/aliceHead.gif" "Education;ComputerScience"
	dodir /usr/bin
	exeinto /usr/bin
	echo '#!/bin/bash' > alice2 || die
	echo 'cd "/opt/alice2"' >> alice2 || die
	echo './run-alice' >> alice2 || die
	doexe alice2
}

pkg_postinst() {
	elog "If you are using dwm or non-parenting window manager or just get grey windows, you need to:"
	elog "  emerge wmname"
	elog "  wmname LG3D"
	elog "Run 'wmname LG3D' before you run 'run-alice'"
}

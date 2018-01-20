# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils check-reqs

DESCRIPTION="Alice"
HOMEPAGE="http://www.alice.org"
PKG="Alice3_unix_Offline_${PV//./_}.sh"
SRC_URI="http://www.alice.org/downloads/installers/${PKG}"

LICENSE="ALICE3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( virtual/jre virtual/jdk  )"
DEPEND="${RDEPEND}"

CHECKREQS_DISK_BUILD="2061M"
CHECKREQS_DISK_USR="1145M"

FEATURES=""

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${PKG} "${T}" || die
}

src_prepare() {
	sed -e "s|\$app_java_home/bin/java\" -Dinstall4j.jvmDir=\"\$app_java_home\"|\$app_java_home/bin/java\" -Dinstall4j.jvmDir=\"${T}\" -Duser.home=\"${T}\" -Djava.util.prefs.systemRoot=\"${T}\" -Djava.util.prefs.userRoot=${T}/home/dummy |" \
		"${DISTDIR}"/${PKG} > ${T}/${PKG}
	chmod +x ${T}/${PKG}
	eapply_user
}

src_install() {
	addpredict $(ls -d /opt/oracle-jdk-bin-*/jre)/.systemPrefs/com
	addpredict /usr/lib64/icedtea7/jre/.systemPrefs/com
	dodir /opt/alice3
	insinto /opt/alice3
	mkdir -p "${T}"/home/dummy/Desktop
	mkdir -p "${T}"/home/dummy/applications
	mkdir -p "${T}"/share
	mkdir -p "${T}"/etc
	mkdir -p "${T}"/jre
	"${T}"/${PKG} -q -dir "${D}/opt/alice3" \
		-Vsys.symlinkDir=${T}/share
	rm "${D}/opt/alice3/Alice 3.desktop"
	make_desktop_entry "/bin/sh \"/opt/alice3/Alice 3\"" "Alice 3" "/opt/alice3/.install4j/Alice 3.png" "Education;ComputerScience"
	sed -i -e 's|/var/tmp/portage/dev-lang/alice-3.2.5.0.0/image||g' -e "s|/var/tmp/portage/dev-lang/alice-3.2.5.0.0/temp/share|/opt/alice3/share|g" "${D}"/opt/alice3/.install4j/response.varfile || die
	rm -rf "${D}"/opt/alice3/share
	dodir /usr/bin
	insinto /usr/bin
	echo '#!/bin/bash' > "${D}/usr/bin/alice3"
	echo 'cd "/opt/alice3"' >> "${D}/usr/bin/alice3"
	echo './"Alice 3"' >> "${D}/usr/bin/alice3"
	fperms +x /usr/bin/alice3
}

pkg_postinst() {
	elog "If you are using dwm or non-parenting window manager or just get grey windows, you need to:"
	elog "  emerge wmname"
	elog "  wmname LG3D"
	elog "Run 'wmname LG3D' before you run 'Alice 3'"
}

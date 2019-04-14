# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils versionator #check-reqs

DESCRIPTION="Alice"
HOMEPAGE="http://www.alice.org"
MY_V="$(get_version_component_range 1-2 ${PV})"
FILE_V="${MY_V//./_}"
PKG="Alice3_unix_${FILE_V}.sh"

SRC_URI="http://www.alice.org/wp-content/uploads/2019/04/${PKG}
	 netbeans? ( http://www.alice.org/wp-content/uploads/2017/05/Alice3NetBeans8Plugin_${FILE_V}.nbm )"

LICENSE="ALICE3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="netbeans_modules_alice3"

RDEPEND="|| ( virtual/jre virtual/jdk  )
	 netbeans_modules_alice3? ( dev-util/netbeans )"
DEPEND="${RDEPEND}"

#CHECKREQS_DISK_BUILD="2061M"
#CHECKREQS_DISK_USR="1455M"

S="${WORKDIR}"


src_unpack() {
	cp "${DISTDIR}"/${PKG} "${T}" || die
}

src_prepare() {
	sed -e "s|\$app_java_home/bin/java\" -Dinstall4j.jvmDir=\"\$app_java_home\"|\$app_java_home/bin/java\" -Dinstall4j.jvmDir=\"${T}\" -Duser.home=\"${T}\" -Djava.util.prefs.systemRoot=\"${T}\" -Djava.util.prefs.userRoot=${T}/home/dummy |" \
		"${DISTDIR}"/${PKG} > ${T}/${PKG} || die
	chmod +x ${T}/${PKG} || die
	eapply_user
}

src_install() {
	ICEDTEA_BIN_V=$(java -version 2>&1 | grep -e "OpenJDK Runtime Environment" | sed -E -e "s|OpenJDK Runtime Environment \(IcedTea ([0-9.]+)\).*|\1|g")
	if [ -d /opt/icedtea-bin-${ICEDTEA_BIN_V} ] ; then
		addpredict /opt/icedtea-bin-${ICEDTEA_BIN_V}/jre/.systemPrefs/com
	fi
	if [ -d $(ls -d /opt/oracle-jdk-bin-*/jre) ] ; then
		addpredict $(ls -d /opt/oracle-jdk-bin-*/jre)/.systemPrefs/com
	fi
	if [ -d /usr/lib64/icedtea7/jre/.systemPrefs/com ] ; then
		addpredict /usr/lib64/icedtea7/jre/.systemPrefs/com
	fi
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

	local d="/opt/alice3"
	local cmd="alice3"

	make_desktop_entry "/usr/bin/${cmd}" "Alice 3" "/opt/alice3/.install4j/Alice 3.png" "Education;ComputerScience"
	sed -i -e 's|/var/tmp/portage/${CATEGORY}/${P}/image||g' -e "s|/var/tmp/portage/${CATEGORY}/${P}/temp/share|/opt/alice3/share|g" "${D}"/opt/alice3/.install4j/response.varfile || die
	rm -rf "${D}"/opt/alice3/share
	dodir /usr/bin
	exeinto /usr/bin

	echo '#!/bin/bash' > ${cmd} || die
	echo 'which wmname' >> ${cmd} || die
	echo 'R_WMNAME="$?"' >> ${cmd} || die
	echo 'pidof dwm > /dev/null' >> ${cmd} || die
	echo 'R_DWM="$?"' >> ${cmd} || die
	echo 'if [[ "$R_DWM" == "0" && "$R_WMNAME" == "0" ]] ; then' >> ${cmd} || die
	echo '  wmname LG3D &' >> ${cmd} || die
	echo 'fi' >> ${cmd} || die
	echo "cd \"${d}\"" >> ${cmd} || die
	echo './"Alice 3"' >> ${cmd} || die
	doexe ${cmd}

	if use netbeans_modules_alice3; then
		insinto /usr/share/netbeans-${cluster}-${SLOT}
		doins -r Alice3NetBeans8Plugin_${FILE_V}.nbm
	fi
}

pkg_postinst() {
	elog "If you are using dwm or non-parenting window manager or just get grey windows, you need to:"
	elog "  emerge wmname"
	elog "  wmname LG3D"
	elog "Run 'wmname LG3D' before you run 'Alice 3'"
}

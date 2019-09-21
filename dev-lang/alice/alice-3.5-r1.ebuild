# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit check-reqs desktop eutils

DESCRIPTION="Alice"
HOMEPAGE="http://www.alice.org"
MY_V="$(ver_cut 1-2 ${PV})"
FILE_V="${MY_V//./_}"
PKG="Alice3_unix_${FILE_V}.sh"

SRC_URI="http://www.alice.org/wp-content/uploads/2019/04/${PKG}"

LICENSE="ALICE3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="netbeans_modules_alice3"

RDEPEND="|| ( virtual/jre virtual/jdk  )
	 netbeans_modules_alice3? ( dev-java/netbeans-alice )"
DEPEND="${RDEPEND}"

CHECKREQS_DISK_BUILD="1423M"
CHECKREQS_DISK_USR="1423M"

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
	[ -d /opt/icedtea-bin-${ICEDTEA_BIN_V} ] && \
		addpredict /opt/icedtea-bin-${ICEDTEA_BIN_V}/jre/.systemPrefs/com
	[ -d $(ls -d /opt/oracle-jdk-bin-*/jre) ] && \
		addpredict $(ls -d /opt/oracle-jdk-bin-*/jre)/.systemPrefs/com
	[ -d /usr/lib64/icedtea7/jre/.systemPrefs/com ] && \
		addpredict /usr/lib64/icedtea7/jre/.systemPrefs/com
	dodir /opt/alice3
	insinto /opt/alice3
	mkdir -p "${T}"/home/dummy/Desktop || die
	mkdir -p "${T}"/home/dummy/applications || die
	mkdir -p "${T}"/share || die
	mkdir -p "${T}"/etc || die
	mkdir -p "${T}"/jre || die
	"${T}"/${PKG} -q -dir "${D}/opt/alice3" \
		-Vsys.symlinkDir=${T}/share || die
	rm "${D}/opt/alice3/Alice 3.desktop" || die

	local d="/opt/alice3"
	local cmd="alice3"

	newicon "${D}/opt/alice3/.install4j/Alice 3.png" alice3.png
	make_desktop_entry "/usr/bin/${cmd}" "Alice 3" "/usr/share/pixmaps/alice3.png" "Education;ComputerScience"
	sed -i -e 's|/var/tmp/portage/${CATEGORY}/${P}/image||g' -e "s|/var/tmp/portage/${CATEGORY}/${P}/temp/share|/opt/alice3/share|g" "${D}"/opt/alice3/.install4j/response.varfile || die
	rm -rf "${D}"/opt/alice3/share || die
	dodir /usr/bin
	exeinto /usr/bin

	doexe "${FILESDIR}/alice3"
}

pkg_postinst() {
	elog "If you are using dwm or non-parenting window manager or just get grey windows, you need to:"
	elog "  emerge wmname"
	elog "  wmname LG3D"
	elog "Run 'wmname LG3D' before you run 'Alice 3'"
}

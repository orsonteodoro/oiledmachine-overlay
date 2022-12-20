# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="116M"
CHECKREQS_DISK_OPT="116M"
inherit check-reqs

MY_PV=$(ver_cut 3 ${PV})

DESCRIPTION="Android SDK Command-line Tools"
HOMEPAGE="https://developer.android.com/studio/command-line"
LICENSE="
	android
	Apache-2.0
	BSD
	BSD-4
	CCDL-1.1
	EPL-1.0
	GPL-2-with-classpath-exception
	LGPL-2.1
	MIT
	W3C
	W3C-document
	|| ( LGPL-2.1 Apache-2.0 )
"
# Apache-2.0, BSD, MIT - ./cmdline-tools/lib/LICENSE
# Apache-2.0, BSD, CDDL-1.1 EPL-1.0, MIT, LGPL-2.1  - ./cmdline-tools/NOTICE.txt
# (Apache-2.0 LGPL-2.1+) ./cmdline-tools/lib/external/net/java/dev/jna/jna-platform/5.6.0/META-INF/LICENSE
# BSD-4 ./cmdline-tools/lib/external/lint-psi/intellij-core/META-INF/NOTICE.txt
# BSD EPL-1.0 ./cmdline-tools/lib/external/jakarta/activation/jakarta.activation-api/1.2.1/META-INF/NOTICE.md
# CDDL-1.1 ./cmdline-tools/lib/external/com/sun/activation/javax.activation/1.2.0/META-INF/LICENSE.txt
# CDDL-1.1, GPL-2-with-classpath-exception - # \
#   cmdline-tools/lib/external/com/sun/activation/javax.activation/1.2.0/META-INF/maven/com.sun.activation/javax.activation/pom.xml
#   https://github.com/javaee/activation/blob/master/LICENSE.txt
# custom, BSD, (Apache-2.0 W3C public-domain), Apache-2.0, MIT, # \
#   (Apache-2.0 || (MIT GPL-1+)), custom Apache-1.1, EPL, pending license, - # \
#   ./cmdline-tools/lib/external/com/sun/xml/fastinfoset/FastInfoset/1.2.16/META-INF/NOTICE.md
# W3C SOFTWARE NOTICE AND LICENSE - ./cmdline-tools/lib/external/xml-apis/xml-apis/1.4.01/license/LICENSE.dom-software.txt
# W3C-document ./cmdline-tools/lib/external/xml-apis/xml-apis/1.4.01/license/LICENSE.dom-documentation.txt
KEYWORDS="~amd64"
SLOT="0"
BDEPEND="dev-util/android-sdk-update-manager"
# libjnidispatch.so
# liblz4-java.so
# libnative-platform-curses.so
SO_RDEPEND="
        sys-devel/gcc
        sys-libs/ncurses-compat:5[tinfo]
        sys-libs/glibc
"
RDEPEND="
	${SO_RDEPEND}
	app-arch/unzip
	app-arch/xz-utils
	app-arch/zip
	app-shells/bash
	dev-vcs/git
	net-misc/curl
	sys-apps/coreutils
	>=virtual/jre-11:11
"
DEPEND="${RDEPEND}"
SRC_URI="
https://dl.google.com/android/repository/commandlinetools-linux-${MY_PV}_latest.zip
"
S="${WORKDIR}/${PN//android-sdk-/}"

pkg_pretend() {
	check-reqs_pkg_pretend
	_check-reqs_disk \
		"${EROOT%/}/opt" \
		"${CHECKREQS_DISK_OPT}"
}

pkg_setup() {
	check-reqs_pkg_setup
	_check-reqs_disk \
		"${EROOT%/}/opt" \
		"${CHECKREQS_DISK_OPT}"
}

src_install() {
	insinto /opt/android-sdk-update-manager/cmdline-tools/latest/
	doins -r bin
	doins -r lib
	chmod +x "${ED}/opt/android-sdk-update-manager/cmdline-tools/latest/bin/"*
	dodoc source.properties NOTICE.txt
	cat <<EOF > "${T}/99${PN}"
PATH="${EPREFIX}/opt/android-sdk-update-manager/cmdline-tools/latest/bin"
USER_PATH="${EPREFIX}/opt/android-sdk-update-manager/cmdline-tools/latest/bin"
EOF
	doenvd "${T}/99${PN}"
}

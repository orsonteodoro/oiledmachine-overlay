# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="116M"
CHECKREQS_DISK_OPT="116M"
inherit check-reqs

MY_PV=$(ver_cut 3 ${PV})
MY_PN="cmdline-tools"

DESCRIPTION="Android SDK Command-line Tools"
HOMEPAGE="https://developer.android.com/studio/command-line"
LICENSE="
	android
	Apache-2.0
	( custom Apache-1.1 )
	( Apache-2.0 || ( MIT GPL-2+ ) )
	BSD
	BSD-4
	CDDL-1.1
	EPL-1.0
	GPL-2-with-classpath-exception
	LGPL-2.1
	MIT
	W3C
	W3C-Document-License
	W3C-Software-Notice-and-License
	|| ( LGPL-2.1 Apache-2.0 )
"
# BSD
# BSD-4
# EPL
# Apache-2.0
# Apache-2.0, BSD, W3C-Software-Notice-and-License, public-domain, MIT, \
#   (custom Apache-1.1), EPL, SAX-PD, pending [Apache-2.0], \
#   (Apache-2.0 || (MIT GPL-1+)), \
#   || (Apache-2.0 Apache-1.0 BSD public-domain (custom Apache-1.1)) - ./latest/lib/external/org/glassfish/jaxb/txw2/2.3.2/txw2-2.3.2/META-INF/NOTICE.md
# BSD, MIT, Apache-2.0 - ./latest/lib/r8/LICENSE
# CDDL-1.1, GPL-2-with-classpath-exception - ./latest/lib/external/com/sun/activation/javax.activation/1.2.0/javax.activation-1.2.0/META-INF/LICENSE.txt
# LGPL-2.1+, Apache-2.0 - ./latest/lib/external/net/java/dev/jna/jna-platform/5.6.0/jna-platform-5.6.0/META-INF/LICENSE
# MIT - ./latest/lib/external/org/checkerframework/checker-qual/3.5.0/checker-qual-3.5.0/META-INF/LICENSE.txt
# SAX-PD - ./latest/lib/external/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01/license/LICENSE.sax.txt
# W3C-Document-License - ./latest/lib/external/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01/license/LICENSE.dom-documentation.txt
# W3C-Software-Notice-and-License - ./latest/lib/external/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01/license/LICENSE.dom-software.txt
KEYWORDS="~amd64"
SLOT="0"
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
	!dev-util/android-sdk-cmdline-tools
	>=virtual/jre-11:11
	app-arch/unzip
	app-arch/xz-utils
	app-arch/zip
	app-shells/bash
	dev-vcs/git
	net-misc/curl
	sys-apps/coreutils
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/android-sdk-update-manager
"
SRC_URI="
kernel_Darwin? (
https://dl.google.com/android/repository/commandlinetools-mac-${MY_PV}_latest.zip
)
kernel_linux? (
https://dl.google.com/android/repository/commandlinetools-linux-${MY_PV}_latest.zip
)
"
S="${WORKDIR}/${MY_PN}"
RESTRICT="mirror"
ANDROID_SDK_DIR="opt/android-sdk-update-manager"

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
	insinto "/${ANDROID_SDK_DIR}/cmdline-tools/latest/"
	doins -r bin
	doins -r lib
	chmod +x "${ED}/${ANDROID_SDK_DIR}/cmdline-tools/latest/bin/"*
	dodoc source.properties NOTICE.txt
	cat <<EOF > "${T}/99${PN}"
PATH="${EPREFIX}/${ANDROID_SDK_DIR}/cmdline-tools/latest/bin"
USER_PATH="${EPREFIX}/${ANDROID_SDK_DIR}/cmdline-tools/latest/bin"
EOF
	doenvd "${T}/99${PN}"
}

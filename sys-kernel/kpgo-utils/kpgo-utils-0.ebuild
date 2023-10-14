# Distributed under the terms of the GNU General Public License v2

EAPI=8

GATHER_SH_SHA1="7be99d3880b2e904756b3b4036ca0915acf2e12c"
KPGO_CALCSUM_4_9_CPP_SHA1="d048bb9e74c84b86478ac5d790a123c235223e27"
PROCESS_SH_SHA1="27755a66194d32ce419fd44bf03a1638d9341928"
RENAME_SH_SHA1="cc3d30d9cc47bc2a0b96ff142260d44b131e3dee"

SRC_URI="
	kpgo-calcsum-4.9.cpp-${KPGO_CALCSUM_4_9_CPP_SHA1:0:7}
	kpgo-gather.sh-${GATHER_SH_SHA1:0:7}
	kpgo-process.sh-${PROCESS_SH_SHA1:0:7}
	kpgo-rename.sh-${RENAME_SH_SHA1:0:7}
"
# The hashes are first 7 digit sha1sum of that file.

DESCRIPTION="KPGO scripts and calcsum tool"
HOMEPAGE="
http://coolypf.com/kpgo.htm
"
LICENSE="
	all-rights-reserved
"
KEYWORDS="~amd64 ~x86"
SLOT="0"
S="${WORKDIR}"
RESTRICT="fetch"
RDEPEND="
	app-shells/bash
	sys-devel/gcc
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"

pkg_nofetch() {
local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
eerror
eerror "You must download the following files from http://coolypf.com."
eerror "After downloading them, rename them, save them in ${EDISTDIR}."
eerror
eerror "calcsum-4.9.cpp -> kpgo-calcsum-4.9.cpp-${KPGO_CALCSUM_4_9_CPP_SHA1:0:7}"
eerror "gather.sh       -> kpgo-gather.sh-${GATHER_SH_SHA1:0:7}"
eerror "process.sh      -> kpgo-process.sh-${PROCESS_SH_SHA1:0:7}"
eerror "rename.sh       -> kpgo-rename.sh-${RENAME_SH_SHA1:0:7}"
eerror
eerror "The 7 digit code is the sha1sum of that file."
eerror
}

src_unpack() {
	cat "${DISTDIR}/kpgo-calcsum-4.9.cpp-${KPGO_CALCSUM_4_9_CPP_SHA1:0:7}" > "${WORKDIR}/calcsum-4.9.cpp" || die
	cat "${DISTDIR}/kpgo-gather.sh-${GATHER_SH_SHA1:0:7}" > "${WORKDIR}/gather.sh" || die
	cat "${DISTDIR}/kpgo-process.sh-${PROCESS_SH_SHA1:0:7}" > "${WORKDIR}/process.sh" || die
	cat "${DISTDIR}/kpgo-rename.sh-${RENAME_SH_SHA1:0:7}" > "${WORKDIR}/rename.sh" || die
}

src_compile() {
	export CXX="${CXX:-g++}"
	${CXX} -o calcsum calcsum-4.9.cpp || die
}

src_install() {
	insinto /usr/$(get_libdir)/kpgo-utils
	exeinto /usr/$(get_libdir)/kpgo-utils
	doexe gather.sh
	doexe process.sh
	doexe rename.sh
	doins calcsum-4.9.cpp
	doexe calcsum
}

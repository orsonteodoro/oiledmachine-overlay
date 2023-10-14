# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI="
	kpgo-gather.sh-7be99d3
	kpgo-process.sh-27755a6
	kpgo-rename.sh-cc3d30d
	kpgo-calcsum-4.9.cpp-d048bb9
"
# The hashes are first 7 digit sha1sum of that file.

DESCRIPTION="KPGO scripts and tool"
HOMEPAGE="
http://coolypf.com/kpgo.htm
"
LICENSE="
	!skip-install? (
		all-rights-reserved
	)
"
IUSE="skip-install"
KEYWORDS="~amd64 ~x86"
SLOT="0"
S="${WORKDIR}"
RESTRICT="fetch"

pkg_nofetch() {
	use skip-install && return
local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
eerror
eerror "You must download the following files from http://coolypf.com."
eerror "After downloading them, rename them, save them in ${EDISTDIR}."
eerror
eerror "gather.sh       -> kpgo-gather.sh-7be99d3"
eerror "process.sh      -> kpgo-process.sh-27755a6"
eerror "rename.sh       -> kpgo-rename.sh-cc3d30d"
eerror "calcsum-4.9.cpp -> kpgo-calcsum-4.9.cpp-d048bb9"
eerror
}

src_unpack() {
	use skip-install && return
	cat "${DISTDIR}/kpgo-gather.sh-7be99d3" > "${WORKDIR}/gather.sh" || die
	cat "${DISTDIR}/kpgo-process.sh-27755a6" > "${WORKDIR}/process.sh" || die
	cat "${DISTDIR}/kpgo-rename.sh-cc3d30d" > "${WORKDIR}/rename.sh" || die
	cat "${DISTDIR}/kpgo-calcsum-4.9.cpp-d048bb9" > "${WORKDIR}/calcsum-4.9.cpp" || die
}

src_compile() {
	use skip-install && return
	export CXX="${CXX:-g++}"
	${CXX} -o calcsum calcsum-4.9.cpp || die
}

src_install() {
	use skip-install && return
	insinto /usr/$(get_libdir)/kpgo-utils
	exeinto /usr/$(get_libdir)/kpgo-utils
	doexe gather.sh
	doexe process.sh
	doexe rename.sh
	doins calcsum-4.9.cpp
	doexe calcsum
}

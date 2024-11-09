# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, F40

# See https://gstreamer.freedesktop.org/security/
# gstreamer-1.22.x requires 2.62, but 2.64 is strongly recommended

inherit gstreamer-meson

MITIGATION_DATE="Oct 29, 2024" # Advisory date
MITIGATION_URI="https://gstreamer.freedesktop.org/security/"
VULNERABILITIES_FIXED=(
	"CVE-2024-44331;DoS;High"
)
# DoS = Denial of Service
# DT = Data Tampering
# ID = Information Disclosure

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz"

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2+"
SLOT="1.0"
IUSE="+caps +introspection unwind"
RDEPEND="
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	caps? (
		sys-libs/libcap[${MULTILIB_USEDEP}]
	)
	introspection? (
		dev-libs/gobject-introspection:=
	)
	unwind? (
		sys-libs/libunwind[${MULTILIB_USEDEP}]
		dev-libs/elfutils[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/glib-utils
	app-alternatives/yacc
	app-alternatives/lex
"
DOCS=( "AUTHORS" "ChangeLog" "NEWS" "MAINTAINERS" "README.md" "RELEASE" )

pkg_setup() {
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security vulnerabilities fixed:  ${MITIGATION_URI}"
einfo "Patched vulnerabilities:"
		IFS=$'\n'
		local x
		for x in ${VULNERABILITIES_FIXED[@]} ; do
			local cve=$(echo "${x}" | cut -f 1 -d ";")
			local vulnerability_classes=$(echo "${x}" | cut -f 2 -d ";")
			local severity=$(echo "${x}" | cut -f 3 -d ";")
einfo "${cve}:  ${vulnerability_classes} (CVSS 3.1 ${severity})"
		done
		IFS=$' \t\n'
einfo
einfo "CE = Code Execution"
einfo "DoS = Denial of Service"
einfo "DT = Data Tampering"
einfo "ID = Information Disclosure"
		if [[ "${VULNERABILITIES_FIXED[@]}" =~ "UAF" ]] ; then
einfo "UAF = Use After Free"
		fi
einfo
	fi
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature "unwind" "libunwind")
		$(meson_feature "unwind" "libdw")
		-Dbenchmarks="disabled"
		-Dcheck="enabled"
		-Dexamples="disabled"
		-Dtools=$(multilib_is_native_abi && echo "enabled" || echo "disabled")
	)
	if use caps ; then
		emesonargs+=(
			-Dptp-helper-permissions="capabilities"
		)
	else
		emesonargs+=(
			-Dptp-helper-permissions="setuid-root"
			-Dptp-helper-setuid-user="nobody"
			-Dptp-helper-setuid-group="nobody"
		)
	fi
	gstreamer_multilib_src_configure
}

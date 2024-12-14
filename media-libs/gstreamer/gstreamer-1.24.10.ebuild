# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, F40

# See https://gstreamer.freedesktop.org/security/
# gstreamer-1.22.x requires 2.62, but 2.64 is strongly recommended

inherit gstreamer-meson vf

MITIGATION_DATE="Dec 3, 2024" # Advisory date
MITIGATION_URI="https://gstreamer.freedesktop.org/security/"
SEVERITY_LABEL="CVSS 4.0"
VULNERABILITIES_FIXED=(
	"CVE-2024-47538;DoS, DT, ID;High"
	"CVE-2024-47615;DoS, DT, ID;High"
	"CVE-2024-47613;DoS, DT, ID;High"
	"CVE-2024-47607;DoS, DT, ID;High"
	"CVE-2024-47540;DoS, DT, ID;High"
	"CVE-2024-47606;DoS, DT, ID;High"
	"CVE-2024-47539;DoS, DT, ID;High"
	"CVE-2024-47537;DoS, DT, ID;High"
	"CVE-2024-47774;DoS, DT;Medium"
	"CVE-2024-47778;DoS, DT;Medium"
	"CVE-2024-47777;DoS, DT;Medium"
	"CVE-2024-47776;DoS, DT;Medium"
	"CVE-2024-47775;DoS, DT;Medium"
	"CVE-2024-47600;DoS, DT;Medium"
	"CVE-2024-47596;DoS, DT;Medium"
	"CVE-2024-47597;DoS, DT;Medium"
	"CVE-2024-47543;DoS, DT;Medium"
	"CVE-2024-47598;DoS, DT;Medium"
	"CVE-2024-47834;DoS, ID;Medium"
	"CVE-2024-47835;DoS;Medium"
	"CVE-2024-47541;DoS;Medium"
	"CVE-2024-47603;DoS;Medium"
	"CVE-2024-47601;DoS;Medium"
	"CVE-2024-47602;DoS;Medium"
	"CVE-2024-47599;DoS;Medium"
	"CVE-2024-47546;DoS;Medium"
	"CVE-2024-47544;DoS;Medium"
	"CVE-2024-47545;DoS;Medium"
	"CVE-2024-47542;DoS;Medium"
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
	fi
	vf_show
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

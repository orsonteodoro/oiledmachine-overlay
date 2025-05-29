# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, F40

# See https://gstreamer.freedesktop.org/security/
# gstreamer-1.22.x requires 2.62, but 2.64 is strongly recommended

CFLAGS_HARDENED_USE_CASES="network untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IU"
MITIGATION_DATE="Dec 3, 2024" # Advisory date
MITIGATION_URI="https://gstreamer.freedesktop.org/security/"
SEVERITY_LABEL="CVSS 4.0"
VULNERABILITIES_FIXED=(
	"CVE-2024-47606;CE, DoS, DT, ID;High"
)
# DoS = Denial of Service
# DT = Data Tampering
# ID = Information Disclosure

inherit cflags-hardened gstreamer-meson vf

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz"

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2+"
SLOT="1.0"
IUSE="
+caps +introspection nls unwind
ebuild_revision_13
"
RDEPEND="
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	caps? (
		sys-libs/libcap[${MULTILIB_USEDEP}]
	)
	introspection? (
		dev-libs/gobject-introspection:=
	)
	nls? (
		sys-devel/gettext[${MULTILIB_USEDEP}]
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
	>=sys-devel/bison-2.4
	>=sys-devel/flex-2.5.31[${MULTILIB_USEDEP}]
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
	gstreamer-meson_pkg_setup
}

multilib_src_configure() {
	cflags-hardened_append
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

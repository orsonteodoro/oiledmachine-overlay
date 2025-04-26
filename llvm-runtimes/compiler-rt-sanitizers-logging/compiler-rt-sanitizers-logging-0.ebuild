# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S="${WORKDIR}"

DESCRIPTION="Enable/disable sanitizer system-wide"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
	+production
	ebuild_revision_3
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

src_install() {
	if use production ; then
		doenvd "${FILESDIR}/50${PN}-envd"
	else
ewarn "USE=production is disabled.  This is a critical severity when sanitizers are used."
	fi
ewarn "Do \`env-update;source /etc/profile\` to finish merging ${PN}"
ewarn "Restart computer after changes done."
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

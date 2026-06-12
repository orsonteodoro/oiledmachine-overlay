# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S="${WORKDIR}"

DESCRIPTION="Enable/disable sanitizer logging systemwide"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
	+production
	+gwp-asan
	ebuild_revision_6
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
		cat \
			"${FILESDIR}/50${PN}-envd" \
				> \
			"${T}/50${PN}-envd" \
			|| die
		if use gwp-asan ; then
			sed \
				-i \
				-e "s|#GWP_ASAN|GWP_ASAN|g" \
				"${T}/50${PN}-envd" \
				|| die
		fi
		local gwp_asan_sample_rate=${GWP_ASAN_SAMPLE_RATE:-1}
		sed \
			-i \
			-e "s|@GWP_ASAN_SAMPLE_RATE@|${gwp_asan_sample_rate}|g" \
			"${T}/50${PN}-envd" \
			|| die
		doenvd "${T}/50${PN}-envd"
	else
ewarn
ewarn "USE=production is disabled.  This may expose sensitive addresses and"
ewarn "increase the chances of ASLR bypass."
ewarn
	fi
ewarn
ewarn "Do \`env-update;source /etc/profile\` to finish merging ${PN}"
ewarn "Restart computer after changes done."
ewarn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

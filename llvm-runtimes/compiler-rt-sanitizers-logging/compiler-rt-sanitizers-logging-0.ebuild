# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs

S="${WORKDIR}"

DESCRIPTION="Enable/disable sanitizer system-wide"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
	+production
	ebuild_revision_1
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( )

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="
		~RELOCATABLE
		~RANDOMIZE_BASE
	"
	if [[ "${ARCH}" == "amd64" ]] ; then
		CONFIG_CHECK+="
			~RANDOMIZE_MEMORY
		"
	fi
	WARNING_RELOCATABLE="CONFIG_RELOCATABLE is required for mitigation for non-production compiler-rt-sanitizers and Scudo."
	WARNING_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE (KASLR) is required for mitigation for non-production compiler-rt-sanitizers and Scudo."
	WARNING_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required for mitigation for non-production compiler-rt-sanitizers and Scudo."
	check_extra_config
}

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

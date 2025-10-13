# Copyright
# Ebuild distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_12_5" # Equivalent to GLIBCXX 3.4.30 in prebuilt binary for U22
	"gcc_slot_13_4" # Equivalent to GLIBCXX 3.4.32 in prebuilt binary for U24
)
DOWNLOAD_FILE_12_5="hsa-amd-aqlprofile_1.0.0.70002-56~22.04_amd64.deb"
DOWNLOAD_FILE_13_4="hsa-amd-aqlprofile_1.0.0.70002-56~24.04_amd64.deb"
DOWNLOAD_FOLDER_URI="http://repo.radeon.com/rocm/apt/7.0.2/pool/main/h/hsa-amd-aqlprofile/"
QA_PREBUILT="
/opt/rocm-7.0.2/lib/libhsa-amd-aqlprofile64.so.1.0.70002
/opt/rocm-7.0.2/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-7.0.2/lib/libhsa-amd-aqlprofile64.so.1
"
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit unpacker

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
	gcc_slot_12_5? (
		${DOWNLOAD_FILE_12_5}
	)
	gcc_slot_13_4? (
		${DOWNLOAD_FILE_13_4}
	)
"

DESCRIPTION="AQLPROFILE library for AMD HSA runtime API extension support"
HOMEPAGE="
https://github.com/RadeonOpenCompute/HSA-AqlProfile-AMD-extension
https://github.com/RadeonOpenCompute/ROCm
"
LICENSE="
	hsa-amd-aqlprofile-EULA
	hsa-amd-aqlprofile-DISCLAIMER
	hsa-amd-aqlprofile-LICENSE
"
RESTRICT="binchecks bindist fetch mirror strip"
SLOT="0/${ROCM_SLOT}"
IUSE="
${GCC_COMPAT[@]}
deny-install skip-install
ebuild_revision_2
"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
"
RDEPEND="
"
DEPEND="
	${RDEPEND}
"

pkg_nofetch() {
	use deny-install && die
	use skip-install && return
	# EULA restricted
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "Due to EULA restrictions.  You must manually download."
einfo
einfo "(1) Read https://github.com/ROCm/ROCm/blob/docs/7.0.2/docs/about/license.md?plain=1#L87 for the overview and general guidance."
einfo "    Read and accept the EULA at https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/licenses/hsa-amd-aqlprofile-EULA"
einfo "    Read and accept the DISCLAIMER at https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/licenses/hsa-amd-aqlprofile-DISCLAIMER"
einfo "    Read and accept the LICENSE at https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/licenses/hsa-amd-aqlprofile-LICENSE"
# The hsa-amd-aqlprofile-EULA is the same as the tarball version.  The 2024 EULA from https://www.amd.com/en/legal/eula/amd-software-eula.html is slightly different.
	local f
	if use gcc_slot_12_5 ; then
		f="${DOWNLOAD_FILE_12_5}"
	fi
	if use gcc_slot_13_4 ; then
		f="${DOWNLOAD_FILE_13_4}"
	fi
einfo "(2) Navigate to ${DOWNLOAD_FOLDER_URI} and download ${f} and place it into ${distdir}"
einfo "(3) Sanitize the file permissions of the downloaded files:"
einfo "    chmod 664 ${distdir}/${f}"
einfo "    chown portage:portage ${distdir}/${f}"
einfo "(4) Do the following to tell the package manager you accept the licenses:"
einfo "    mkdir -p /usr/portage/package.license"
einfo "    echo \"${CATEGORY}/${PN} ${PN}-EULA ${PN}-DISCLAIMER ${PN}-LICENSE\" >> /usr/portage/package.license/${PN}"
einfo "(5) Re-emerge the package."
einfo
}

src_unpack(){
	use deny-install && die
	use skip-install && return
        unpack_deb ${A}
}

src_install() {
	use skip-install && return
	mv opt "${ED}" || die
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:
		else
			# Licenses
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

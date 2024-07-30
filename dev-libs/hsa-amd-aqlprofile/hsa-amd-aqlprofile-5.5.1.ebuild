# Copyright
# Ebuild distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOAD_FILE="hsa-amd-aqlprofile_1.0.0.50501-74~22.04_amd64.deb"
DOWNLOAD_FOLDER_URI="https://repo.radeon.com/rocm/apt/5.5.1/pool/main/h/hsa-amd-aqlprofile/"
QA_PREBUILT="
/opt/rocm-5.5.1/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1
/opt/rocm-5.5.1/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1.0.50501
/opt/rocm-5.5.1/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.5.1/lib/libhsa-amd-aqlprofile64.so.1
/opt/rocm-5.5.1/lib/hsa-amd-aqlprofile/librocprofv2_att.so
/opt/rocm-5.5.1/lib/libhsa-amd-aqlprofile64.so.1.0.50501
/opt/rocm-5.5.1/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.5.1/share/doc/hsa-amd-aqlprofile/EULA
/opt/rocm-5.5.1/share/doc/hsa-amd-aqlprofile/DISCLAIMER.txt
/opt/rocm-5.5.1/share/doc/hsa-amd-aqlprofile/LICENSE.md
"
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit unpacker

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
${DOWNLOAD_FILE}
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
RESTRICT="binchecks strip fetch"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="deny-install skip-install ebuild-revision-2"
RDEPEND="
	!dev-libs/hsa-amd-aqlprofile:0
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
einfo "(1) Read https://github.com/ROCm/ROCm/blob/docs/6.1.2/docs/about/license.md?plain=1#L87 for the overview and general guidance."
einfo "(2) Navigate to ${DOWNLOAD_FOLDER_URI} and download ${DOWNLOAD_FILE} and place it into ${distdir}"
einfo "(3) Sanitize the file permissions of the downloaded files:"
einfo "    chmod 664 ${distdir}/${DOWNLOAD_FILE}"
einfo "    chown portage:portage ${distdir}/${DOWNLOAD_FILE}"
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

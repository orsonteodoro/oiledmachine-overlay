# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOAD_FILE="hsa-amd-aqlprofile_1.0.0.50103-66_amd64.deb"
DOWNLOAD_FOLDER_URI="https://repo.radeon.com/rocm/apt/5.1.3/pool/main/h/hsa-amd-aqlprofile/"
QA_PREBUILT="
/opt/rocm-5.1.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1
/opt/rocm-5.1.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1.0.50103
/opt/rocm-5.1.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.1.3/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.1.3/share/doc/hsa-amd-aqlprofile/LICENSE.md
"
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit unpacker

KEYWORDS="~amd64"
S="${WORKDIR}"
SRC_URI="
${DOWNLOAD_FOLDER_URI}${DOWNLOAD_FILE}
"

DESCRIPTION="AQLPROFILE library for AMD HSA runtime API extension support"
HOMEPAGE="
https://github.com/RadeonOpenCompute/HSA-AqlProfile-AMD-extension
https://github.com/RadeonOpenCompute/ROCm
"
LICENSE="
	hsa-amd-aqlprofile-LICENSE
"
RESTRICT="binchecks strip"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="deny-install skip-install ebuild-revision-2"
RDEPEND="
	!dev-libs/hsa-amd-aqlprofile:0
"
DEPEND="
	${RDEPEND}
"

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

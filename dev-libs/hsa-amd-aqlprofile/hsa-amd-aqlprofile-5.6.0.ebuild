# Copyright
# Ebuild distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

SRC_URI="
hsa-amd-aqlprofile_1.0.0.50600-67~22.04_amd64.deb
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
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64"
IUSE="deny-install skip-install"
DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="binchecks fetch"
S="${WORKDIR}"
QA_PREBUILT="
/opt/rocm-5.6.0/lib/libhsa-amd-aqlprofile64.so.1
/opt/rocm-5.6.0/lib/hsa-amd-aqlprofile/librocprofv2_att.so
/opt/rocm-5.6.0/lib/libhsa-amd-aqlprofile64.so.1.0.50600
/opt/rocm-5.6.0/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.6.0/share/doc/hsa-amd-aqlprofile/EULA
/opt/rocm-5.6.0/share/doc/hsa-amd-aqlprofile/DISCLAIMER.txt
/opt/rocm-5.6.0/share/doc/hsa-amd-aqlprofile/LICENSE.md
"

pkg_nofetch() {
	use deny-install && die
	use skip-install && return
	# EULA restricted
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "Due to EULA restrictions.  You must manually download."
einfo
einfo "Go to https://repo.radeon.com/rocm/apt/5.6/pool/main/h/hsa-amd-aqlprofile/"
einfo "Download hsa-amd-aqlprofile_1.0.0.50600-67~22.04_amd64.deb"
einfo "Place the download in ${distdir}"
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
			:;
		else
			# Licenses
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

# Copyright
# Ebuild distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit unpacker

SRC_URI="
hsa-amd-aqlprofile_1.0.0.50203-109_amd64.deb
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
SLOT="${ROCM_SLOT}/${PV}"
KEYWORDS="~amd64"
IUSE="deny-install skip-install r2"
RDEPEND="
	!dev-libs/hsa-amd-aqlprofile:0
"
DEPEND="
	${RDEPEND}
"
RESTRICT="binchecks strip fetch"
S="${WORKDIR}"
QA_PREBUILT="
/opt/rocm-5.2.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1
/opt/rocm-5.2.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1.0.50203
/opt/rocm-5.2.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.2.3/lib/libhsa-amd-aqlprofile64.so.1
/opt/rocm-5.2.3/lib/libhsa-amd-aqlprofile64.so.1.0.50203
/opt/rocm-5.2.3/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.2.3/share/doc/hsa-amd-aqlprofile/EULA
/opt/rocm-5.2.3/share/doc/hsa-amd-aqlprofile/DISCLAIMER.txt
/opt/rocm-5.2.3/share/doc/hsa-amd-aqlprofile/LICENSE.md
"

pkg_nofetch() {
	use deny-install && die
	use skip-install && return
	# EULA restricted
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "Due to EULA restrictions.  You must manually download."
einfo
einfo "Go to https://repo.radeon.com/rocm/apt/5.2.3/pool/main/h/hsa-amd-aqlprofile/"
einfo "Download hsa-amd-aqlprofile_1.0.0.50203-109_amd64.deb"
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

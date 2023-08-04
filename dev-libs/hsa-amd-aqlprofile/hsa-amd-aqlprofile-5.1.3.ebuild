# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

SRC_URI="
https://repo.radeon.com/rocm/apt/5.1.3/pool/main/h/hsa-amd-aqlprofile/hsa-amd-aqlprofile_1.0.0.50103-66_amd64.deb
"

DESCRIPTION="AQLPROFILE library for AMD HSA runtime API extension support"
HOMEPAGE="
https://github.com/RadeonOpenCompute/HSA-AqlProfile-AMD-extension
https://github.com/RadeonOpenCompute/ROCm
"
LICENSE="
	hsa-amd-aqlprofile-LICENSE
"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64"
IUSE="skip-install"
DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="binchecks"
S="${WORKDIR}"
QA_PREBUILT="
/opt/rocm-5.1.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1
/opt/rocm-5.1.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1.0.50103
/opt/rocm-5.1.3/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.1.3/lib/libhsa-amd-aqlprofile64.so
/opt/rocm-5.1.3/share/doc/hsa-amd-aqlprofile/LICENSE.md
"

src_unpack(){
        unpack_deb ${A}
}

src_install() {
	use skip-install && return
	mv opt "${ED}" || die
	local path
einfo "Sanitizing file/folder permissions"
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}"
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}"
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:;
		else
			# Licenses
			chmod 0644 "${path}" || die
		fi
	done
}

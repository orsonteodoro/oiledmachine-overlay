# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Version based on filename of amdgpu-dkms

DRIVER_HOMEPAGE="" # Missing

DOWNLOAD_FOLDER_URI_1="http://repo.radeon.com/amdgpu/22.10.3/ubuntu/pool/proprietary/o/opencl-legacy-amdgpu-pro/"
DOWNLOAD_FILE_AMD64_1="opencl-legacy-amdgpu-pro-icd_22.10.3-1420322_amd64.deb"
DOWNLOAD_FILE_I386_1="opencl-legacy-amdgpu-pro-icd_22.10.3-1420322_i386.deb"

DOWNLOAD_FOLDER_URI_2="http://repo.radeon.com/amdgpu/22.10.3/ubuntu/pool/main/libd/libdrm-amdgpu/"
DOWNLOAD_FILE_AMD64_2="libdrm-amdgpu-amdgpu1_2.4.109.50103-1420323_amd64.deb"
DOWNLOAD_FILE_I386_2="libdrm-amdgpu-amdgpu1_2.4.109.50103-1420322_i386.deb"

LLVM_SLOT=17
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit multilib-build unpacker

KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"
SRC_URI="
abi_x86_64? (
	${DOWNLOAD_FILE_AMD64_1}
	${DOWNLOAD_FILE_I386_1}
)
abi_x86_32? (
	${DOWNLOAD_FILE_AMD64_2}
	${DOWNLOAD_FILE_I386_2}
)
"

DESCRIPTION="Legacy OpenCL support for AMDGPU-PRO drivers"
HOMEPAGE=""
LICENSE="AMD-GPU-PRO-EULA"
SLOT="0/${PV}"
IUSE+=" ebuild-revision-0"
RDEPEND="
	!dev-libs/amdgpu-pro-opencl
	>=sys-libs/glibc-2.12
	>=virtual/opencl-3
	!media-libs/mesa[opencl]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/patchelf
"
PATCHES=(
)

pkg_nofetch() {
	# EULA restricted
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "Due to EULA restrictions.  You must manually download."
einfo
einfo "(1) Read https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/amdgpu-install.html for the installer frontend and repo access."
einfo "    Read https://amdgpu-install.readthedocs.io/en/latest/install-prereq.html#downloading-the-installer-package for repo access."
einfo "    Read https://www.amd.com/en/legal/eula/amd-software-eula.html for the EULA."
einfo "(2a) Navigate to ${DOWNLOAD_FOLDER_URI_1} and download ${DOWNLOAD_FILE_AMD64_1} and place into ${distdir}"
einfo "(2b) Navigate to ${DOWNLOAD_FOLDER_URI_1} and download ${DOWNLOAD_FILE_I386_1} and place into ${distdir}"
einfo "(2c) Navigate to ${DOWNLOAD_FOLDER_URI_2} and download ${DOWNLOAD_FILE_AMD64_2} and place into ${distdir}"
einfo "(2d) Navigate to ${DOWNLOAD_FOLDER_URI_2} and download ${DOWNLOAD_FILE_I386_2} and place into ${distdir}"
einfo "(3a) chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64_1}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64_1}"
einfo "(3b) chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64_2}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64_2}"
einfo "(3c) chmod 664 ${distdir}/${DOWNLOAD_FILE_I386_1}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_I386_1}"
einfo "(3d) chmod 664 ${distdir}/${DOWNLOAD_FILE_I386_2}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_I386_2}"
einfo "(4) mkdir -p /usr/portage/package.license && echo \"${CATEGORY}/${PN} AMD-GPU-PRO-EULA\" >> /usr/portage/package.license/${PN}"
einfo "(5) Re-emerge the package."
einfo
}

src_unpack(){
	if use abi_x86_64 ; then
		unpack_deb ${DOWNLOAD_FILE_AMD64_1}
		unpack_deb ${DOWNLOAD_FILE_AMD64_2}
	fi
	if use abi_x86_32 ; then
		unpack_deb ${DOWNLOAD_FILE_I386_1}
		unpack_deb ${DOWNLOAD_FILE_I386_2}
	fi
}

src_prepare() {
	:
}

src_configure() {
	:
}

src_install() {
	if use abi_x86_64 ; then
		patchelf --set-rpath '$ORIGIN' "${ED}/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdocl-orca64.so" || die
	fi
	if use abi_x86_32 ; then
		patchelf --set-rpath '$ORIGIN' "${ED}/opt/amdgpu-pro/lib/i386-linux-gnu/libamdocl-orca32.so" || die
	fi
	mv etc usr opt "${ED}" || die
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

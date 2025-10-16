# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Version same as folder

GCC_COMPAT=(
	#"gcc_slot_9_1" # U20, EOL on distro
	"gcc_slot_11_5" # U22
)

DRIVER_HOMEPAGE="https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-UNIFIED-LINUX-23-20.html"

DOWNLOAD_1_PV="23.20"
DOWNLOAD_FOLDER_URI_1="http://repo.radeon.com/amdgpu/5.7.1/ubuntu/pool/proprietary/o/opencl-legacy-amdgpu-pro/"
DOWNLOAD_FILE_AMD64_U22_1="opencl-legacy-amdgpu-pro-icd_23.20-1664987.22.04_amd64.deb"
DOWNLOAD_FILE_I386_U22_1="opencl-legacy-amdgpu-pro-icd_23.20-1664987.22.04_i386.deb"

DOWNLOAD_2_PV="2.4.115.50701"
LIBDRM_PV="${DOWNLOAD_2_PV%.*}"
DOWNLOAD_FOLDER_URI_2="http://repo.radeon.com/amdgpu/5.7.1/ubuntu/pool/main/libd/libdrm-amdgpu/"
DOWNLOAD_FILE_AMD64_U22_2="libdrm-amdgpu-amdgpu1_2.4.115.50701-1664922.22.04_amd64.deb"
DOWNLOAD_FILE_I386_U22_2="libdrm-amdgpu-amdgpu1_2.4.115.50701-1664922.22.04_i386.deb"

LLVM_SLOT=17
PYTHON_COMPAT=( "python3_"{10..12} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit multilib-build unpacker

KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"
SRC_URI="
	gcc_slot_11_5? (
		abi_x86_64? (
			${DOWNLOAD_FILE_AMD64_U22_1}
			!system-libdrm? (
				${DOWNLOAD_FILE_AMD64_U22_2}
			)
		)
		abi_x86_32? (
			${DOWNLOAD_FILE_I386_U22_1}
			!system-libdrm? (
				${DOWNLOAD_FILE_I386_U22_2}
			)
		)
	)
"

DESCRIPTION="Legacy OpenCL support for AMDGPU-PRO drivers"
HOMEPAGE="https://www.amd.com/en/support/download/linux-drivers.html"
LICENSE="
	opencl-legacy-amdgpu-pro-icd-LICENSE
	!system-libdrm? (
		(
			all-rights-reserved
			MIT
		)
		MIT
	)
"
RESTRICT="binchecks bindist fetch mirror strip"
SLOT="0/${PV}"
IUSE+="
${GCC_COMPAT[@]}
system-libdrm
ebuild_revision_0
"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
"
RDEPEND="
	!dev-libs/amdgpu-pro-opencl
	>=sys-libs/glibc-2.12
	>=virtual/opencl-3
	!media-libs/mesa[opencl]
	system-libdrm? (
		>=x11-libs/libdrm-${LIBDRM_PV}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"
PATCHES=(
)

pkg_nofetch_u22() {
	use gcc_slot_11_5 || return
	# EULA restricted
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "Due to EULA restrictions.  You must manually download."
einfo
einfo "(1) Read ${DRIVER_HOMEPAGE} for the overview and general guidance on the driver."
einfo "    Read https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/amdgpu-install.html for the installer frontend and repo access."
einfo "    Read https://amdgpu-install.readthedocs.io/en/latest/install-prereq.html#downloading-the-installer-package for repo access."
einfo "    Read and accept the EULA at https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/licenses/opencl-legacy-amdgpu-pro-icd-LICENSE"
# The opencl-legacy-amdgpu-pro-icd-LICENSE is the same in the tarball.  The https://www.amd.com/en/legal/eula/amd-software-eula.html is slighty different.
einfo "(2) Download these files and place them into ${distdir}."
	if use abi_x86_64 ; then
einfo "     Navigate to ${DOWNLOAD_FOLDER_URI_1} and download ${DOWNLOAD_FILE_AMD64_U22_1}"
	fi
	if use abi_x86_32 ; then
einfo "     Navigate to ${DOWNLOAD_FOLDER_URI_1} and download ${DOWNLOAD_FILE_I386_U22_1}"
	fi
	if ! use system-libdrm ; then
		if use abi_x86_64 ; then
einfo "     Navigate to ${DOWNLOAD_FOLDER_URI_2} and download ${DOWNLOAD_FILE_AMD64_U22_2}"
		fi
		if use abi_x86_32 ; then
einfo "     Navigate to ${DOWNLOAD_FOLDER_URI_2} and download ${DOWNLOAD_FILE_I386_U22_2}"
		fi
	fi
einfo "(3) Do the following to sanitize permissions"
	if use abi_x86_64 ; then
einfo "     chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64_U22_1}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64_U22_1}"
	fi
	if use abi_x86_32 ; then
einfo "     chmod 664 ${distdir}/${DOWNLOAD_FILE_I386_U22_1}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_I386_U22_1}"
	fi
	if ! use system-libdrm ; then
		if use abi_x86_64 ; then
einfo "     chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64_U22_2}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64_U22_2}"
		fi
		if use abi_x86_32 ; then
einfo "     chmod 664 ${distdir}/${DOWNLOAD_FILE_I386_U22_2}"
einfo "     chown portage:portage ${distdir}/${DOWNLOAD_FILE_I386_U22_2}"
		fi
	fi
einfo "(4) To tell the package manager you accepted these licenses, do"
einfo "    mkdir -p /usr/portage/package.license"
einfo "    echo \"${CATEGORY}/${PN} opencl-legacy-amdgpu-pro-icd-LICENSE\" >> /usr/portage/package.license/${PN}"
	if ! use system-libdrm ; then
einfo "    echo \"${CATEGORY}/${PN} all-rights-reserved\" >> /usr/portage/package.license/${PN}"
	fi
einfo "(5) Re-emerge the package."
einfo
}

pkg_nofetch() {
	pkg_nofetch_u22
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

unpack_u22() {
	use gcc_slot_11_5 || return
	if use abi_x86_64 ; then
		unpack_deb ${DOWNLOAD_FILE_AMD64_U22_1}
		if ! use system-libdrm ; then
			unpack_deb ${DOWNLOAD_FILE_AMD64_U22_2}
		fi
	fi
	if use abi_x86_32 ; then
		unpack_deb ${DOWNLOAD_FILE_I386_U22_1}
		if ! use system-libdrm ; then
			unpack_deb ${DOWNLOAD_FILE_I386_U22_2}
		fi
	fi
}

src_unpack(){
	unpack_u22
}

src_configure() {
	:
}

gen_envd() {
	local path=""
	if use abi_x86_64 ; then
		path+=":${EPREFIX}/opt/amdgpu-pro/lib/x86_64-linux-gnu"
	fi
	if use abi_x86_32 ; then
		path+=":${EPREFIX}/opt/amdgpu-pro/lib/i386-linux-gnu"
	fi
	path="${path:1}"
cat <<EOF > "${T}/99${PN}${PV}"
LDPATH="${path}"
EOF
	doenvd "${T}/99${PN}${PV}"
}

src_install() {
	gen_envd
	mv "usr" "opt" "${ED}" || die
	cp -Ta "etc" "${ED}/etc" || die
	local path=""
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		[[ -L "${path}" ]] && continue
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
	if ! use system-libdrm ; then
		mv "${ED}/usr/share/doc/libdrm-amdgpu-amdgpu1"{"","-${DOWNLOAD_1_PV}"} || die
	fi
	mv "${ED}/usr/share/doc/opencl-legacy-amdgpu-pro-icd"{"","-${DOWNLOAD_2_PV}"} || die
}

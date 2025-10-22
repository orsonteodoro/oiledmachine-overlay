# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_11_5" # Support U22
	"gcc_slot_12_5" # Support D12
	"gcc_slot_13_4" # Support U24
	#"gcc_slot_14_3" # Support D13
)

DOWNLOAD_FILE_AMD64_U22="doca-host_2.9.3-021000-24.10-ubuntu2204_amd64.deb"
DOWNLOAD_FILE_AMD64_D12="doca-host_2.9.3-021000-24.10-debian125_amd64.deb"
DOWNLOAD_FILE_AMD64_U24="doca-host_2.9.3-021000-24.10-ubuntu2404_amd64.deb"
DOWNLOAD_HOMEPAGE="https://developer.nvidia.com/doca-downloads"
GLIBC_PV_U22="2.35"
GLIBC_PV_D12="2.36"
GLIBC_PV_U24="2.39"
POOL_DIR_U22="${WORKDIR}/usr/share/doca-host-2.9.3-021000-24.10-ubuntu2204/repo/pool"
POOL_DIR_D12="${WORKDIR}/usr/share/doca-host-2.9.3-021000-24.10-debian125/repo/pool"
POOL_DIR_U24="${WORKDIR}/usr/share/doca-host-2.9.3-021000-24.10-ubuntu2404/repo/pool"
RDMA_CORE_PV="52"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit unpacker libstdcxx-slot python-any-r1

KEYWORDS="~amd64" # It can support arm64, you should fork or make a local copy with changes for the ebuild if you want arm64 support.
S="${WORKDIR}"
SRC_URI="
	amd64? (
		gcc_slot_11_5? (
			${DOWNLOAD_FILE_AMD64_U22}
		)
		gcc_slot_12_5? (
			${DOWNLOAD_FILE_AMD64_D12}
		)
		gcc_slot_13_4? (
			${DOWNLOAD_FILE_AMD64_U24}
		)
	)
"

DESCRIPTION="DOCA-Host"
RESTRICT="binchecks bindist fetch mirror strip"
HOMEPAGE="
https://developer.nvidia.com/networking/doca
"
LICENSE="
	DOCA-EULA
	mlnx-ofed-kernel? (
		GPL-2
		|| (
			GPL-2
			BSD
		)
		|| (
			GPL-2
			Linux-OpenIB
		)
	)
	sharp? (
		BSD
	)
"
SLOT="0"
IUSE+=" hcoll mlnx-ofed-kernel sharp ebuild_revision_1"
REQUIRED_USE="
	^^ (
		${GCC_COMPAT[@]}
	)
	hcoll? (
		sharp
	)
	|| (
		hcoll
		mlnx-ofed-kernel
		sharp
	)
"

MLNX_TOOLS_DEPEND="
	${PYTHON_DEPS}
	sys-apps/pciutils
	sys-process/procps
"
MLNX_OFED_KERNEL_DKMS_DEPEND="
	gcc_slot_11_5? (
		>=sys-libs/glibc-${GLIBC_PV_U22}
		sys-devel/gcc:11
	)
	gcc_slot_12_5? (
		>=sys-libs/glibc-${GLIBC_PV_D12}
		sys-devel/gcc:12
	)
	gcc_slot_13_4? (
		>=sys-libs/glibc-${GLIBC_PV_U24}
		sys-devel/gcc:13
	)
	sys-kernel/dkms
	sys-kernel/linux-headers
"
MLNX_OFED_KERNEL_UTILS_DEPEND="
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/kmod
	sys-apps/pciutils
	sys-process/lsof
	sys-process/procps
"
RDEPEND="
	mlnx-ofed-kernel? (
		${MLNX_OFED_KERNEL_DKMS_DEPEND}
		${MLNX_OFED_KERNEL_UTILS_DEPEND}
		${MLNX_TOOLS_DEPEND}
	)
	hcoll? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
		gcc_slot_11_5? (
			>=sys-libs/glibc-${GLIBC_PV_U22}
		)
		gcc_slot_12_5? (
			>=sys-libs/glibc-${GLIBC_PV_D12}
		)
		gcc_slot_13_4? (
			>=sys-libs/glibc-${GLIBC_PV_U24}
		)
		sys-cluster/ucx
	)
	sharp? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
		gcc_slot_11_5? (
			sys-devel/gcc:11
			>=sys-libs/glibc-${GLIBC_PV_U22}
		)
		gcc_slot_12_5? (
			sys-devel/gcc:12
			>=sys-libs/glibc-${GLIBC_PV_D12}
		)
		gcc_slot_13_4? (
			sys-devel/gcc:13
			>=sys-libs/glibc-${GLIBC_PV_U24}
		)
		sys-cluster/ucx
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"
PATCHES=(
)

pkg_nofetch_amd64_u22() {
	use gcc_slot_11_5 || return
einfo
einfo "(1) To download, please visit:  ${DOWNLOAD_HOMEPAGE}"
einfo
einfo "(2) Read and agree to the ${PV} DOCA EULA:  https://docs.nvidia.com/doca/sdk/nvidia+doca+eula/index.html"
einfo
einfo "(3) The download is EULA restricted (4d).  This ebuild is compatible with"
einfo "the following package config:"
einfo
einfo "DOCA-Server"
einfo "DOCA-Host"
einfo "Linux"
einfo "x86_64"
einfo "doca-all"
einfo "Ubuntu"
einfo "22.04"
einfo "deb (local)"
einfo
einfo "Version:  ${PV}"
einfo "Filename:  ${DOWNLOAD_FILE_AMD64_U22}"
einfo
	if use amd64 ; then
einfo "(4) Sanitize the file permissions of the downloaded files:"
einfo "    chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64_U22}"
einfo "    chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64_U22}"
	fi
einfo "(5) Do the following to tell the package manager you accept the licenses:"
einfo "    mkdir -p /usr/portage/package.license"
einfo "    echo \"${CATEGORY}/${PN} DOCA-EULA\" >> /usr/portage/package.license/${PN}"
}

pkg_nofetch_amd64_d12() {
	use gcc_slot_12_5 || return
einfo
einfo "(1) To download, please visit:  ${DOWNLOAD_HOMEPAGE}"
einfo
einfo "(2) Read and agree to the ${PV} DOCA EULA:  https://docs.nvidia.com/doca/sdk/nvidia+doca+eula/index.html"
einfo
einfo "(3) The download is EULA restricted (4d).  This ebuild is compatible with"
einfo "the following package config:"
einfo
einfo "DOCA-Server"
einfo "DOCA-Host"
einfo "Linux"
einfo "x86_64"
einfo "doca-all"
einfo "Debian"
einfo "12.5"
einfo "deb (local)"
einfo
einfo "Version:  ${PV}"
einfo "Filename:  ${DOWNLOAD_FILE_AMD64_D12}"
einfo
	if use amd64 ; then
einfo "(4) Sanitize the file permissions of the downloaded files:"
einfo "    chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64_D12}"
einfo "    chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64_D12}"
	fi
einfo "(5) Do the following to tell the package manager you accept the licenses:"
einfo "    mkdir -p /usr/portage/package.license"
einfo "    echo \"${CATEGORY}/${PN} DOCA-EULA\" >> /usr/portage/package.license/${PN}"
}

pkg_nofetch_amd64_u24() {
	use gcc_slot_13_4 || return
einfo
einfo "(1) To download, please visit:  ${DOWNLOAD_HOMEPAGE}"
einfo
einfo "(2) Read and agree to the ${PV} DOCA EULA:  https://docs.nvidia.com/doca/sdk/nvidia+doca+eula/index.html"
einfo
einfo "(3) The download is EULA restricted (4d).  This ebuild is compatible with"
einfo "the following package config:"
einfo
einfo "DOCA-Server"
einfo "DOCA-Host"
einfo "Linux"
einfo "x86_64"
einfo "doca-all"
einfo "Ubuntu"
einfo "24.04"
einfo "deb (local)"
einfo
einfo "Version:  ${PV}"
einfo "Filename:  ${DOWNLOAD_FILE_AMD64_U24}"
einfo
	if use amd64 ; then
einfo "(4) Sanitize the file permissions of the downloaded files:"
einfo "    chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64_U24}"
einfo "    chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64_U24}"
	fi
einfo "(5) Do the following to tell the package manager you accept the licenses:"
einfo "    mkdir -p /usr/portage/package.license"
einfo "    echo \"${CATEGORY}/${PN} DOCA-EULA\" >> /usr/portage/package.license/${PN}"
}

pkg_nofetch() {
	pkg_nofetch_amd64_u22
	pkg_nofetch_amd64_u24
}

unpack_amd64() {
# This list is not exaustive.
	use hcoll && L+=(
		"hcoll;hcoll_4.8.3230-1.2410068_amd64.deb"
	)
	use mlnx-ofed-kernel && L+=(
	# dkms
		"mlnx-ofed-kernel;mlnx-ofed-kernel-dkms_24.10.OFED.24.10.3.2.5.1-1_all.deb"

	# utils
		"mlnx-ofed-kernel;mlnx-tools_24.10-0.2410068_amd64.deb"
		"mlnx-ofed-kernel;mlnx-ofed-kernel-utils_24.10.OFED.24.10.3.2.5.1-1_amd64.deb"
	)
	use sharp && L+=(
		"sharp;sharp_3.9.1.MLNX20250604.25aad3d5-1.2410325_amd64.deb"
	)
}

__unpack_deb() {
	local pair="${1}"
	local u="${pair%;*}"
	local tarball_name="${pair#*;}"
	if use "${u}" ; then
einfo "Unpacking ${tarball_name} for USE=${u}"
		if use gcc_slot_11_5 ; then
			unpack_deb "${POOL_DIR_U22}/${tarball_name}"
		elif use gcc_slot_12_5 ; then
			unpack_deb "${POOL_DIR_D12}/${tarball_name}"
		elif use gcc_slot_13_4 ; then
			unpack_deb "${POOL_DIR_U24}/${tarball_name}"
		fi
	fi
}

pkg_setup() {
einfo "This is the LTS release of ${PN}"
	python-any-r1_pkg_setup
	libstdcxx-slot_verify
}

src_unpack() {
        unpack_deb ${A}
	local d="${T}/staging-area"
	local L=()
	mkdir -p "${d}"

	use amd64 && unpack_amd64

	local x
	for x in ${L[@]} ; do
		pushd "${d}" >/dev/null 2>&1 || die
			__unpack_deb "${x}"
		popd >/dev/null 2>&1 || die
	done
}

src_prepare() {
	default
	:
}

src_configure() {
	:
}

sanitize_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Bourne-Again shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Python script" ; then
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

src_install() {
	cd "${T}/staging-area"
	doins -r *
	insinto "/usr/share/doc/doca-host"
	doins "${WORKDIR}/usr/share/doc/doca-host/"*
	sanitize_permissions
}

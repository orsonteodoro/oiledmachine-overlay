# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOAD_FILE_AMD64="doca-host_2.8.0-204000-24.07-ubuntu2404_amd64.deb"
DOWNLOAD_HOMEPAGE="https://developer.nvidia.com/doca-downloads"
GLIBC_PV="2.38"
POOL_DIR="${WORKDIR}/usr/share/doca-host-2.8.0-204000-24.07-ubuntu2404/repo/pool"
RDMA_CORE_PV="52"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit unpacker python-any-r1

KEYWORDS="~amd64" # It can support arm64.
S="${WORKDIR}"
SRC_URI="
	amd64? (
		${DOWNLOAD_FILE_AMD64}
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
	>=sys-libs/glibc-${GLIBC_PV}
	sys-devel/gcc
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
		>=sys-libs/glibc-${GLIBC_PV}
		sys-cluster/ucx
	)
	sharp? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
		>=sys-devel/gcc-11
		>=sys-libs/glibc-${GLIBC_PV}
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

pkg_nofetch() {
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
einfo "Filename:  ${DOWNLOAD_FILE_AMD64}"
einfo
	if use amd64 ; then
einfo "(4) Sanitize the file permissions of the downloaded files:"
einfo "    chmod 664 ${distdir}/${DOWNLOAD_FILE_AMD64}"
einfo "    chown portage:portage ${distdir}/${DOWNLOAD_FILE_AMD64}"
	fi
einfo "(5) Do the following to tell the package manager you accept the licenses:"
einfo "    mkdir -p /usr/portage/package.license"
einfo "    echo \"${CATEGORY}/${PN} DOCA-EULA\" >> /usr/portage/package.license/${PN}"
}

unpack_amd64() {
	use hcoll && L+=(
		"hcoll;hcoll_4.8.3228-1.2407061_amd64.deb"
	)
	use mlnx-ofed-kernel && L+=(
	# dkms
		"mlnx-ofed-kernel;mlnx-ofed-kernel-dkms_24.07.OFED.24.07.0.6.1.1-1_all.deb"

	# utils
		"mlnx-ofed-kernel;mlnx-tools_24.07.0-1.2407061_amd64.deb"
		"mlnx-ofed-kernel;mlnx-ofed-kernel-utils_24.07.OFED.24.07.0.6.1.1-1_amd64.deb"
	)
	use sharp && L+=(
		"sharp;sharp_3.8.0.MLNX20240804.aaa5caab-1.2407061_amd64.deb"
	)
}

__unpack_deb() {
	local pair="${1}"
	local use_flag="${pair%;*}"
	local path="${pair#*;}"
einfo "Unpacking ${path} for USE=${use_flag}"
	unpack_deb "${POOL_DIR}/${path}"
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

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOAD_FILE_AMD64="doca-host_2.8.0-204000-24.07-ubuntu2204_amd64.deb"
DOWNLOAD_HOMEPAGE="https://developer.nvidia.com/doca-downloads"
POOL_DIR="${WORKDIR}/usr/share/doca-host-2.8.0-204000-24.07-ubuntu2204/repo/pool"
RDMA_CORE_PV="52"

inherit unpacker

KEYWORDS="~amd64"
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
	sharp? (
		BSD
	)
"
SLOT="0"
IUSE+=" hcoll sharp ebuild-revision-0"
REQUIRED_USE="
	hcoll? (
		sharp
	)
	|| (
		hcoll
		sharp
	)
"
RDEPEND="
	hcoll? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
		>=sys-libs/glibc-2.34
		sys-cluster/ucx
	)
	sharp? (
		>=sys-cluster/rdma-core-${RDMA_CORE_PV}
		>=sys-devel/gcc-11
		>=sys-libs/glibc-2.3.4
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
einfo "To download, please visit:  ${DOWNLOAD_HOMEPAGE}"
einfo
einfo "The download is EULA restricted (4d).  This ebuild is compatible with"
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
einfo "Filename:  ${DOWNLOAD_FILE_AMD64}"
einfo
}

unpack_hcoll_amd64() {
	use hcoll || return
	pushd "${d}" >/dev/null 2>&1 || die
		unpack_deb "${POOL_DIR}/hcoll_4.8.3228-1.2407061_amd64.deb"
	popd >/dev/null 2>&1 || die
}

unpack_sharp_amd64() {
	use sharp || return
	pushd "${d}" >/dev/null 2>&1 || die
		unpack_deb "${POOL_DIR}/sharp_3.8.0.MLNX20240804.aaa5caab-1.2407061_amd64.deb"
	popd >/dev/null 2>&1 || die
}

src_unpack() {
        unpack_deb ${A}
	local d="${T}/staging-area"
	mkdir -p "${d}"
	if use amd64 ; then
		unpack_hcoll_amd64
		unpack_sharp_amd64
	fi
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

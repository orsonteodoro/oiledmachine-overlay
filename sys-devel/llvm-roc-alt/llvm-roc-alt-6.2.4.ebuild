# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOAD_FOLDER_URI="http://repo.radeon.com/rocm/apt/6.2.4/pool/proprietary/r/rocm-llvm-alt"
DOWNLOAD_FILE="rocm-llvm-alt_17.0.0.24050.60204-139~24.04_amd64.deb"
LLVM_MAX_SLOT=17 # Based on sover and tarball name
MY_PN="rocm-llvm-alt"
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="${PV%.*}"

inherit unpacker

KEYWORDS="
~amd64
"
S="${WORKDIR}"
SRC_URI="
	${DOWNLOAD_FILE}
"

DESCRIPTION="AOCC for ROCm™"
HOMEPAGE="
	https://www.amd.com/en/developer/aocc.html
	https://github.com/ROCm/ROCm/blob/rocm-6.2.4/docs/about/license.md?plain=1#L131
	https://github.com/ROCm/ROCm/blob/rocm-6.1.2/docs/conceptual/compiler-disambiguation.md?plain=1#L17
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	rocm-llvm-alt-EULA
	rocm-llvm-alt-DISCLAIMER
	Apache-2.0-with-LLVM-exceptions
	BSD-2
	UoI-NCSA
"
# all-rights-reserved MIT - llvm/alt/include/llvm/Transforms/Utils/imath.h
# Apache-2.0-with-LLVM-exceptions - llvm/alt/include/lld/Core/SharedLibraryAtom.h
# BSD-2 - llvm/alt/include/llvm/Support/xxhash.h
# UoI-NCSA - llvm/alt/include/clang-tidy/objc/SuperSelfCheck.h
# The distro's MIT license template does not have All Rights Reserved.
RESTRICT="
	binchecks
	bindist
	fetch
	mirror
	strip
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
	ebuild_revision_4
"
REQUIRED_USE="
"
# See also https://github.com/RadeonOpenCompute/rocm-spack/blob/develop/var/spack/repos/builtin/packages/aocc/package.py#L50
# Links to GCC 12.1.0 (particularly libstdc++)
RDEPEND="
	${PYTHON_DEPS}
	>=sys-devel/gcc-12.1.0:12
	>=sys-libs/glibc-2.35
	dev-build/libtool
	dev-libs/libffi
	dev-libs/libxml2
	sys-apps/texinfo
	sys-libs/ncurses-compat:5
	sys-libs/zlib
	virtual/libelf
	~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"

pkg_nofetch() {
	# EULA restricted
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
ewarn
ewarn "In order to obtain/install this package you must:"
ewarn
ewarn "(1) Read https://github.com/ROCm/ROCm/blob/rocm-6.2.4/docs/about/license.md?plain=1#L84 for an overview and general guidance."
ewarn "    Read and accept the EULA at https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/licenses/rocm-llvm-alt-EULA"
ewarn "    Read and accept the DISCLAIMER at https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/licenses/rocm-llvm-alt-DISCLAIMER"
# The tarball's EULA is slightly different from the 2024 version on https://www.amd.com/en/legal/eula/amd-software-eula.html
ewarn "(2) Navigate to ${DOWNLOAD_FOLDER_URI} and download ${DOWNLOAD_FILE} and place the file into ${distdir}"
ewarn "(3) Sanitize the permissions of the downloaded file:"
ewarn "    chmod 664 ${distdir}/${DOWNLOAD_FILE}"
ewarn "    chown portage:portage ${distdir}/${DOWNLOAD_FILE}"
ewarn "(4) Tell the package manager that you accepted the licenses:"
ewarn "    mkdir -p /etc/portage/package.license"
ewarn "    echo \"sys-devel/${PN} ${MY_PN}-EULA ${MY_PN}-DISCLAIMER all-rights-reserved\" >> /etc/portage/package.license/${PN}"
ewarn "(5) Re-emerge the package"
ewarn
}

unpack_deb() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
	unpack $1
	unpacker ./data.tar*
	rm -f debian-binary {control,data}.tar*
}

src_unpack() {
	unpack_deb "${DISTDIR}/${DOWNLOAD_FILE}"
}

sanitize_file_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Perl script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Python script" ; then
			chmod 0755 "${path}" || die
		elif [[ "${path}" =~ ".sh"$ ]] ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	mv \
		"${S}/"* \
		"${ED}" \
		|| die
	sanitize_file_permissions
}

# OILEDMACHINE-OVERLAY-STATUS:  installs-without-problems

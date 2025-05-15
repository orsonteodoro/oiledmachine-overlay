# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOWNLOADED_FILE="${PN}-compiler-${PV}.tar"
LLVM_MAX_SLOT=16 # Based on sover
PYTHON_COMPAT=( "python3_"{11..12} )

KEYWORDS="
~amd64 ~x86
"
S="${WORKDIR}/${PN}-compiler-${PV}"
SRC_URI="
	${DOWNLOADED_FILE}
"

DESCRIPTION="The AOCC compiler system"
HOMEPAGE="https://www.amd.com/en/developer/aocc.html"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	AOCC-${PV%.*}-EULA
	Apache-2.0-with-LLVM-exceptions
	BSD-2
	UoI-NCSA
"
# all-rights-reserved MIT - include/llvm/Transforms/Utils/imath.h
# Apache-2.0-with-LLVM-exceptions - include/llvm/Pass.h
# BSD-2 - include/llvm/Support/xxhash.h
# BSD UoI-NCSA - include/llvm/Analysis/ArrayDFA.h
# The distro's MIT license template does not have All Rights Reserved.
RESTRICT="
	binchecks
	bindist
	fetch
	mirror
	strip
"
SLOT="${LLVM_MAX_SLOT}/${PV}"
IUSE="
	ebuild_revision_3
"
REQUIRED_USE="
"
# See also https://github.com/RadeonOpenCompute/rocm-spack/blob/develop/var/spack/repos/builtin/packages/aocc/package.py#L50
RDEPEND="
	dev-libs/libffi
	dev-libs/libxml2
	sys-apps/texinfo
	sys-devel/gcc
	dev-build/libtool
	sys-libs/glibc
	sys-libs/ncurses
	sys-libs/zlib
	virtual/libelf
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
ewarn "(1) Go to ${HOMEPAGE}"
ewarn "(2) Click the link to ${DOWNLOADED_FILE}"
ewarn "(3) Read and accept the ${PN^^} EULA"
ewarn "(4) Place ${DOWNLOADED_FILE} into ${distdir}"
ewarn "(5) Sanitize the permissions of the downloaded file:"
ewarn "    chmod 644 ${distdir}/${DOWNLOADED_FILE}"
ewarn "    chown portage:portage ${distdir}/${DOWNLOADED_FILE}"
ewarn "(6) Tell the package manager you accepted the licenses:"
ewarn "    mkdir -p /etc/portage/package.license"
ewarn "    echo \"sys-devel/aocc ${PN^^}-${PV%.*}-EULA all-rights-reserved\" >> /etc/portage/package.license/${PN}"
ewarn "(7) Re-emerge the package"
ewarn
}

src_unpack() {
	unpack ${A}
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
	local dest="/opt/aocc/${LLVM_MAX_SLOT}"
	dodir "${dest}"
	mv \
		"${S}/"* \
		"${ED}${dest}" \
		|| die
	sanitize_file_permissions
}

# OILEDMACHINE-OVERLAY-STATUS:  installs-without-problems

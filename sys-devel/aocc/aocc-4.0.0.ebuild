# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14 # Based on sover
PYTHON_COMPAT=( python3_{10..12} )

SRC_URI="
	${PN}-compiler-${PV}.tar
"

DESCRIPTION="The AOCC compiler system"
HOMEPAGE="https://www.amd.com/en/developer/aocc.html"
LICENSE="
	AOCC-${PV%.*}-EULA
	Apache-2.0-with-LLVM-exceptions
	BSD-2
	UoI-NCSA
"
SLOT="${LLVM_MAX_SLOT}/${PV}"
KEYWORDS="
~amd64 ~x86
"
IUSE="
"
REQUIRED_USE="
"
# See also https://github.com/RadeonOpenCompute/rocm-spack/blob/develop/var/spack/repos/builtin/packages/aocc/package.py#L50
RDEPEND="
	dev-libs/libelf
	dev-libs/libffi
	dev-libs/libxml2
	sys-apps/texinfo
	sys-devel/gcc
	sys-devel/libtool
	sys-libs/glibc
	sys-libs/ncurses
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
"
RESTRICT="
	binchecks
	strip
	fetch
"
S="${WORKDIR}/${PN}-compiler-${PV}"

pkg_nofetch() {
	# EULA restricted
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
ewarn
ewarn "In order to obtain/install this package you must:"
ewarn
ewarn "(1) Go to ${HOMEPAGE}"
ewarn "(2) Read and agree to the ${PN^^} EULA"
ewarn "(3) Download ${SRC_URI} and place into ${distdir}"
ewarn "(4) mkdir -p /etc/portage/package.license && echo \"${PN^^}-${PV%.*}-EULA\" > /etc/portage/package.license/${PN,,}"
ewarn "(5) Re-emerge the package"
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
		elif file "${path}" | grep -q -e "Python script" ; then
			chmod 0755 "${path}" || die
		elif [[ "${path}" =~ ".sh"$ ]] ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:;
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

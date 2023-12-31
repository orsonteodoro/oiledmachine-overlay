# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

REV_PV="6"
SRC_URI="
https://download.mono-project.com/repo/ubuntu/pool/main/m/monodevelop/monodevelop-nunit_${PV}-0xamarin${REV_PV}+ubuntu1804b1_all.deb
"
S="${WORKDIR}"

DESCRIPTION="NUnit plugin for MonoDevelop"
HOMEPAGE="
https://www.monodevelop.com/
https://github.com/mono/monodevelop
https://github.com/mono/monodevelop/tree/monodevelop-7.8.4.1/main/tests/TestRunner
https://github.com/nunit/nunitv2/tree/2.6.4
"
# The paths in the copyright are old.
LICENSE="
	MIT
	ZLIB
"
# ZLIB - NUnit
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE=" r1"
REQUIRED_USE=" "
CDEPEND="
"
RDEPEND="
	${CDEPEND}
	>=dev-lang/mono-4
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${CDEPEND}

"
PDEPEND="
	~dev-dotnet/monodevelop-${PV}
"
RESTRICT="mirror nostrip binchecks"

_eol_warn() {
ewarn
ewarn "This project is End of Life (EOL) and hasn't been updated since Dec 2014 (NUnit), Jun 2018 (TestRunner)."
ewarn
}

pkg_setup() {
	_eol_warn
}

unpack_deb() {
	local archive_name="${1}"
	ar x "${DISTDIR}/${archive_name}" || die
	tar xf "data.tar.xz" || die
}

src_unpack() {
	unpack_deb "monodevelop-nunit_${PV}-0xamarin${REV_PV}+ubuntu1804b1_all.deb"
}

sanitize_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		if file "${path}" | grep -q -e "symbolic link" ; then
			continue
		fi
		realpath "${path}" 2>/dev/null 1>/dev/null || continue
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "POSIX shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "Bourne-Again shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (console)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (DLL)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (DLL) (console)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32 executable (GUI)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32+ executable (DLL) (console)" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -F -e "PE32+ executable (DLL) (GUI)" ; then
			chmod 0755 "${path}" || die
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}

src_install() {
	cd "${S}" || die
	mv "usr" "${ED}" || die
	sanitize_permissions
}

pkg_postinst() {
	xdg_pkg_postinst
	_eol_warn
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  ebuild-needs-test

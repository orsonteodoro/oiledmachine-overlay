# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

REV_PV="2"
SRC_URI="
https://download.mono-project.com/repo/ubuntu/pool/main/m/monodevelop-database/monodevelop-database_${PV}-0xamarin${REV_PV}_all.deb
"
S="${WORKDIR}"

DESCRIPTION="Database Addin for MonoDevelop"
HOMEPAGE="
https://www.monodevelop.com/
https://github.com/mono/monodevelop
https://github.com/mono/monodevelop/tree/monodevelop-5.10.0.871/extras/MonoDevelop.Database
"
LICENSE="
	MIT
"
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE=" "
REQUIRED_USE=" "
CDEPEND="
"
RDEPEND="
	${CDEPEND}
	>=dev-dotnet/mono-addins-1.0
	>=dev-dotnet/monodevelop-${PV}
	>=dev-dotnet/monodevelop-nunit-bin-${PV}
	>=dev-dotnet/monodevelop-versioncontrol-bin-${PV}
	>=dev-lang/mono-4.2
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${CDEPEND}
"
RESTRICT="mirror nostrip binchecks"

_eol_warn() {
ewarn
ewarn "This project is End of Life (EOL) and hasn't been updated since Nov 2015."
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
	unpack_deb "monodevelop-database_${PV}-0xamarin${REV_PV}_all.deb"
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
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  ebuild-needs-testing

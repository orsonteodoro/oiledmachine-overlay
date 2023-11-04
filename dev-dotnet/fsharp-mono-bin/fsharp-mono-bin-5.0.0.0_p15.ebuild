# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV4=$(ver_cut 1-4 ${PV})
MY_PV2=$(ver_cut 1-2 ${PV})
REV_PV=$(ver_cut 6 ${PV})

SRC_URI="
https://download.mono-project.com/repo/ubuntu/pool/main/f/fsharp/fsharp_${MY_PV4}-0xamarin${REV_PV}+ubuntu2004b1_all.deb
https://download.mono-project.com/repo/ubuntu/pool/main/f/fsharp/libfsharp-core${MY_PV2}-cil_${MY_PV4}-0xamarin${REV_PV}+ubuntu2004b1_all.deb
"
S="${WORKDIR}"

DESCRIPTION="The F# compiler, F# core library, and F# editor tools"
HOMEPAGE="
http://fsharp.org/
"
SLOT="0"
LICENSE="
	MIT
"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE="
r2
"
RDEPEND="
	!dev-dotnet/fsharp
	!dev-dotnet/fsharp-mono
	dev-lang/mono
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-arch/tar
"
QA_PREBUILT="*"

unpack_deb() {
	local archive_name="${1}"
	ar x "${DISTDIR}/${archive_name}" || die
	tar xf "data.tar.xz" || die
}

src_unpack() {
	cd "${S}" || die
# See https://download.mono-project.com/repo/ubuntu/pool/main/f/fsharp/
	unpack_deb "libfsharp-core${MY_PV2}-cil_${MY_PV4}-0xamarin${REV_PV}+ubuntu2004b1_all.deb" || die
	unpack_deb "fsharp_${MY_PV4}-0xamarin${REV_PV}+ubuntu2004b1_all.deb" || die
}

sanitize_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		realpath "${path}" 2>/dev/null 1>/dev/null || continue
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:;
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
	mv "${WORKDIR}/usr" "${ED}" || die
	sanitize_permissions
}

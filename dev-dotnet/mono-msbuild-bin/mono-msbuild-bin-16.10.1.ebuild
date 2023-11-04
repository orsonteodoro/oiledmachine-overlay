# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV2="2021.05.26.14.00"
MY_PV2_REV="2"

SRC_URI="
https://download.mono-project.com/repo/ubuntu/pool/main/m/msbuild/msbuild-sdkresolver_${PV}+xamarinxplat.${MY_PV2}-0xamarin${MY_PV2_REV}+ubuntu2004b1_all.deb
https://download.mono-project.com/repo/ubuntu/pool/main/m/msbuild/msbuild_${PV}+xamarinxplat.${MY_PV2}-0xamarin${MY_PV2_REV}+ubuntu2004b1_all.deb
"
S="${WORKDIR}"

DESCRIPTION="MSBuild is the build platform for .NET and VS."
HOMEPAGE="https://github.com/mono/msbuild"
LICENSE="
	( MIT all-rights-reserved )
	( Apache-2.0 all-rights-reserved )
	BSD-2
	BSD
	DOTNET-libraries-and-runtime-components-patents
	MIT
	Ms-PL
	Unicode-DFS-2016
	ZLIB
	W3C-Software-and-Document-Notice-and-License
"
#
# https://github.com/mono/msbuild/blob/v16.9.0/LICENSE
# https://github.com/mono/msbuild/blob/v16.9.0/THIRDPARTYNOTICES.txt
#
# For project names for reverse lookup of licenses, see
#
#   https://github.com/mono/msbuild/blob/v16.9.0/eng/Packages.props
#
# Ms-PL - Ionic.Zip.dll
KEYWORDS="~amd64"
SLOT="0"
IUSE="
r2
"
REQUIRED_USE="
"
RDEPEND="
	!dev-util/msbuild
	!dev-dotnet/msbuild
	!dev-dotnet/msbuild-bin
	>=dev-lang/mono-6.12
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/tar
"
RESTRICT="mirror"

unpack_deb() {
	local archive_name="${1}"
	ar x "${DISTDIR}/${archive_name}" || die
	tar xf "data.tar.xz" || die
}

src_unpack() {
	cd "${S}" || die
# See https://download.mono-project.com/repo/ubuntu/pool/main/m/msbuild/
	unpack_deb "msbuild-sdkresolver_${PV}+xamarinxplat.${MY_PV2}-0xamarin${MY_PV2_REV}+ubuntu2004b1_all.deb" || die
	unpack_deb "msbuild_${PV}+xamarinxplat.${MY_PV2}-0xamarin${MY_PV2_REV}+ubuntu2004b1_all.deb" || die
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

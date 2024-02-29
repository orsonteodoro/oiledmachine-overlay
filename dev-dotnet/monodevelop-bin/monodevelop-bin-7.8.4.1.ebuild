# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See also:
# https://github.com/mono/monodevelop/issues/8006#issuecomment-561301244

inherit xdg

REV_PV="6"
SRC_URI="
amd64? (
https://download.mono-project.com/repo/ubuntu/pool/main/m/monodevelop/monodevelop_${PV}-0xamarin${REV_PV}+ubuntu1804b1_amd64.deb
)
arm64? (
https://download.mono-project.com/repo/ubuntu/pool/main/m/monodevelop/monodevelop_${PV}-0xamarin${REV_PV}+ubuntu1804b1_arm64.deb
)
x86? (
https://download.mono-project.com/repo/ubuntu/pool/main/m/monodevelop/monodevelop_${PV}-0xamarin${REV_PV}+ubuntu1804b1_i386.deb
)
"
S="${WORKDIR}"

DESCRIPTION="MonoDevelop is a cross platform .NET IDE"
HOMEPAGE="
https://www.monodevelop.com/
https://github.com/mono/monodevelop
"
LICENSE="
	LGPL-2.1
	MIT
	all-rights-reserved
	Apache-2.0
	BSD
	GPL-2
	GPL-2-with-linking-exception
	LGPL-2.1
	Ms-PL
	ZLIB
"
#
# sharpsvn-binary - Apache-2.0
# fsharpbinding - Apache-2.0
# libgit-binary - GPL-2-with-linking-exception, Apache-2.0, MIT, LGPL-2.1, ZLIB
# libgit2 - GPL-2-with-linking-exception
# libssh2 - BSD
# macdoc (from monomac) - MIT Apache-2.0
#   lib/AgilityPack.dll [Html Agility Pack] - MIT
#   lib/Ionic.Zip.dll - Ms-PL
# mdtestharness - all-rights-reserved (no explicit license and sources)
# monotools - GPL-2, LGPL-2, MIT
# nuget-binary - Apache-2.0
#
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE=" database nunit versioncontrol"
REQUIRED_USE=" "
XTERMS_DEPEND="
	|| (
		x11-terms/xterm
		x11-terms/gnome-terminal
		x11-terms/mate-terminal
		kde-apps/konsole
		x11-terms/xfce4-terminal
	)
"
BIN_DEPEND="
	>=media-libs/fontconfig-2.12
	>=sys-libs/glibc-2.27
	virtual/pkgconfig
"
CDEPEND="
	${BIN_DEPEND}
	!dev-dotnet/dotdevelop
	!dev-dotnet/monodevelop
	>=dev-dotnet/gtk-sharp-2.12.8:2
	>=dev-dotnet/fsharp-mono-bin-5.0.0.0_p15
	>=dev-lang/mono-5.10
"
RDEPEND="
	${CDEPEND}
	${XTERMS_DEPEND}
	app-shells/bash
	x11-misc/xdg-utils
	x11-themes/adwaita-icon-theme
	database? (
		dev-dotnet/monodevelop-database-bin
	)
	nunit? (
		~dev-dotnet/monodevelop-nunit-bin-${PV}
	)
	versioncontrol? (
		~dev-dotnet/monodevelop-versioncontrol-bin-${PV}
	)
	|| (
		x11-themes/papirus-icon-theme
		x11-themes/paper-icon-theme
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${CDEPEND}
	>=dev-dotnet/mono-msbuild-bin-16.10.1
	>=dev-build/cmake-2.8.12.2
	>=dev-build/autoconf-2.53
	>=dev-build/automake-1.10
	app-shells/bash
	dev-util/intltool
	dev-vcs/git
	sys-devel/gettext
	dev-build/make
	virtual/pkgconfig
	x11-misc/shared-mime-info
	kernel_Darwin? (
		dev-lang/ruby
	)
"
RESTRICT="mirror nostrip binchecks"

_eol_warn() {
ewarn
ewarn "This project is End of Life (EOL) and hasn't been updated since May 2019."
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
	if use amd64 ; then
		unpack_deb "monodevelop_${PV}-0xamarin${REV_PV}+ubuntu1804b1_amd64.deb"
	elif use arm64 ; then
		unpack_deb "monodevelop_${PV}-0xamarin${REV_PV}+ubuntu1804b1_arm64.deb"
	elif use x86 ; then
		unpack_deb "monodevelop_${PV}-0xamarin${REV_PV}+ubuntu1804b1_i386.deb"
	fi
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
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES

# Testing:
# /usr/bin/monodevelop:  ok
# Form designer:  ok
# Hello world GUI prototype (GtkSharp:2):  ok

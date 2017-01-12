# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mysql-connector-net/mysql-connector-net-1.0.9.ebuild,v 1.3 2008/03/02 09:12:46 compnerd Exp $

EAPI="6"

inherit dotnet eutils multilib versionator mono

MY_PV="${PV:5:4}-${PV:9:2}-${PV:11:2}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OpenTK - A .NET interface to OpenCL/OpenAL/OpenGL"
HOMEPAGE="http://opentk.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="OpenTK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} gac"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

RDEPEND=">=dev-lang/mono-2.0
		media-libs/openal
		virtual/opengl"
DEPEND="${RDEPEND}
		app-arch/p7zip"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	mkdir -p "${S}"; cd "${S}"
	unpack ${A};
	rm -fr "${PN}/Binaries"
}

src_prepare() {
	#required by monogame 3.5.1
	eapply "${FILESDIR}/${PN}-20140723-opentk-expose-joystick-guid.patch" || die "failed to patch joystick guid"

	egenkey

	eapply_user
}

src_compile() {
	exbuild_strong OpenTK.sln /t:OpenTK || die "build failed"
}

src_install() {
	mydebug="Release"
	if use debug ; then
		mydebug="Debug"
	fi

	ebegin "Installing dlls into the GAC"

	esavekey

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.dll"
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.Compatibility.dll"
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.GLControl.dll"
        done

	eend

	dodoc Documentation/*.txt

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins OpenTK.snk
		doins Binaries/OpenTK/Release/{OpenTK.dll.mdb,OpenTK.GLControl.xml,OpenTK.pdb,OpenTK.xml}
	fi

        FILES=$(find "${D}" -name "OpenTK.Compatibility.dll")
        for f in $FILES
        do
                cp -a "Binaries/OpenTK/${mydebug}/OpenTK.Compatibility.dll.config" "$(dirname $f)"
        done

        FILES=$(find "${D}" -name "OpenTK.dll")
        for f in $FILES
        do
                cp -a "Binaries/OpenTK/${mydebug}/OpenTK.dll.config" "$(dirname $f)"
        done

        FILES=$(find "${D}" -name "OpenTK.GLControl.dll")
        for f in $FILES
        do
                cp -a "Binaries/OpenTK/${mydebug}/OpenTK.GLControl.dll.config" "$(dirname $f)"
        done


	dotnet_multilib_comply
}

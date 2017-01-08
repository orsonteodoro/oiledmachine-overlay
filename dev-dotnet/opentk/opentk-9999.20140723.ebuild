# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mysql-connector-net/mysql-connector-net-1.0.9.ebuild,v 1.3 2008/03/02 09:12:46 compnerd Exp $

EAPI="6"

inherit eutils multilib mono versionator

MY_PV="${PV:5:4}-${PV:9:2}-${PV:11:2}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OpenTK - A .NET interface to OpenCL/OpenAL/OpenGL"
HOMEPAGE="http://opentk.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="OpenTK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET}"
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

	genkey

	eapply_user
}

src_compile() {
	xbuild OpenTK.sln /p:Configuration=Release /t:OpenTK /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" || die "build failed"
}

src_install() {
	ebegin "Installing dlls into the GAC"

	savekey

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.dll"
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.Compatibility.dll"
                egacinstall "${S}/Binaries/OpenTK/Release/OpenTK.GLControl.dll"
        done

	eend

	dodoc Documentation/*.txt

	mono_multilib_comply
}

function genkey() {
        einfo "Generating Key Pair"
        cd "${S}"
        sn -k "${PN}-keypair.snk"
}

function savekey() {
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"
}

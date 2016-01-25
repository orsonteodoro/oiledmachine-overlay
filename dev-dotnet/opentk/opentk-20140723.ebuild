# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mysql-connector-net/mysql-connector-net-1.0.9.ebuild,v 1.3 2008/03/02 09:12:46 compnerd Exp $

EAPI="5"

inherit eutils multilib mono versionator

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OpenTK - A .NET interface to OpenCL/OpenAL/OpenGL"
HOMEPAGE="http://opentk.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="OpenTK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

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

src_compile() {
	xbuild OpenTK.sln /p:Configuration=Release /t:OpenTK || die "build failed"
}

src_install() {
	ebegin "Installing dlls into the GAC"
	gacutil -i Binaries/OpenTK/Release/OpenTK.dll -root "${D}/usr/$(get_libdir)" \
		-gacdir "/usr/$(get_libdir)" -package "${PN}" > /dev/null
#	gacutil -i Binaries/OpenTK/Release/OpenTK.Compatibility.dll -root "${D}/usr/$(get_libdir)" \
#		-gacdir "/usr/$(get_libdir)" -package "${PN}" > /dev/null
#	gacutil -i Binaries/OpenTK/Release/OpenTK.GLControl.dll -root "${D}/usr/$(get_libdir)" \
#		-gacdir "/usr/$(get_libdir)" -package "${PN}" > /dev/null
	eend

	dodoc Documentation/*.txt

	mono_multilib_comply
}

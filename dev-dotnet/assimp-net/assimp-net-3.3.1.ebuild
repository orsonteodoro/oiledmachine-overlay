# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit mono-env eutils gac

DESCRIPTION="AssimpNet is a C# language binding to the Assimp library"
HOMEPAGE="https://github.com/assimp/assimp-net"
SRC_URI="https://github.com/assimp/assimp-net/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ASSIMPNET"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/assimp-net-${PV}"

src_prepare() {
	genkey

	eapply_user
}

src_compile() {
	mydebug="Net45-Release"
	if use debug; then
		mydebug="Net45-Debug"
	fi

	cd "${S}/AssimpNet.Interop.Generator"
	xbuild AssimpNet.Interop.Generator.csproj /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" || die

	cd "${S}"
	A='"$(SolutionDir)AssimpNet.Interop.Generator\bin\$(Configuration)\AssimpNet.Interop.Generator.exe" "$(TargetDir)$(TargetFileName)" "$(ProjectDir)AssimpKey.snk"' \
	B='mono $(ProjectDir)..\AssimpNet.Interop.Generator\bin\$(Configuration)\AssimpNet.Interop.Generator.exe "$(TargetDir)$(TargetFileName)" "$(ProjectDir)assimp-net-keypair.snk"' \
	 perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' AssimpNet/AssimpNet.csproj

	cd "${S}/AssimpNet"
	xbuild AssimpNet.csproj /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" || die
}

src_install() {
	mydebug="Net45-Release"
	if use debug; then
		mydebug="Net45-Debug"
	fi

        ebegin "Installing dlls into the GAC"

	savekey

	mkdir -p "${D}/usr/lib/mono/AssimpNet.Interop.Generator/${PV}"
	cp "${S}/AssimpNet.Interop.Generator/obj/${mydebug}"/* "${D}/usr/lib/mono/AssimpNet.Interop.Generator/${PV}"/

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/AssimpNet/obj/${mydebug}/AssimpNet.dll"
        done

	eend

	cd "${S}/AssimpNet"
	dodoc AssimpLicense.txt
	cd "${S}"
	dodoc -r Docs/*
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

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils gac

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
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_unpack() {
	default
	cp -a "${FILESDIR}/AssimpNet.dll.config" "${S}"
}

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	sed -i -e "s|\"Assimp32.so\"|\"libassimp.so\"|g" ./AssimpNet/Unmanaged/AssimpLibrary.cs || die
	sed -i -e "s|\"Assimp64.so\"|\"libassimp.so\"|g" ./AssimpNet/Unmanaged/AssimpLibrary.cs || die

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
	exbuild_strong AssimpNet.csproj /p:Configuration=${mydebug}  || die
}

src_install() {
	mydebug="Net45-Release"
	if use debug; then
		mydebug="Net45-Debug"
	fi

        ebegin "Installing dlls into the GAC"

	if use developer ; then
		esavekey
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "AssimpNet/AssimpKey.snk"
	fi

	mkdir -p "${D}/usr/$(get_libdir)/mono/AssimpNet.Interop.Generator/${PV}"
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

	dotnet_multilib_comply

	cp -a "${S}/AssimpNet.dll.config" "${D}"/usr/$(get_libdir)/mono/gac/AssimpNet/* || die
}


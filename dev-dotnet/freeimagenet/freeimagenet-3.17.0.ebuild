# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit mono-env eutils mono gac

DESCRIPTION="FreeImage.NET is a wrapper for the FreeImage library for popular image formats"
HOMEPAGE=""
SRC_URI="http://downloads.sourceforge.net/freeimage/FreeImage${PV//./}.zip"

LICENSE="FREEIMAGEPL-1.0 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug csharp +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/FreeImage"

src_prepare() {
	eapply "${FILESDIR}/freeimage-3.17.0-net45.patch"

	genkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

	emake || die "failed to compile library"

	if use csharp ; then
	        einfo "Building FreeImage.Net"

		cd "${S}"
		sn -k "${PN}-keypair.snk"
		cd "${S}/Wrapper/FreeImage.NET/cs/Library"
		sed -i -r -e "s|<TargetFrameworkVersion>v3.5</TargetFrameworkVersion>|<TargetFrameworkVersion>v4.5</TargetFrameworkVersion>|" ./Library/Library.csproj
	        xbuild /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" Library.2005.csproj || die "failed to compile dll"
	fi
}

src_install() {
	default

	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	if use csharp ; then
	        ebegin "Installing dlls into the GAC"

		savekey

		for x in ${USE_DOTNET} ; do
	                FW_UPPER=${x:3:1}
	                FW_LOWER=${x:4:1}
	                egacinstall "${S}/Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll"
	        done

		#mkdir -p "${D}/usr/share/${PN}/FreeImage.NET/"
		#cp -R "${S}/Wrapper/FreeImage.NET/cs/Doc"/* "${D}/usr/share/${PN}/FreeImage.NET/"
	fi

	eend
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

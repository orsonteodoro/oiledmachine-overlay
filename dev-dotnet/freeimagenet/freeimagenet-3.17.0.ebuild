# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac versionator

DESCRIPTION="FreeImage.NET is a wrapper for the FreeImage library for popular image formats"
HOMEPAGE=""
SRC_URI="http://downloads.sourceforge.net/freeimage/FreeImage${PV//./}.zip"

LICENSE="FREEIMAGEPL-1.0 GPL-2 GPL-3"
SLOT="0/$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

RDEPEND=">=dev-lang/mono-4
         media-libs/freeimage:0/$(get_version_component_range 1-2)"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/FreeImage"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

	#emake || die "failed to compile library"

	if use gac ; then
	        einfo "Building FreeImage.Net"

		cd "${S}/Wrapper/FreeImage.NET/cs/Library"
	        exbuild_strong /p:Configuration=${mydebug} Library.2005.csproj || die "failed to compile dll"
	fi
}

src_install() {
	#default

	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	if use gac ; then
	        ebegin "Installing dlls into the GAC"

		esavekey

		for x in ${USE_DOTNET} ; do
	                FW_UPPER=${x:3:1}
	                FW_LOWER=${x:4:1}
	                egacinstall "${S}/Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll"
			insinto "/usr/$(get_libdir)/mono/${PN}"
			use developer && doins "${S}/Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.XML"
			use developer && doins "${S}/Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll.mdb"
	        done

		#mkdir -p "${D}/usr/share/${PN}/FreeImage.NET/"
		#cp -R "${S}/Wrapper/FreeImage.NET/cs/Doc"/* "${D}/usr/share/${PN}/FreeImage.NET/"
	fi

	eend

        FILES=$(find "${D}" -name "*.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/FreeImageNET.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}

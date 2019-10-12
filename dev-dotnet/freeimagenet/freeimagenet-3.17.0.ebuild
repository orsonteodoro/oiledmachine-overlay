# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="FreeImage.NET is a wrapper for the FreeImage library for popular image formats"
HOMEPAGE="http://freeimage.sourceforge.net/"
LICENSE="FREEIMAGEPL-1.0 GPL-2 GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2)"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RDEPEND="media-libs/freeimage:${SLOT}"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
SRC_URI="http://downloads.sourceforge.net/freeimage/FreeImage${PV//./}.zip"
inherit gac
S="${WORKDIR}/FreeImage"

src_prepare() {
	default
	eapply "${FILESDIR}/freeimage-3.17.0-wrapper-marshal-fixes.patch"
	cd "${S}" || die
	sed -i -r -e "s|\"FreeImage\"|\"libfreeimage.dll\"|g" ./Wrapper/FreeImage.NET/cs/UnitTest/FreeImage.cs || die
	sed -i -r -e "s|\"FreeImage\"|\"libfreeimage.dll\"|g" ./Wrapper/FreeImage.NET/cs/Library/FreeImageStaticImports.cs || die
}

src_compile() {
	if use gac ; then
		cd "${S}/Wrapper/FreeImage.NET/cs/Library"
		exbuild /p:Configuration=$(usex debug "debug" "release") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" Library.2005.csproj || die "failed to compile dll"
	fi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")

	if use gac ; then
		ebegin "Installing dlls into the GAC"

		for x in ${USE_DOTNET} ; do
			FW_UPPER=${x:3:1}
			FW_LOWER=${x:4:1}
			egacinstall "${S}/Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll"
			insinto "/usr/$(get_libdir)/mono/${PN}"
			if use developer ; then
				doins "${S}/Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.XML" \
				      "${S}/Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll.mdb"
			fi
		done

		#mkdir -p "${D}/usr/share/${PN}/FreeImage.NET/"
		#cp -R "${S}/Wrapper/FreeImage.NET/cs/Doc"/* "${D}/usr/share/${PN}/FreeImage.NET/"
		eend
	fi

        FILES=$(find "${D}" -name "*.dll")
        for f in $FILES
	do
		cp -a "${FILESDIR}/FreeImageNET.dll.config" "$(dirname $f)"
	done

	dotnet_multilib_comply
}

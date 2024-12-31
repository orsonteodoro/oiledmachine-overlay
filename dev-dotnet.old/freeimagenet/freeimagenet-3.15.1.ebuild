# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="FreeImage.NET is a wrapper for the FreeImage library for popular"
DESCRIPTION+=" image formats"
HOMEPAGE="http://freeimage.sourceforge.net/"
LICENSE="FIPL-1.0 GPL-2 GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0/$(ver_cut 1-2)"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RDEPEND=">=media-libs/freeimage-${PV}"
DEPEND="${RDEPEND}"
inherit dotnet eutils
# The versioning was 3.15.1 for the wrapper but the system lib or zip was 3.17.0
SRC_URI="http://downloads.sourceforge.net/freeimage/FreeImage${PV//./}.zip"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/FreeImage"

src_prepare() {
	default
	eapply "${FILESDIR}/freeimage-3.17.0-wrapper-marshal-fixes.patch"
	cd "${S}" || die
	sed -i -r -e "s|\"FreeImage\"|\"libfreeimage.dll\"|g" \
		Wrapper/FreeImage.NET/cs/UnitTest/FreeImage.cs || die
	sed -i -r -e "s|\"FreeImage\"|\"libfreeimage.dll\"|g" \
		Wrapper/FreeImage.NET/cs/Library/FreeImageStaticImports.cs \
		|| die
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		cd "Wrapper/FreeImage.NET/cs/Library"
		exbuild /p:Configuration=$(usex debug "debug" "release") \
			${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" Library.2005.csproj \
			|| die "failed to compile dll"
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll"
	doins Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll
		if use developer ; then
			doins \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.XML" \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll.mdb"
		dotnet_distribute_file_matching_dll_in_gac \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll" \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.XML"
		dotnet_distribute_file_matching_dll_in_gac \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll" \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll.mdb"
		fi
		#use doc && dodoc -R "Wrapper/FreeImage.NET/cs/Doc"/*
		doins "${FILESDIR}/FreeImageNET.dll.config"
		dotnet_distribute_file_matching_dll_in_gac \
	"Wrapper/FreeImage.NET/cs/Library/bin/${mydebug}/FreeImageNET.dll" \
	"${FILESDIR}/FreeImageNET.dll.config"
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

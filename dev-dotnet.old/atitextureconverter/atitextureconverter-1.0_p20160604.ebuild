# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A C# Wrapper for the TextureConverter native library to allow"
DESCRIPTION+=" developers to convert images to ATI supported compressed textures"
HOMEPAGE="https://github.com/infinitespace-studios/ATI.TextureConverter"
LICENSE="Ms-PL"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug bindist +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet eutils
EGIT_COMMIT="ac1103f765ade4c59b2475a43e1d4ea98d4bbd26"
SRC_URI="https://github.com/infinitespace-studios/ATI.TextureConverter/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			ATI.TextureConverter.sln
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
                egacinstall \
		  ATI.TextureConverter/bin/${mydebug}/ATI.TextureConverter.dll
		doins ATI.TextureConverter/bin/${mydebug}/ATI.TextureConverter.dll
		doins ATI.TextureConverter/bin/${mydebug}/ATI.TextureConverter.dll.config
		dotnet_distribute_file_matching_dll_in_gac \
			"ATI.TextureConverter/bin/${mydebug}/ATI.TextureConverter.dll"
			"ATI.TextureConverter/bin/${mydebug}/ATI.TextureConverter.dll.config"
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

pkg_postinst() {
	einfo
	einfo "The wrapper is installed but not the proprietary library."
	einfo "You must install the adreno-sdk-linux.tar.gz manually with"
	einfo "libTextureConverter.so placed in the library folder"
	einfo "/usr/lib{32,64}."
	einfo "Go to https://developer.qualcomm.com/software/adreno-gpu-sdk"
	einfo "to get the proprietary libary."
	einfo
	einfo "For more details goto https://github.com/infinitespace-studios/ATI.TextureConverter"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A C# Wrapper for the TextureConverter native library to allow developers to convert images to ATI supported compressed textures"
HOMEPAGE="https://github.com/infinitespace-studios/ATI.TextureConverter"
LICENSE="Ms-PL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug bindist +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet eutils git-r3 mono
SRC_URI=""
inherit gac
RESTRICT=""
S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	unpack ${A}
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/infinitespace-studios/ATI.TextureConverter"
        EGIT_BRANCH="master"
        EGIT_COMMIT="ac1103f765ade4c59b2475a43e1d4ea98d4bbd26"
        git-r3_fetch
        git-r3_checkout
}

src_compile() {
	exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ATI.TextureConverter.sln
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/ATI.TextureConverter/bin/${mydebug}/ATI.TextureConverter.dll"
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "${S}/ATI.TextureConverter/bin/${mydebug}/ATI.TextureConverter.dll.config"
        done

	eend

	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "The wrapper is installed but not the proprietary library."
	einfo "You must install the adreno-sdk-linux.tar.gz manually with libTextureConverter.so placed in the library folder /usr/lib{32,64}."
	einfo "Go to https://developer.qualcomm.com/software/adreno-gpu-sdk to get the proprietary libary."
	einfo "For more details goto https://github.com/infinitespace-studios/ATI.TextureConverter"
}

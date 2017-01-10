# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac git-r3

DESCRIPTION="A C# Wrapper for the TextureConverter native library to allow developers to convert images to ATI supported compressed textures"
HOMEPAGE="https://github.com/infinitespace-studios/ATI.TextureConverter"
SRC_URI=""

LICENSE="Ms-PL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug bindist +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/infinitespace-studios/ATI.TextureConverter"
        EGIT_BRANCH="master"
        EGIT_COMMIT="ac1103f765ade4c59b2475a43e1d4ea98d4bbd26"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	#sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	#sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.Default.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	#sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.targets\" />|<Target Name="Build" DependsOnTargets="$(BuildDependsOn)" Outputs="$(TargetPath)"/>|g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj

	#einfo "Building ATI.TextureConverter..."
	#cd "${S}/ATI.TextureConverter"
	#xbuild ATI.TextureConverter.csproj /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk"

	einfo "Building..."
	cd "${S}"
	exbuild_strong ATI.TextureConverter.sln
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	savekey

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

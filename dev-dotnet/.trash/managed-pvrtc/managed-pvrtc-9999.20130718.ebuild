# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit mono-env eutils git-r3 mono gac

DESCRIPTION="Managed PVRTC"
HOMEPAGE="https://github.com/SickheadGames/ManagedPVRTC"
SRC_URI=""

LICENSE="PVRTC"
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

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/SickheadGames/ManagedPVRTC.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="8ba339e894d2f69cd60da25cbbea54d587644cee"
        git-r3_fetch
        git-r3_checkout

}

src_prepare() {
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.Default.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.targets\" />|<Target Name="Build" DependsOnTargets="$(BuildDependsOn)" Outputs="$(TargetPath)"/>|g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj

	genkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	einfo "Building PVRTexLibWrapper"
	cd "${S}"/PVRTexLibWrapper
	xbuild PVRTexLibWrapper.vcxproj /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk"

	einfo "Building ManagedPVRTC"
	cd "${S}"/ManagedPVRTC
	xbuild ManagedPVRTC.csproj /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk"
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
                egacinstall "${S}/ManagedPVRTC/obj/${mydebug}/ManagedPVRTC.dll"
        done

	eend

	mkdir -p "${D}"/usr/include
	cd "${S}/PVRTexLibWrapper/source"
	cp *.h "${D}"/usr/include

	if ! use bindist; then
		if use abi_x86_64; then
			cd "${S}/PVRTexLibWrapper/source/Linux_x86_64"
			mkdir -p "${D}/usr/lib64"
			cp * "${D}/usr/lib64"
		elif use abi_x86_32; then
			cd "${S}/PVRTexLibWrapper/source/Linux_x86_32"
			mkdir -p "${D}/usr/lib32"
			cp * "${D}/usr/lib32"
		fi

		cd "${S}/PVRTexLibWrapper/source"
		dodoc -r Documentation
	fi
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

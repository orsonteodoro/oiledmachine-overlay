# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils git-r3 mono

DESCRIPTION="Managed PVRTC"
HOMEPAGE="https://github.com/SickheadGames/ManagedPVRTC"
SRC_URI=""

LICENSE="PVRTC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug bindist"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

FEATURES="nofetch"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/SickheadGames/ManagedPVRTC.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="8ba339e894d2f69cd60da25cbbea54d587644cee"
        git-r3_fetch
        git-r3_checkout

}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.Default.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.targets\" />|<Target Name="Build" DependsOnTargets="$(BuildDependsOn)" Outputs="$(TargetPath)"/>|g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj

	einfo "Building PVRTexLibWrapper"
	cd "${S}"/PVRTexLibWrapper
	xbuild PVRTexLibWrapper.vcxproj /p:Configuration=${mydebug}

	einfo "Building ManagedPVRTC"
	cd "${S}"/ManagedPVRTC
	xbuild ManagedPVRTC.csproj /p:Configuration=${mydebug}
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	cd "${S}"
	sn -k "${PN}-keypair.snk"
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

	cd "${S}"/ManagedPVRTC/obj/${mydebug}/

	strong_sign "${S}/${PN}-keypair.snk" "${S}/ManagedPVRTC/obj/${mydebug}/ManagedPVRTC.dll"
        gacutil -i "${S}/ManagedPVRTC/obj/${mydebug}/ManagedPVRTC.dll" -root "${D}/usr/$(get_libdir)" \
                -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"
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

        #mono_multilib_comply
}

function strong_sign() {
	pushd "$(dirname ${2})"
	ikdasm "${2}" > "${2}.il" || die "monodis failed"
	mv "${2}" "${2}.orig"
	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" || die "ilasm failed"
	popd
}

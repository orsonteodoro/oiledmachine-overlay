# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac multilib-minimal multilib-build

DESCRIPTION="Simple C# wrapper around PVRTexLib from Imagination Technologies"
HOMEPAGE="https://github.com/flyingdevelopmentstudio/PVRTexLibNET"
GITHUB_USER="KonajuGames"
COMMIT="f8dfe74c8d767404d41c97d87eace04df636d021"
SRC_URI="https://github.com/${GITHUB_USER}/PVRTexLibNET/archive/${COMMIT}.zip -> ${GITHUB_USER}-${P}.zip"

LICENSE="PowerVRTools-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug bindist +gac abi_x86_32 abi_x86_64"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/PVRTexLibNET-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	cd "${S}/PVRTexLibWrapper"

	egenkey

	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	myabi="x64"
	myabi2="64"
        if use abi_x86_32; then
                myabi="x86"
		myabi2="32"
        elif use abi_x86_64; then
                myabi="x64"
		myabi2="64"
	else
		die "ABI not supported"
        fi

	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.Default.props\" />||g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.targets\" />|<Target Name="Build" DependsOnTargets="$(BuildDependsOn)" Outputs="$(TargetPath)"/>|g' "${S}"/PVRTexLibWrapper/PVRTexLibWrapper.vcxproj

	einfo "Building PVRTexLibWrapper..."
	cd "${S}/PVRTexLibWrapper/Linux"
	if use abi_x86_32 ; then
		cd x32
		make
	fi
	if use abi_x86_64 ; then
		cd x64
		make
	fi

	einfo "Building PVRTexLibNET..."
	cd "${S}/PVRTexLibNET"
	exbuild_strong PVRTexLibNET.csproj /p:Configuration=${mydebug} /p:Platform=${myabi}
}

multilib_src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	myabi="x64"
	myabi2="64"
	myabi3="64"
        if use abi_x86_32; then
                myabi="x86"
		myabi2="32"
		myabi3="x32"
        elif use abi_x86_64; then
                myabi="x64"
		myabi2="64"
		myabi3="x64"
        fi

        ebegin "Installing dlls into the GAC"

	esavekey

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/PVRTexLibNET/bin/${myabi}/${mydebug}/PVRTexLibNET.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins "${S}/PVRTexLibNET/bin/${myabi}/${mydebug}/PVRTexLibNET.dll.mdb"
        done

	eend

	if ! use bindist ; then
		mkdir -p "${D}/usr/$(get_libdir)/"
		cd "${S}/PVRTexLibWrapper/"
		cp -a bin/Linux/Release/${myabi}/libPVRTexLibWrapper.so "${D}/usr/$(get_libdir)/" || die
		cp -a PVRTexTool/Library/Linux_x86_${myabi2}/Dynamic/libPVRTexLib.so "${D}/usr/$(get_libdir)/" || die
	fi

	dotnet_multilib_comply
}

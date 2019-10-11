# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Simple C# wrapper around PVRTexLib from Imagination Technologies"
HOMEPAGE="https://github.com/flyingdevelopmentstudio/PVRTexLibNET"
LICENSE="PowerVRTools-EULA"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug bindist +gac abi_x86_32 abi_x86_64"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet eutils mono multilib-minimal
COMMIT="f8dfe74c8d767404d41c97d87eace04df636d021"
SRC_URI="https://github.com/KonajuGames/PVRTexLibNET/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0"
DLL_ID="PVRTexLibNET"
WRAPPER_ID="PVRTexLibWrapper"
S="${WORKDIR}/${DLL_ID}-${COMMIT}"
RESTRICT="mirror"

src_prepare() {
	sed -i -r -e "s|\"${WRAPPER_ID}.dll\"|\"lib${WRAPPER_ID}.dll\"|g" ./${DLL_ID}/${DLL_ID}.cs || die
	cd "${S}/${WRAPPER_ID}"

	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	myabi="x64"
        if use abi_x86_32; then
                myabi="x86"
        elif use abi_x86_64; then
                myabi="x64"
	else
		die "ABI not supported"
        fi

	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.props\" />||g' "${S}"/${WRAPPER_ID}/${WRAPPER_ID}.vcxproj || die
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.Default.props\" />||g' "${S}"/${WRAPPER_ID}/${WRAPPER_ID}.vcxproj || die
	sed -i -e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.targets\" />|<Target Name="Build" DependsOnTargets="$(BuildDependsOn)" Outputs="$(TargetPath)"/>|g' "${S}"/${WRAPPER_ID}/${WRAPPER_ID}.vcxproj || die

	einfo "Building ${WRAPPER_ID}..."
	cd "${S}/${WRAPPER_ID}/Linux"
	if use abi_x86_32 ; then
		cd x32
		make
	fi
	if use abi_x86_64 ; then
		cd x64
		make
	fi

	einfo "Building ${DLL_ID}..."
	cd "${S}/${DLL_ID}"
	exbuild ${DLL_ID}.csproj /p:Configuration=$(usex debug "Debug" "Release") /p:Platform=${myabi} #exbuild_strong looks broken
}

multilib_src_install() {
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
        fi

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
		estrong_sign_delayed "${SNK_FILENAME}" "${S}/${DLL_ID}/bin/${myabi}/${mydebug}/${DLL_ID}.dll"
                egacinstall "${S}/${DLL_ID}/bin/${myabi}/${mydebug}/${DLL_ID}.dll" #broken
                insinto "/usr/$(get_libdir)/mono/${PN}"
                #doins "${S}/${DLL_ID}/bin/${myabi}/${mydebug}/${DLL_ID}.dll" #temporary fix
		use developer && doins "${S}/${DLL_ID}/bin/${myabi}/${mydebug}/${DLL_ID}.dll.mdb"
        done

	eend

	if ! use bindist ; then
		mkdir -p "${D}/usr/$(get_libdir)/"
		cd "${S}/${WRAPPER_ID}/"
		cp -a bin/Linux/Release/${myabi}/lib${WRAPPER_ID}.so "${D}/usr/$(get_libdir)/" || die
		cp -a PVRTexTool/Library/Linux_x86_${myabi2}/Dynamic/libPVRTexLib.so "${D}/usr/$(get_libdir)/" || die
	fi

	FILES=$(find "${D}" -name "*.dll")
	for f in $FILES
	do
		cp -a "${FILESDIR}/${DLL_ID}.dll.config" "$(dirname $f)" || die
	done
	cp -a "${FILESDIR}/${DLL_ID}.dll.config" "${D}"/usr/$(get_libdir)/mono/gac/${DLL_ID}/*

	dotnet_multilib_comply
}

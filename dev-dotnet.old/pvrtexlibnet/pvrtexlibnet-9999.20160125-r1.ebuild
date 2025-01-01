# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Simple C# wrapper around PVRTexLib from Imagination Technologies"
HOMEPAGE="https://github.com/flyingdevelopmentstudio/PVRTexLibNET"
LICENSE="PowerVRTools-EULA"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug bindist +gac abi_x86_32 abi_x86_64"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet mono multilib-minimal
COMMIT="f8dfe74c8d767404d41c97d87eace04df636d021"
SRC_URI="https://github.com/KonajuGames/PVRTexLibNET/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
inherit gac
SLOT="0/$(ver_cut 1-2 ${PV})"
DLL_NAME="PVRTexLibNET"
SO_NAME="PVRTexLibWrapper"
S="${WORKDIR}/${DLL_NAME}-${COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	sed -i -r -e "s|\"${SO_NAME}.dll\"|\"lib${SO_NAME}.dll\"|g" \
		${DLL_NAME}/${DLL_NAME}.cs || die
	cd "${S}/${SO_NAME}"
	multilib_copy_sources
	ml_prepare_impl() {
		dotnet_copy_sources
	}
	multilib_foreach_abi ml_prepare_impl
}

_get_abi() {
	if [[ "${ABI}" == "x86" ]] ; then
		myabi_dll="x86"
		myabi_so="32"
	elif [[ "${ABI}" == "amd64" ]] ; then
		myabi_dll="x64"
		myabi_so="64"
	else
		die "ABI is not supported"
	fi
}
src_compile() {
	ml_compile_impl() {
		local myabi_dll
		local myabi_so
		_get_abi
		sed -i \
-e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.props\" />||g' \
			${SO_NAME}/${SO_NAME}.vcxproj || die
		sed -i \
-e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.Default.props\" />||g' \
			${SO_NAME}/${SO_NAME}.vcxproj || die
		sed -i \
-e 's|<Import Project=\"\$(VCTargetsPath)\\Microsoft.Cpp.targets\" />|<Target Name="Build" DependsOnTargets="$(BuildDependsOn)" Outputs="$(TargetPath)"/>|g' \
			${SO_NAME}/${SO_NAME}.vcxproj || die
		cd ${SO_NAME}/Linux/x${myabi_so} || die
		emake
		dll_compile_impl() {
			cd ${DLL_NAME}
			exbuild /p:Platform=${myabi_dll} \
				${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
				${DLL_NAME}.csproj
		}
		dotnet_foreach_impl dll_compile_impl
	}
	multilib_foreach_abi ml_compile_impl
}

src_install() {
	local mydebug=$(usex "Debug" "Release")
	local myabi_dll
	local myabi_so
	ml_install_impl() {
		_get_abi
		if ! use bindist ; then
			dolib.so \
	${SO_NAME}/bin/Linux/${mydebug}/${myabi_dll}/lib${SO_NAME}.so
			dolib.so \
${SO_NAME}/PVRTexTool/Library/Linux_x86_${myabi_so}/Dynamic/libPVRTexLib.so
		fi
		dll_install_impl() {
			dotnet_install_loc
			local d_dll="${DLL_NAME}/bin/${myabi_dll}/${mydebug}"
			estrong_resign ${d_dll}/${DLL_NAME}.dll \
				"${DISTDIR}/mono.snk"
			egacinstall ${d_dll}/${DLL_NAME}.dll
			doins ${d_dll}/${DLL_NAME}.dll
			if use developer ; then
				doins "${d_dll}/${DLL_NAME}.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"${d_dll}/${DLL_NAME}.dll" \
					"${d_dll}/${DLL_NAME}.dll.mdb"
			fi
			doins "${FILESDIR}/${DLL_NAME}.dll.config"
			dotnet_distribute_file_matching_dll_in_gac \
				"${d_dll}/${DLL_NAME}.dll" \
				"${FILESDIR}/${DLL_NAME}.dll.config"
		}
		dotnet_foreach_impl dll_install_impl
		multilib_check_headers
	}
	multilib_foreach_abi ml_install_impl
	dotnet_multilib_comply
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD


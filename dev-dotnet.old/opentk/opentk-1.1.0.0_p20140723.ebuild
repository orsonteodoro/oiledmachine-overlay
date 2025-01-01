# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="OpenTK - A .NET interface to OpenCL/OpenAL/OpenGL"
HOMEPAGE="http://opentk.org"
LICENSE="OpenTK"
KEYWORDS="~amd64 ~x86"
DL_PV="$(ver_cut 6)"
MY_PV="${DL_PV:0:4}-${DL_PV:4:2}-${DL_PV:6:2}"
MY_P="${PN}-${MY_PV}"
SLOT="0/$(ver_cut 1-2 ${PV})"
USE_DOTNET="net20 net45"
IUSE="${USE_DOTNET} gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RDEPEND=">=dev-lang/mono-2.0
	   media-libs/openal
	   virtual/opengl"
DEPEND="${RDEPEND}
	app-arch/p7zip"
inherit dotnet
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
inherit gac
S="${WORKDIR}/${MY_P}"
RESTRICT="mirror"

src_unpack() {
	mkdir -p "${S}"; cd "${S}"
	unpack ${A};
	rm -fr "${PN}/Binaries"
}

src_prepare() {
	default
	#required by monogame 3.5.1
	eapply "${FILESDIR}/${PN}-20140723-opentk-expose-joystick-guid.patch" \
		|| die "failed to patch joystick guid"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		exbuild OpenTK.sln ${STRONG_ARGS_NETFX}"${S}/OpenTK.snk" \
			/t:OpenTK || die "build failed"
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		local p
		p="Binaries/OpenTK/${mydebug}/"
		if [[ "${EDOTNET}" == "net45" ]] ; then
	                egacinstall "${p}/OpenTK.dll"
	                egacinstall "${p}/OpenTK.Compatibility.dll"
	                egacinstall "${p}/OpenTK.GLControl.dll"
		fi
		doins "${p}/OpenTK.dll"
		doins "${p}/OpenTK.Compatibility.dll"
		doins "${p}/OpenTK.GLControl.dll"
		dodoc Documentation/*.txt
		if use developer ; then
			doins "${p}/OpenTK.dll.mdb"
			doins "${p}/OpenTK.GLControl.xml"
			doins "${p}/OpenTK.pdb"
			doins "${p}/OpenTK.xml"
			if [[ "${EDOTNET}" == "net45" ]] ; then
				dotnet_distribute_file_matching_dll_in_gac \
					"${p}/OpenTK.dll" \
					"${p}/OpenTK.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"${p}/OpenTK.GLControl.dll" \
					"${p}/OpenTK.GLControl.xml"
				dotnet_distribute_file_matching_dll_in_gac \
					"${p}/OpenTK.dll" \
					"${p}/OpenTK.pdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"${p}/OpenTK.dll" \
					"${p}/OpenTK.xml"
			fi
		fi
		doins "${p}/OpenTK.Compatibility.dll.config"
		doins "${p}/OpenTK.dll.config"
		doins "${p}/OpenTK.GLControl.dll.config"
		if [[ "${EDOTNET}" == "net45" ]] ; then
			dotnet_distribute_file_matching_dll_in_gac \
				"${p}/OpenTK.Compatibility.dll" \
				"${p}/OpenTK.Compatibility.dll.config"
			dotnet_distribute_file_matching_dll_in_gac \
				"${p}/OpenTK.dll" \
				"${p}/OpenTK.dll.config"
			dotnet_distribute_file_matching_dll_in_gac \
				"${p}/OpenTK.GLControl.dll" \
				"${p}/OpenTK.GLControl.dll.config"
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="GWEN.Net is a .Net port of GWEN, and is a lightweight GUI library aimed at games."
HOMEPAGE="https://code.google.com/archive/p/gwen-dotnet/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="GwenNet"
SLOT="0/$(ver_cut 1-2 ${PV})"
USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
RDEPEND="dev-dotnet/opentk
         dev-dotnet/sfmldotnet
         dev-dotnet/taoframework"
DEPEND="${RDEPEND}"
inherit dotnet
SRC_URI="https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/gwen-dotnet/source-archive.zip \
		-> ${P}.zip"
inherit gac
S="${WORKDIR}/gwen-dotnet/trunk/GwenCS"
RESTRICT="mirror"

src_prepare() {
	default
	FILES=$(grep -l -r -e "xcopy" ./)
	for f in $FILES
	do
		echo "Patching $f..."
		sed -i -r \
-e 's|xcopy "\$\(TargetPath\)" "\$\(SolutionDir\)\\Binaries\\" \/Y \/Q|cp -a "\$(TargetPath)" "$(SolutionDir)/Binaries/"|g' "$f"
		sed -i -r \
-e 's|xcopy \/E \/C \/Y "\$\(SolutionDir\)media\\\*\.\*" "\$\(TargetDir\)"|cp -a "$(SolutionDir)media"/* "$(TargetDir)"|g' "$f"
	done

	eapply "${FILESDIR}/gwen-dotnet-9999.20140316-refs.patch"
	eapply "${FILESDIR}/gwen-dotnet-9999.20140316-sfml-system.patch"
	eapply "${FILESDIR}/gwen-dotnet-9999.20140316-sfml-compat-1.patch"
	eapply "${FILESDIR}/gwen-dotnet-9999.20140316-sfml-compat-2.patch"

	#these only work on windows
	eapply "${FILESDIR}/gwen-dotnet-9999.20140316-no-build-samples.patch"

	FILES=$(grep -l -r -e "Tao.Platform.Windows" ./)
	for f in $FILES
	do
		sed -i -r -e 's|Tao.Platform.Windows|Tao.Platform.X11|g' "$f"
	done
	sed -i \
	  -e 's|<TargetFrameworkProfile>Client</TargetFrameworkProfile>||g' \
	  Gwen.Renderer.OpenTK/Gwen.Renderer.OpenTK.csproj || die
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
	        exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			${PROJECT_NAME}.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall "Binaries/Gwen.dll"
		egacinstall "Binaries/Gwen.Renderer.OpenTK.dll"
		egacinstall "Binaries/Gwen.Renderer.SFML.dll"
		egacinstall "Binaries/Gwen.Renderer.Tao.dll"
		doins Binaries/Gwen.dll
		doins Binaries/Gwen.Renderer.OpenTK.dll
		doins Binaries/Gwen.Renderer.SFML.dll
		doins Binaries/Gwen.Renderer.Tao.dll
		if use developer ; then
			doins bin/${mydebug}/Gwen.dll.mdb
			doins \
		Gwen.Renderer.OpenTK/bin/${mydebug}/Gwen.Renderer.OpenTK.dll.mdb
			doins \
		Gwen.Renderer.SFML/bin/${mydebug}/Gwen.Renderer.SFML.dll.mdb
			doins \
		Gwen.Renderer.Tao/bin/${mydebug}/Gwen.Renderer.Tao.dll.mdb
			dotnet_distribute_file_matching_dll_in_gac \
				"Binaries/Gwen.dll" \
				"bin/${mydebug}/Gwen.dll.mdb"
			dotnet_distribute_file_matching_dll_in_gac \
				"Binaries/Gwen.Renderer.OpenTK.dll"
	"Gwen.Renderer.OpenTK/bin/${mydebug}/Gwen.Renderer.OpenTK.dll.mdb"
			dotnet_distribute_file_matching_dll_in_gac \
				"Binaries/Gwen.Renderer.SFML.dll"
		"Gwen.Renderer.SFML/bin/${mydebug}/Gwen.Renderer.SFML.dll.mdb"
			dotnet_distribute_file_matching_dll_in_gac \
				"Binaries/Gwen.Renderer.Tao.dll"
		"Gwen.Renderer.Tao/bin/${mydebug}/Gwen.Renderer.Tao.dll.mdb"
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD


# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils mono multilib-build gac

DESCRIPTION="MonoGame"
HOMEPAGE="http://www.monogame.net"
LICENSE="Ms-PL gamepad-config? ( MONOGAME-GamepadConfig )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	dev-dotnet/sharpfont
	dev-dotnet/assimp-net
	media-libs/openal
	>=dev-lang/mono-4.0.0
	dev-dotnet/gtk-sharp:3
	!>=dev-util/monodevelop-6.0.0.0
	<=dev-util/monodevelop-5.9.5.9
	>=dev-dotnet/mono-addins-1.0
	dev-dotnet/opentk
	>=dev-util/nant-0.93_pre20151114
	>=dev-dotnet/lidgren-network-gen3-2015.12.18
	media-libs/assimp
	media-gfx/nvidia-texture-tools[gac]
        dev-dotnet/pvrtexlibnet[${MULTILIB_USEDEP}]
	dev-dotnet/atitextureconverter
	virtual/ffmpeg
	dev-dotnet/ndesk-options
	>=dev-util/nunit-3.0.1:3
	dev-util/nunit:2
	dev-dotnet/tao-framework
	media-libs/libsdl2
	media-libs/freealut
	>=dev-dotnet/nvorbis-9999
	gamepad-config? ( media-libs/libsdl
			  media-libs/sdl-mixer
			  media-libs/sdl-ttf
			  media-libs/sdl-net
                          media-libs/sdl-gfx
			  media-libs/smpeg
			)
"
DEPEND="
	${RDEPEND}
	app-text/xmlstarlet
        dev-dotnet/protobuild
"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug bindist gamepad-config mgcb pipeline abi_x86_64 abi_x86_32 +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
SRC_URI="https://github.com/mono/MonoGame/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/MonoGame-${PV}"

pkg_setup() {
	if [[ ! -f "/usr/$(get_libdir)/mono/nvidia-texture-tools/Nvidia.TextureTools.dll" ]]; then
		die "You can only use the nvidia-texture-tools from the oiledmachine-overlay."
	fi
}

src_unpack() {
	unpack "${A}"
	cp /usr/$(get_libdir)/mono/gac/OpenTK/*/OpenTK.dll.config ${S}/ThirdParty/Dependencies/

	cd "${S}/ThirdParty/Dependencies/"
	wget -r -nH --cut-dirs=4 "https://github.com/MonoGame/MonoGame.Dependencies/raw/master/FreeImage.NET/FreeImageNET.dll.config" || die
	wget -r -nH --cut-dirs=4 "https://github.com/MonoGame/MonoGame.Dependencies/raw/master/PVRTexLibNET/PVRTexLibNET.dll.config" || die
	wget -r -nH --cut-dirs=4 "https://github.com/MonoGame/MonoGame.Dependencies/raw/master/ATI.TextureConverter/ATI.TextureConverter.dll.config" || die
}

src_prepare() {
	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	#eapply "${FILESDIR}/monogame-3.5.1-monodevelop-6-addin.patch" || die #not ready yet
	eapply "${FILESDIR}/monogame-3.5.1-monodevelop-5-addin.patch" || die

	#Removing proprietary dependencies Xamarin.iOS and Xamarin.Android.  It is proprietary and only offered on windows and mac

	cd "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame

	#windows not supported
	xml ed -d "/Addin/ConditionType[contains(@id,'IsWindows')]" MonoDevelop.MonoGame.addin.xml \
	| xml ed -d "/Addin/Extension/Condition[contains(@id,'IsWindows')]" > MonoDevelop.MonoGame.addin.xml.tmp
	cp MonoDevelop.MonoGame.addin.xml.tmp MonoDevelop.MonoGame.addin.xml

	#android not supported
	xml ed -d "/Addin/Runtime/Import[contains(@file,'Android')]" MonoDevelop.MonoGame.addin.xml \
	| xml ed -d "/Addin/Runtime/Import[contains(@file,'OUYA')]" \
	| xml ed -d "/Addin/Module/Runtime/Import[contains(@assembly,'Android')]/../.." \
	| xml ed -d "/Addin/Module/Dependencies/Addin[contains(@id,'MonoAndroid')]" > MonoDevelop.MonoGame.addin.xml.tmp
	cp MonoDevelop.MonoGame.addin.xml.tmp MonoDevelop.MonoGame.addin.xml

	#apple tv not supported
	xml ed -L -d "//Import[@file='templates/MonoGametvOSProject.xpt.xml']" MonoDevelop.MonoGame.addin.xml

	#ios not supported
	xml ed -d "/Addin/Runtime/Import[contains(@file,'iOS')]" MonoDevelop.MonoGame.addin.xml \
	| xml ed -d "/Addin/Module/Runtime/Import[contains(@assembly,'iOS')]/../.." \
	| xml ed -d "/Addin/Module/Dependencies/Addin[contains(@id,'IPhone')]" > MonoDevelop.MonoGame.addin.xml.tmp
	cp MonoDevelop.MonoGame.addin.xml.tmp MonoDevelop.MonoGame.addin.xml

	xml ed -L -d "/Addin/Module/Extension/ProjectTemplate[contains(@id,'MonoGameForMobileSAPProject')]/../.."  MonoDevelop.MonoGame.addin.xml #iOS
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'MobileOnly')]"  MonoDevelop.MonoGame.addin.xml #iOS
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'Shared/Program.cs')]"  MonoDevelop.MonoGame.addin.xml #iOS
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'Shared/Activity1.cs')]"  MonoDevelop.MonoGame.addin.xml #iOS

	#mac not supported
	xml ed -d "/Addin/Runtime/Import[contains(@file,'Mac')]" MonoDevelop.MonoGame.addin.xml \
	| xml ed -d "/Addin/Runtime/Import[contains(@file,'OSX')]" \
	| xml ed -d "/Addin/ConditionType[contains(@id,'IsMac')]" \
	| xml ed -d "/Addin/Extension/Condition[contains(@id,'IsMac')]" \
	| xml ed -d "/Addin/Module/Runtime/Import[contains(@assembly,'Mac')]/../.." > MonoDevelop.MonoGame.addin.xml.tmp
	cp MonoDevelop.MonoGame.addin.xml.tmp MonoDevelop.MonoGame.addin.xml

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|Project\(\"\{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC\}\"\) = \"MonoDevelop.MonoGame.Android\", \"MonoDevelop.MonoGame.Android[\]MonoDevelop.MonoGame.Android.csproj\", \"\{FB8E0F6F-522F-4C22-A2F2-1097EB549FE5\}\"\r\nEndProject||g" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|Project\(\"\{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC\}\"\) = \"MonoDevelop.MonoGame.iOS\", \"MonoDevelop.MonoGame.iOS[\]MonoDevelop.MonoGame.iOS.csproj\", \"\{B2150BB5-02A0-4CD7-A61F-C17C09045D1D\}\"\r\nEndProject||g" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|Project\(\"\{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC\}\"\) = \"MonoDevelop.MonoGame.Mac\", \"MonoDevelop.MonoGame.Mac[\]MonoDevelop.MonoGame.Mac.csproj\", \"\{08E68315-4124-4199-BBD9-E57282458A31\}\"\r\nEndProject||g" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln

	#nuget not needed
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'nupkg')]" MonoDevelop.MonoGame.addin.xml

	#part of nuget not used
	xml ed -L -d "/Addin/Extension[@path='/MonoDevelop/Ide/ProjectTemplatePackageRepositories']" IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	#android
	A="{FB8E0F6F-522F-4C22-A2F2-1097EB549FE5}.Debug|Any CPU.ActiveCfg = Debug|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{FB8E0F6F-522F-4C22-A2F2-1097EB549FE5}.Debug|Any CPU.Build.0 = Debug|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{FB8E0F6F-522F-4C22-A2F2-1097EB549FE5}.Release|Any CPU.ActiveCfg = Release|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{FB8E0F6F-522F-4C22-A2F2-1097EB549FE5}.Release|Any CPU.Build.0 = Release|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln

	#ios
	A="{B2150BB5-02A0-4CD7-A61F-C17C09045D1D}.Debug|Any CPU.ActiveCfg = Debug|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{B2150BB5-02A0-4CD7-A61F-C17C09045D1D}.Debug|Any CPU.Build.0 = Debug|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{B2150BB5-02A0-4CD7-A61F-C17C09045D1D}.Release|Any CPU.ActiveCfg = Release|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{B2150BB5-02A0-4CD7-A61F-C17C09045D1D}.Release|Any CPU.Build.0 = Release|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln

	#mac
	A="{08E68315-4124-4199-BBD9-E57282458A31}.Debug|Any CPU.ActiveCfg = Debug|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{08E68315-4124-4199-BBD9-E57282458A31}.Debug|Any CPU.Build.0 = Debug|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{08E68315-4124-4199-BBD9-E57282458A31}.Release|Any CPU.ActiveCfg = Release|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln
	A="{08E68315-4124-4199-BBD9-E57282458A31}.Release|Any CPU.Build.0 = Release|Any CPU" B="" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln

	cd "${S}"
	eapply "${FILESDIR}"/monogame-3.5.1-graphicsutilcs1.patch
	eapply "${FILESDIR}"/monogame-3.5.1-graphicsutilcs2.patch
	eapply "${FILESDIR}"/monogame-3.5.1-sharpfontimportercs.patch
	#eapply "${FILESDIR}"/monogame-3.5.1-linux-absolute-path.patch #testing


	#windows binaries
	xml ed -d "/Project/Files/None/Platforms[text()='Windows']/.." "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition \
	  | xml ed -d "/Project/ProjectGuids/Platform[@Name='Windows']" \
	  | xml ed -d "/Project/Properties/CustomDefinitions/Platform[@Name='Windows']" > "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition.t
	cp "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition.t "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition

	#mac binaries
	xml ed -d "/Project/Files/None/Platforms[text()='MacOS']/.." "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition \
	  | xml ed -d "/Project/ProjectGuids/Platform[@Name='MacOS']" \
	  | xml ed -d "/Project/Properties/CustomDefinitions/Platform[@Name='MacOS']" > "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition.t
	cp "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition.t "${S}"//Build/Projects/MonoGame.Framework.Content.Pipeline.definition

	xml ed -L -u "/Project/Files/None/Link[text()='libassimp.so']" -v "libassimp.so" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='libnvimage.so']" -v "libnvimage.so" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='libnvmath.so']" -v "libnvmath.so" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='libnvtt.so']" -v "libnvtt.so" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='Nvidia.TextureTools.dll.config']" -v "Nvidia.TextureTools.dll.config" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='SharpFont.dll.config']" -v "SharpFont.dll.config" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='AssimpNet.dll.config']" -v "AssimpNet.dll.config" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='ffmpeg']" -v "ffmpeg" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='ffprobe']" -v "ffprobe" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition

	#linux
	A="..\ThirdParty\Dependencies\assimp\libassimp.so" B="/usr/$(get_libdir)/libassimp.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\assimp\AssimpNet.dll.config" B="../ThirdParty/Dependencies/assimp/AssimpNet.dll.config" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\SharpFont\x64\SharpFont.dll.config" B="../ThirdParty/Dependencies/sharpfont/SharpFont.dll.config" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvcore.so" B="/usr/$(get_libdir)/libnvcore.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvimage.so" B="/usr/$(get_libdir)/libnvimage.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvmath.so" B="/usr/$(get_libdir)/libnvmath.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvtt.so" B="/usr/$(get_libdir)/libnvtt.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Windows\Nvidia.TextureTools.dll.config" B="../ThirdParty/Dependencies/nvtt/Nvidia.TextureTools.dll.config" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\ffmpeg\Linux\x64\ffmpeg" B="/usr/bin/ffmpeg" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\ffmpeg\Linux\x64\ffprobe" B="/usr/bin/ffprobe" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition

	#support only linux
	xml ed -L -u "/Project/@Platforms" -v "Linux" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition

	xml ed -L -d "/Project/ProjectGuids/Platform[@Name='Android']" "${S}"/Build/Projects/Lidgren.Network.definition
	xml ed -L -d "/Project/ProjectGuids/Platform[@Name='iOS']" "${S}"/Build/Projects/Lidgren.Network.definition
	xml ed -L -d "/Project/ProjectGuids/Platform[@Name='MacOS']" "${S}"/Build/Projects/Lidgren.Network.definition
	xml ed -L -d "/Project/ProjectGuids/Platform[@Name='Ouya']" "${S}"/Build/Projects/Lidgren.Network.definition
	xml ed -L -d "/Project/ProjectGuids/Platform[@Name='PSMobile']" "${S}"/Build/Projects/Lidgren.Network.definition
	xml ed -L -d "/Project/ProjectGuids/Platform[@Name='Windows']" "${S}"/Build/Projects/Lidgren.Network.definition
	xml ed -L -d "/Project/ProjectGuids/Platform[@Name='WindowsGL']" "${S}"/Build/Projects/Lidgren.Network.definition
	xml ed -L -u "/Project/@Platforms" -v "Linux" "${S}"/Build/Projects/Lidgren.Network.definition

	mkdir -p "${S}"/ThirdParty/Dependencies/nvtt
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "Nvidia.TextureTools.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "libnvtt.so" \
          > "${S}"/ThirdParty/Dependencies/nvtt/Nvidia.TextureTools.dll.config

	mkdir -p "${S}"/ThirdParty/Dependencies/assimp
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "AssimpNet.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "libassimp.so" \
          > "${S}"/ThirdParty/Dependencies/assimp/AssimpNet.dll.config

	mkdir -p "${S}"/ThirdParty/Dependencies/sharpfont
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "SharpFont.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "libfreetype.so" \
          > "${S}"/ThirdParty/Dependencies/sharpfont/SharpFont.dll.config

	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='NDesk.Options']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/NDesk.Options/*/NDesk.Options.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core']/@Path" -v "$(ls /usr/share/nunit-2/nunit.core.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core.interfaces']/@Path" -v "$(ls /usr/share/nunit-2/nunit.core.interfaces.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.framework']/@Path" -v "$(ls /usr/share/nunit-2/nunit.framework.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.util']/@Path" -v "$(ls /usr/share/nunit-2/nunit.util.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit-v2-result-writer" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/$(get_libdir)/monodevelop/AddIns/NUnit/addins/nunit-v2-result-writer.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t #nunit3
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit.engine" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/share/nunit-3/nunit.engine.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t #nunit3
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit.engine.api" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/share/nunit-3/nunit.engine.api.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t #nunit3
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit.framework.tests" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/share/nunit-2/nunit.framework.tests.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t #nunit2
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunitlite" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/share/nunit-3/nunitlite.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t #nunit3
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core']" -v "$(ls /usr/share/nunit-2/nunit.core.dll | tail -n 1)"  "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit 2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core.interfaces']" -v "$(ls /usr/share/nunit-2/nunit.core.interfaces.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit 2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.util']" -v "$(ls /usr/share/nunit-2/nunit.util.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit 2

	#lidgren split off
	#xml ed -L -d "/ExternalProject/Platform[@Type='Linux']/Reference[@Include='Lidgren.Network']" "${S}"/Build/Projects/FrameworkReferences.Net.definition
	rm "${S}"/Build/Projects/Lidgren.Network.definition
	rm "${S}"/Build/Projects/Lidgren.Network.References.definition
	rm -rf "${S}"/ThirdParty/Lidgren.Network

	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Service/Binary[@Name='Tao.Sdl']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Tao.Sdl/*/Tao.Sdl.dll | tail -n 1)" "${S}/Build/Projects/FrameworkReferences.definition"
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Service/Binary[@Name='OpenTK']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/OpenTK/*/OpenTK.dll | tail -n 1)" "${S}/Build/Projects/FrameworkReferences.definition"

	#opentk
	xml ed -L -d "/configuration/dllmap[@os='linux']" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config
	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "opengl32.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libGL.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "glu32.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libGLU.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "openal32.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libopenal.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "alut.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libalut.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "opencl.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libOpenCL.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "libX11" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libX11.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "libXi" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libXi.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/Dependencies/OpenTK.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "SDL2.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libSDL2.so | tail -n 1)" > "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t
	cp "${S}"/ThirdParty/Dependencies/OpenTK.dll.config.t "${S}"/ThirdParty/Dependencies/OpenTK.dll.config

	#mgcb

	#gamepad config
	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "SDL.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libSDL.so | tail -n 1)" > "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t
	cp "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "SDL_image.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libSDL_image.so | tail -n 1)" > "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t
	cp "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "SDL_mixer.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libSDL_mixer.so | tail -n 1)" > "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t
	cp "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "SDL_ttf.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libSDL_ttf.so | tail -n 1)" > "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t
	cp "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "SDL_net.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libSDL_net.so | tail -n 1)" > "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t
	cp "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "smpeg.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libsmpeg.so | tail -n 1)" > "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t
	cp "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config

	xml ed -s "/configuration" -t elem -name "dllmap" "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config | xml ed -a "/configuration/dllmap[last()]" -t attr -n "os" -v "linux" | xml ed -s "/configuration/dllmap[last()]" -t attr -name "dll" -v "SDL_gfx.dll" \
	  | xml ed -s "/configuration/dllmap[last()]" -t attr -name "target" -v "$(ls /usr/$(get_libdir)/libSDL_gfx.so | tail -n 1)" > "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t
	cp "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config.t "${S}"/ThirdParty/GamepadConfig/Tao.Sdl.dll.config

	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gtk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gtk-sharp/3*/gtk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='atk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/atk-sharp/3*/atk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gdk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gdk-sharp/3*/gdk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	#xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glade-sharp']/@Path" -v "$(ls | tail -n 1)" "${S}"/Build//Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glib-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/glib-sharp/3*/glib-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gtk-dotnet']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gtk-dotnet/3*/gtk-dotnet.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='pango-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/pango-sharp/3*/pango-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -d "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glade-sharp']" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='Mono.Posix']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Mono.Posix/*/Mono.Posix.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition #from mono package

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary"  "${S}/Build/Projects/PipelineReferences.definition" \
	  | xml ed -a "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n  "Name" -v "gio-sharp" \
          | xml ed -a "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n  "Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gio-sharp/3*/gio-sharp.dll | tail -n 1)" > "${S}"/Build/Projects/PipelineReferences.definition.t
	cp "${S}"/Build/Projects/PipelineReferences.definition.t "${S}"/Build/Projects/PipelineReferences.definition

	mkdir -p "${S}"/ThirdParty/Dependencies/Gtk3
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "$(ls /usr/$(get_libdir)/mono/gac/atk-sharp/3*/atk-sharp.dll | tail -n 1)" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libatk-1.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/atk-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "$(ls /usr/$(get_libdir)/mono/gac/gdk-sharp/3*/gdk-sharp.dll | tail -n 1)" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libgdk-3.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/gdk-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "$(ls /usr/$(get_libdir)/mono/gac/glib-sharp/3*/glib-sharp.dll | tail -n 1)" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libglib-2.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/glib-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "$(ls /usr/$(get_libdir)/mono/gac/gtk-sharp/3*/gtk-sharp.dll | tail -n 1)" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libgtk-3.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/gtk-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "$(ls /usr/$(get_libdir)/mono/gac/pango-sharp/3*/pango-sharp.dll | tail -n 1)" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libpango-1.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/pango-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "$(ls /usr/$(get_libdir)/mono/gac/gio-sharp/3*/gio-sharp.dll | tail -n 1)" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libgio-2.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/gio-sharp.dll.config

	xml ed -L -u "/Addin/@version" -v "${PV}" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	#line below is a continuation of monogame-3.5.1-monodevelop-5-addin.patch
	xml ed -L -d "//Dependencies" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	mkdir -p "ThirdParty/Dependencies/Gtk3"

	eapply "${FILESDIR}/monogame-3.5.1-no-kickstart-and-external-deps.patch"

	cd "${S}"

	xml ed -L -u "//Platform[@Type='Linux']/Binary[@Path='ThirdParty\Dependencies\assimp\AssimpNet.dll']/@Path"  -v "/usr/$(get_libdir)/mono/assimp-net/AssimpNet.dll"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/Binary[@Path='ThirdParty\Dependencies\NVTT\Windows\Nvidia.TextureTools.dll']/@Path"  -v "/usr/$(get_libdir)/mono/nvidia-texture-tools/monogame/Nvidia.TextureTools.dll"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/Binary[@Path='ThirdParty\Dependencies\SharpFont\x32\SharpFont.dll']/@Path"  -v "/usr/$(get_libdir)/mono/sharpfont/SharpFont.dll"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/Binary[@Path='ThirdParty\Dependencies\PVRTexLibNET\PVRTexLibNET.dll']/@Path"  -v "/usr/$(get_libdir)/mono/pvrtexlibnet/PVRTexLibNET.dll"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/Binary[@Path='ThirdParty\Dependencies\ATI.TextureConverter\ATI.TextureConverter.dll']/@Path"  -v "/usr/$(get_libdir)/mono/atitextureconverter/ATI.TextureConverter.dll"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\assimp\libassimp.so']/@Path"  -v "/usr/$(get_libdir)/libassimp.so"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\NVTT\Linux\libnvcore.so']/@Path"  -v "/usr/$(get_libdir)/libnvcore.so"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\NVTT\Linux\libnvimage.so']/@Path"  -v "/usr/$(get_libdir)/libnvimage.so"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\NVTT\Linux\libnvmath.so']/@Path"  -v "/usr/$(get_libdir)/libnvmath.so"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\NVTT\Linux\libnvtt.so']/@Path"  -v "/usr/$(get_libdir)/libnvtt.so"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\NVTT\Windows\Nvidia.TextureTools.dll.config']/@Path"  -v "ThirdParty\Dependencies\nvtt\Nvidia.TextureTools.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\SharpFont\x64\SharpFont.dll.config']/@Path"  -v "ThirdParty\Dependencies\sharpfont\SharpFont.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	#xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\assimp\AssimpNet.dll.config']/@Path"  -v "ThirdParty\Dependencies\assimp\AssimpNet.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	#xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\FreeImage.NET\FreeImageNET.dll.config']/@Path"  -v "ThirdParty\Dependencies\FreeImage.NET\FreeImageNET.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\FreeImage.NET\Linux\x64\libfreeimage-3.17.0.so']/@Path"  -v "$(ls /usr/lib/libfreeimage-*.so | tail -n 1)"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\ffmpeg\Linux\x64\ffmpeg']/@Path"  -v "/usr/bin/ffmpeg"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\ffmpeg\Linux\x64\ffprobe']/@Path"  -v "/usr/bin/ffprobe"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	if use abi_x86_32 ; then
		xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\PVRTexLibNET\Linux\x86\libPVRTexLibWrapper.so']/@Path"  -v "/usr/lib32/libPVRTexLibWrapper.so"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	else
		xml ed -L -d "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\PVRTexLibNET\Linux\x86\libPVRTexLibWrapper.so']" ./Build/Projects/Framework.Content.Pipeline.References.definition
	fi
	if use abi_x86_64 ; then
		xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\PVRTexLibNET\Linux\x64\libPVRTexLibWrapper.so']/@Path"  -v "/usr/lib64/libPVRTexLibWrapper.so"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	else
		xml ed -L -d "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\PVRTexLibNET\Linux\x64\libPVRTexLibWrapper.so']" ./Build/Projects/Framework.Content.Pipeline.References.definition
	fi
	#xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\PVRTexLibNET\PVRTexLibNET.dll.config']/@Path"  -v "ThirdParty\Dependencies\PVRTexLibNET\PVRTexLibNET.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	#xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\ATI.TextureConverter\ATI.TextureConverter.dll.config']/@Path"  -v "ThirdParty\Dependencies\ATI.TextureConverter\ATI.TextureConverter.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition

	eapply_user

	#use the system protobuild
	rm Protobuild.exe

	einfo "Generating project files"
	mono /usr/bin/Protobuild.exe -generate Linux

	#force absolute paths because Protobuild wants relative paths
	sed -i -e 's|\.\.\\usr\\|\\usr\\|g' ./MonoGame.Framework.Content.Pipeline/MonoGame.Framework.Content.Pipeline.Linux.csproj
	sed -i -e 's|\.\.\\usr\\|\\usr\\|g' ./Test/MonoGame.Tests.Linux.csproj
	sed -i -e 's|\.\.\\\.\.\\usr\\|\\usr\\|g' ./Tools/Pipeline/Pipeline.Linux.csproj

	sed -i -e 's|xmlns="http://schemas.microsoft.com/developer/msbuild/2003"||g' ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -u "//HintPath[text()='/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/MonoDevelop.Core.dll']" -v "/usr/$(get_libdir)/monodevelop/bin/MonoDevelop.Core.dll"  ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -u "//HintPath[text()='/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/MonoDevelop.Ide.dll']" -v "/usr/$(get_libdir)/monodevelop/bin/MonoDevelop.Ide.dll"  ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -u "//HintPath[text()='/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/AddIns/MonoDevelop.DesignerSupport/MonoDevelop.DesignerSupport.dll']" -v "/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.DesignerSupport/MonoDevelop.DesignerSupport.dll"  ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -u "//HintPath[text()='/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/ICSharpCode.NRefactory.dll']" -v "/usr/$(get_libdir)/monodevelop/bin/ICSharpCode.NRefactory.dll"  ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -u "//HintPath[text()='/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/Mono.TextEditor.dll']" -v "/usr/$(get_libdir)/monodevelop/bin/Mono.TextEditor.dll"  ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -u "//HintPath[text()='/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/Mono.Addins.dll']" -v "/usr/$(get_libdir)/mono/mono-addins/Mono.Addins.dll" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	#no xamarin studio for linux
	#sed -r -e "s|/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/XamarinStudio.exe|/usr/lib/monodevelop/bin/XamarinStudio.exe|g" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	#sed -r -e "s|workingdir="/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/"|workingdir="/usr/lib/monodevelop/bin/"|g" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -s "//Project" -t attr -n "xmlns" -v "http://schemas.microsoft.com/developer/msbuild/2003" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj

	genkey
}

src_configure(){
	true
}

src_compile() {
	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	einfo "Building monogame and tools"
	#nant -t:mono-4.5 build_linux || die
	xbuild /p:Configuration=${mydebug} /t:Clean /p:Configuration=Release MonoGame.Framework.Linux.sln || die

	#inject public key into assembly
	public_key=$(sn -tp "${PN}-keypair.snk" | tail -n 7 | head -n 5 | tr -d '\n')
	echo "pk is: ${public_key}"
	cd "${S}"
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Framework.Content.Pipeline\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Framework.Content.Pipeline, PublicKey=${public_key}\")\]|" ./MonoGame.Framework/Properties/AssemblyInfo.cs
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Framework.Net\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Framework.Net, PublicKey=${public_key}\")\]|" ./MonoGame.Framework/Properties/AssemblyInfo.cs
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGameTests\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGameTests, PublicKey=${public_key}\")\]|" ./MonoGame.Framework/Properties/AssemblyInfo.cs

	xbuild /p:Configuration=${mydebug} /t:Build /p:Configuration=Release MonoGame.Framework.Linux.sln /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" || die

	einfo "Building addin"
	xbuild /p:Configuration=${mydebug} IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln || die
}

src_install() {
	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"
	cd "${S}"

	savekey

	cp "${S}/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml" "${S}/IDE/MonoDevelop/bin/${mydebug}/MonoDevelop.MonoGame.MonoDevelop.MonoGame.addin.xml"

	#primary dlls

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll"
                egacinstall "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Content.Pipeline.dll"
                egacinstall "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Net.dll"
                egacinstall "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll"
        done


	eend

        dodoc -r Documentation/*

	MSBUILDTOOLSPATH="/usr/lib/mono/4.5/"
	MSBUILDEXTENSIONSPATH="/usr/lib/mono/xbuild/"

	#addins
	mkdir -p "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/
	cp -r "${S}/IDE/MonoDevelop/bin/${mydebug}"/*  "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/

	#missing addin stuff
	cp -r "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/icons "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/

	#
	if use gamepad-config; then
		mkdir -p "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/GamepadConfig"
		cp "${S}"/ThirdParty/GamepadConfig/Gamepad*.dll "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/GamepadConfig/"
		cp "${S}"/ThirdParty/GamepadConfig/*.xml "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/GamepadConfig/"
		cp "${S}"/ThirdParty/GamepadConfig/License.txt "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/GamepadConfig/"
	fi

	#monogame content builder
	if use mgcb; then
		mkdir -p "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}/Tools/MGCB/bin/Linux/AnyCPU/${mydebug}/MGCB.exe" "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}/Tools/MGCB/bin/Linux/AnyCPU/${mydebug}"/*.dll "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}/IDE/MonoDevelop/bin/Release/templates/Common/Content.mgcb" "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Content.mgcb"
	fi

	#gui frontend for content processing
	if use pipeline; then
		mkdir -p "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}"/Tools/Pipeline/bin/Linux/AnyCPU/${mydebug}/*.exe "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}"/Tools/Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Content.Pipeline.dll "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp -r "${S}"/Tools/Pipeline/Templates "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
	fi

	rm "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	echo "//Dear Gentoo MonoGame developer:" > "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t
	echo "//You need to set LIBGL_DRIVERS_PATH in Solution > Projects > Options > Run > General in MonoDevelop to" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
	echo "//  /usr/lib/opengl/ati/lib" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
	echo "//  /usr/lib/opengl/xorg-x11/lib" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
	echo "//  /usr/lib/opengl/intel/lib" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
	echo "//  /usr/lib/opengl/nvidia/lib" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
	echo "//  or in your wrapper script before running your MonoGame app." >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
	cat "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
	mv "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t" "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs"

	mkdir -p "${D}/usr/lib/mono/4.5/"
	cp "${S}/MonoGame.Framework.Content.Pipeline/MonoGame.Content.Builder.targets" "${D}/usr/lib/mono/4.5/"

	mkdir -p "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/"
	cp "${S}/MonoGame.Framework.Content.Pipeline/MonoGame.Content.Builder.targets" "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/MonoGame.Content.Builder.targets"
	cp "${S}/MonoGame.Framework.Content.Pipeline/MonoGame.Common.props" "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/MonoGame.Common.props"
}

pkg_postinst() {
	#update addins
	mautil -reg "${ROOT}"/usr/$(get_libdir)/mono/gac -p "${ROOT}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame reg-build -v
	elog "You need to set your project's LIBGL_DRIVERS_PATH to your video card driver /usr/lib/opengl/{ati,xorg-x11,intel,nvidia}/lib in"
	elog "Solution > Projects > Options > Run > General in MonoDevelop or in or your wrapper script before running your MonoGame app."
	einfo
	einfo "Say no to File Conflict when creating a new MonoGame Solution for both Tao.Sdl.dll.config and OpenTK.dll.config files."
	einfo

	if use gamepad-config ; then
		ewarn "You are merging the GamepadConfig.dll binary and dependencies which has NOT been compiled from source.  We do not know if it is safe.  Use it at your own risk."
		einfo "GamepadConfig user..."
		einfo "See https://github.com/tobiasschulz/MonoGame-SDL2/wiki/Tutorials:Making-use-of-the-new-Gamepad-functionality-on-Windows-Linux-OSX for details."
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


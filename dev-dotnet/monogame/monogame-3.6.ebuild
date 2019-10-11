# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="One framework for creating powerful cross-platform games."
HOMEPAGE="http://www.monogame.net"
LICENSE="Ms-PL"
KEYWORDS="~amd64 ~x86"
inherit multilib-build
RDEPEND="addin? (
		>=dev-dotnet/mono-addins-1.0
		>=dev-util/monodevelop-6.1.2.0
	 )
	   dev-dotnet/assimp-net
	   dev-dotnet/atitextureconverter
	 >=dev-dotnet/eto-9999.20171218[gtk-sharp3]
	   dev-dotnet/freeimagenet
	   dev-dotnet/gtk-sharp:3
	 >=dev-dotnet/lidgren-network-gen3-2015.12.18
	   dev-dotnet/ndesk-options
	 >=dev-dotnet/nvorbis-9999
	   dev-dotnet/opentk
           dev-dotnet/pvrtexlibnet[${MULTILIB_USEDEP}]
	   dev-dotnet/sharpfont
	   dev-dotnet/tao-framework
	   dev-dotnet/xwt
	 >=dev-util/nant-0.93_pre20151114
	 >=dev-util/nunit-3.0.1:3
	   dev-util/nunit:2
	   media-gfx/nvidia-texture-tools[gac]
	   media-libs/assimp[${MULTILIB_USEDEP}]
	   media-libs/freealut[${MULTILIB_USEDEP}]
	 >=media-libs/libsdl2-2.0.5[${MULTILIB_USEDEP}]
	   media-libs/openal[${MULTILIB_USEDEP}]
	   virtual/ffmpeg"
DEPEND="${RDEPEND}
	app-text/xmlstarlet
        dev-dotnet/protobuild"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} abi_x86_32 abi_x86_64 addin bindist debug doc +gac mgcb pipeline"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 )"
inherit dotnet eutils mono
SRC_URI="https://github.com/MonoGame/MonoGame/archive/v${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/MonoGame-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"
RESTRICT="mirror"

pkg_setup() {
	dotnet_pkg_setup
}

src_prepare() {
	if [ ! -f /usr/$(get_libdir)/mono/nvidia-texture-tools/monogame/Nvidia.TextureTools.dll ]; then
		die "You can only use nvidia-texture-tools from the oiledmachine-overlay. (1)"
	fi
	if [ ! -f /usr/$(get_libdir)/mono/nvidia-texture-tools/monogame/Nvidia.TextureTools.dll.config ]; then
		die "You can only use nvidia-texture-tools from the oiledmachine-overlay. (2)"
	fi
	if [ ! -f /usr/$(get_libdir)/mono/gac/SharpFont/*/SharpFont.dll.config ]; then
		die "You can only use sharpfont from the oiledmachine-overlay."
	fi
	if [ ! -f /usr/$(get_libdir)/mono/gac/AssimpNet/*/AssimpNet.dll.config ]; then
		die "You can only use assimpnet from the oiledmachine-overlay."
	fi
	if [ ! -f /usr/$(get_libdir)/mono/gac/FreeImageNET/*/FreeImageNET.dll.config ]; then
		die "You can only use freeimagenet from the oiledmachine-overlay."
	fi
	if [ ! -f /usr/$(get_libdir)/mono/gac/PVRTexLibNET/*/PVRTexLibNET.dll.config ]; then
		die "You can only use pvrtexlibnet from the oiledmachine-overlay."
	fi
	if [ ! -f /usr/$(get_libdir)/mono/gac/ATI.TextureConverter/*/ATI.TextureConverter.dll.config ]; then
		die "You can only use atitextureconverter from the oiledmachine-overlay."
	fi
	if [ ! -f /usr/$(get_libdir)/mono/gac/OpenTK/*/OpenTK.dll.config ]; then
		die "You can only use opentk from the oiledmachine-overlay."
	fi
	if [ ! -f /usr/$(get_libdir)/mono/gac/Tao.Sdl/*/Tao.Sdl.dll.config ]; then
		die "You can only use the tao-framework from the oiledmachine-overlay."
	fi

	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	#eapply "${FILESDIR}/${PN}-3.5.1-monodevelop-6-addin.patch" || die #not ready yet
	eapply "${FILESDIR}/${PN}-3.5.1-monodevelop-5-addin.patch" || die

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

	#part of nuget not used currently
	xml ed -L -d "/Addin/Extension[@path='/MonoDevelop/Ide/ProjectTemplatePackageRepositories']" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

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
	eapply "${FILESDIR}"/${PN}-3.6-graphicsutilcs1.patch
	eapply "${FILESDIR}"/${PN}-3.6-graphicsutilcs2.patch
	eapply "${FILESDIR}"/${PN}-3.5.1-sharpfontimportercs.patch
	#eapply "${FILESDIR}"/${PN}-3.5.1-linux-absolute-path.patch #testing


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
	xml ed -L -u "/Project/Files/None/Link[text()='Nvidia.TextureTools.dll.config']" -v "/usr/$(get_libdir)/mono/gac/Nvidia.TextureTools/*/Nvidia.TextureTools.dll.config" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='SharpFont.dll.config']" -v "/usr/$(get_libdir)/mono/gac/SharpFont/*/SharpFont.dll.config" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='AssimpNet.dll.config']" -v "/usr/$(get_libdir)/mono/gac/AssimpNet/*/AssimpNet.dll.config" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='ffmpeg']" -v "ffmpeg" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	xml ed -L -u "/Project/Files/None/Link[text()='ffprobe']" -v "ffprobe" "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition

	#linux
	A="..\ThirdParty\Dependencies\assimp\libassimp.so" B="/usr/$(get_libdir)/libassimp.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\assimp\AssimpNet.dll.config" B="/usr/$(get_libdir)/mono/gac/AssimpNet/*/AssimpNet.dll.config" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\SharpFont\x64\SharpFont.dll.config" B="/usr/$(get_libdir)/mono/gac/SharpFont/*/SharpFont.dll.config" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvcore.so" B="/usr/$(get_libdir)/libnvcore.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvimage.so" B="/usr/$(get_libdir)/libnvimage.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvmath.so" B="/usr/$(get_libdir)/libnvmath.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Linux\libnvtt.so" B="/usr/$(get_libdir)/libnvtt.so" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
	A="..\ThirdParty\Dependencies\NVTT\Windows\Nvidia.TextureTools.dll.config" B="/usr/$(get_libdir)/mono/gac/Nvidia.TextureTools/*/Nvidia.TextureTools.dll.config" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${S}"/Build/Projects/MonoGame.Framework.Content.Pipeline.definition
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

	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='NDesk.Options']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/NDesk.Options/*/NDesk.Options.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core']/@Path" -v "$(ls /usr/share/nunit-2/nunit.core.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core.interfaces']/@Path" -v "$(ls /usr/share/nunit-2/nunit.core.interfaces.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.framework']/@Path" -v "$(ls /usr/share/nunit-2/nunit.framework.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.util']/@Path" -v "$(ls /usr/share/nunit-2/nunit.util.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition #nunit2

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit-v2-result-writer" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/share/nunit-3/nunit-v2-result-writer.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t #nunit3
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

	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gtk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gtk-sharp/3*/gtk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='atk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/atk-sharp/3*/atk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gdk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gdk-sharp/3*/gdk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	#xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glade-sharp']/@Path" -v "$(ls | tail -n 1)" "${S}"/Build//Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glib-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/glib-sharp/3*/glib-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gtk-dotnet']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gtk-dotnet/3*/gtk-dotnet.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='pango-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/pango-sharp/3*/pango-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -d "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glade-sharp']" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='Mono.Posix']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Mono.Posix/*/Mono.Posix.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition #from mono package
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='Eto.Forms']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Eto/*/Eto.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='Eto.Gtk3']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Eto.Gtk3/*/Eto.Gtk3.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='Xwt']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Xwt/*/Xwt.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='Xwt.Gtk3']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Xwt.Gtk3/*/Xwt.Gtk3.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary"  "${S}/Build/Projects/PipelineReferences.definition" \
	  | xml ed -a "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n  "Name" -v "gio-sharp" \
          | xml ed -a "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n  "Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gio-sharp/3*/gio-sharp.dll | tail -n 1)" > "${S}"/Build/Projects/PipelineReferences.definition.t
	cp "${S}"/Build/Projects/PipelineReferences.definition.t "${S}"/Build/Projects/PipelineReferences.definition

	xml ed -L -u "/Addin/@version" -v "${PV}" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	#line below is a continuation of ${PN}-3.5.1-monodevelop-5-addin.patch
	xml ed -L -d "//Dependencies" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	mkdir -p "ThirdParty/Dependencies/Gtk3"

	eapply "${FILESDIR}/${PN}-3.6-no-kickstart-and-external-deps.patch"

	#eapply "${FILESDIR}/${PN}-3.5.1-activate-linux-shaders.patch"

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
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\NVTT\Windows\Nvidia.TextureTools.dll.config']/@Path"  -v "/usr/$(get_libdir)/mono/gac/Nvidia.TextureTools/*/Nvidia.TextureTools.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\SharpFont\x64\SharpFont.dll.config']/@Path"  -v "/usr/$(get_libdir)/mono/gac/SharpFont/*/SharpFont.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\assimp\AssimpNet.dll.config']/@Path"  -v "/usr/$(get_libdir)/mono/gac/AssimpNet/*/AssimpNet.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\FreeImage.NET\FreeImageNET.dll.config']/@Path"  -v "/usr/$(get_libdir)/mono/gac/FreeImageNET/*/FreeImageNET.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
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
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\PVRTexLibNET\PVRTexLibNET.dll.config']/@Path"  -v "/usr/$(get_libdir)/mono/gac/PVRTexLibNET/*/PVRTexLibNET.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition
	xml ed -L -u "//Platform[@Type='Linux']/NativeBinary[@Path='ThirdParty\Dependencies\ATI.TextureConverter\ATI.TextureConverter.dll.config']/@Path"  -v "/usr/$(get_libdir)/mono/gac/ATI.TextureConverter/*/ATI.TextureConverter.dll.config"  ./Build/Projects/Framework.Content.Pipeline.References.definition


	xml ed -L -u "/Project/Files/None[@Include='..\ThirdParty\Dependencies\OpenTK.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/OpenTK/*/OpenTK.dll.config"  Build/Projects/MonoGame.Framework.definition
	xml ed -L -u "/Project/Files/None[@Include='..\ThirdParty\Dependencies\ATI.TextureConverter\ATI.TextureConverter.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/AssimpNet/*/AssimpNet.dll.config"  Build/Projects/MonoGame.Framework.definition
	xml ed -L -u "/Project/Files/None[@Include='..\ThirdParty\Dependencies\PVRTexLibNET\PVRTexLibNET.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/PVRTexLibNET/*/PVRTexLibNET.dll.config"  Build/Projects/MonoGame.Framework.definition
	xml ed -L -u "/Project/Files/None[@Include='..\ThirdParty\Dependencies\FreeImage.NET\FreeImageNET.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/FreeImageNET/*/FreeImageNET.dll.config"  Build/Projects/MonoGame.Framework.definition
	xml ed -L -u "/Project/Files/None[@Include='..\ThirdParty\Dependencies\assimp\AssimpNet.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/AssimpNet/*/AssimpNet.dll.config"  Build/Projects/MonoGame.Framework.definition

	xml ed -L -u "/Project/Files/None[@Include='..\ThirdParty\GamepadConfig\Tao.Sdl.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/Tao.Sdl/*/Tao.Sdl.dll.config"  Build/Projects/MonoGame.Framework.definition

	sed -i -r -e "s|OpenTK.dll.config|/usr/$(get_libdir)/mono/gac/OpenTK/*/OpenTK.dll.config|g" ./ProjectTemplates/VisualStudio2010/DesktopGL/MonoGameDesktopGLApplication.csproj

	sed -i -r -e "s|\"libmojoshader_64.dll\"|\"libmojoshader.dll\"|g" Tools/2MGFX/MojoShader.cs
	sed -i -r -e "s|\"libmojoshader_32.dll\"|\"libmojoshader.dll\"|g" Tools/2MGFX/MojoShader.cs

	eapply "${FILESDIR}/${PN}-3.6-no-compiling-nvorbis.patch"
	eapply "${FILESDIR}/${PN}-3.6-nvorbis-reference.patch"
	eapply "${FILESDIR}/${PN}-3.6-no-copy-dependencies.patch"

	cp -a "${FILESDIR}/MonoGame.Framework.dll.config" ThirdParty/Dependencies/ || die

	eapply "${FILESDIR}/${PN}-3.6-no-copy-dependencies-test.patch"
	eapply "${FILESDIR}/${PN}-3.6-awt-DragEventArgs.patch"
	eapply "${FILESDIR}/${PN}-3.6-no-copy-monodevelop-dependencies.patch"

	#todo ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	pushd "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame
	#remove mac files
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'libopenal.1.dylib')]" MonoDevelop.MonoGame.addin.xml
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'libSDL2-2.0.0.dylib')]" MonoDevelop.MonoGame.addin.xml
	#remove extras
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x86/SDL2.dll')]" MonoDevelop.MonoGame.addin.xml
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x64/SDL2.dll')]" MonoDevelop.MonoGame.addin.xml
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x86/soft_oal.dll')]" MonoDevelop.MonoGame.addin.xml
	xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x64/soft_oal.dll')]" MonoDevelop.MonoGame.addin.xml
	#change to absolute path
	if use abi_x86_64 ; then
		xml ed -L -u "/Addin/Runtime/Import[contains(@file,'x64/libSDL2-2.0.so.0')]/@file" -v "/usr/lib64/libSDL2-2.0.so.0" MonoDevelop.MonoGame.addin.xml
		xml ed -L -u "/Addin/Runtime/Import[contains(@file,'x64/libopenal.so.1')]/@file" -v "/usr/lib64/libopenal.so.1" MonoDevelop.MonoGame.addin.xml
	else
		xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x64/libSDL2-2.0.so.0')]/@file" MonoDevelop.MonoGame.addin.xml
		xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x64/libopenal.so.1')]/@file" MonoDevelop.MonoGame.addin.xml
	fi
	if use abi_x86_32 ; then
		xml ed -L -u "/Addin/Runtime/Import[contains(@file,'x86/libSDL2-2.0.so.0')]/@file" -v "/usr/lib32/libSDL2-2.0.so.0" MonoDevelop.MonoGame.addin.xml
		xml ed -L -u "/Addin/Runtime/Import[contains(@file,'x86/libopenal.so.1')]/@file" -v "/usr/lib32/libopenal.so.1" MonoDevelop.MonoGame.addin.xml
	else
		xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x86/libSDL2-2.0.so.0')]/@file" MonoDevelop.MonoGame.addin.xml
		xml ed -L -d "/Addin/Runtime/Import[contains(@file,'x86/libopenal.so.1')]/@file" MonoDevelop.MonoGame.addin.xml
	fi
	popd

	if use abi_x86_64 ; then
		xml ed -L -u "/Template/Combine/Project/Files/Directory[contains(@name,'x64')]/ContentFile/RawFile[contains(@name,'libopenal.so.1')]/@src" -v "/usr/lib64/libopenal.so.1" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
		xml ed -L -u "/Template/Combine/Project/Files/Directory[contains(@name,'x64')]/ContentFile/RawFile[contains(@name,'libSDL2-2.0.so.0')]/@src" -v "/usr/lib64/libSDL2-2.0.so.0" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
		xml ed -L -d "/Template/Combine/Project/Files/Directory[contains(@name,'x64')]/ContentFile/RawFile[contains(@name,'soft_oal.dll')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
		xml ed -L -d "/Template/Combine/Project/Files/Directory[contains(@name,'x64')]/ContentFile/RawFile[contains(@name,'SDL2.dll')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
	else
		xml ed -L -d "/Template/Combine/Project/Files/Directory[contains(@name,'x64')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
	fi

	if use abi_x86_32 ; then
		xml ed -L -u "/Template/Combine/Project/Files/Directory[contains(@name,'x86')]/ContentFile/RawFile[contains(@name,'libopenal.so.1')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
		xml ed -L -u "/Template/Combine/Project/Files/Directory[contains(@name,'x86')]/ContentFile/RawFile[contains(@name,'libSDL2-2.0.so.0')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
		xml ed -L -d "/Template/Combine/Project/Files/Directory[contains(@name,'x86')]/ContentFile/RawFile[contains(@name,'soft_oal.dll')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
		xml ed -L -d "/Template/Combine/Project/Files/Directory[contains(@name,'x86')]/ContentFile/RawFile[contains(@name,'SDL2.dll')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
	else
		xml ed -L -d "/Template/Combine/Project/Files/Directory[contains(@name,'x86')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
	fi

	xml ed -L -d "/Template/Combine/Project/Files/ContentFile/RawFile[contains(@name,'libopenal.1.dylib')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml
	xml ed -L -d "/Template/Combine/Project/Files/ContentFile/RawFile[contains(@name,'libSDL2-2.0.0.dylib')]" IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml

	sed -i -r -e 's|<ContentFile/>||g' IDE/MonoDevelop/MonoDevelop.MonoGame/templates/MonoGameProject.xpt.xml

	if use abi_x86_64 ; then
		xml ed -L -d "/Project/Files/None[contains(@Include,'lib32/libSDL2-2.0.so.0')]" Build/Projects/MonoGame.Framework.definition
		xml ed -L -d "/Project/Files/None[contains(@Include,'lib32/libopenal.so')]" Build/Projects/MonoGame.Framework.definition
	fi

	if use abi_x86_32 ; then
		xml ed -L -d "/Project/Files/None[contains(@Include,'lib64/libSDL2-2.0.so.0')]" Build/Projects/MonoGame.Framework.definition
		xml ed -L -d "/Project/Files/None[contains(@Include,'lib64/libopenal.so')]" Build/Projects/MonoGame.Framework.definition
	fi

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

	xml ed -L -u "//Content[@Include='..\..\..\ThirdParty\GamepadConfig\Tao.Sdl.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/Tao.Sdl/*/Tao.Sdl.dll" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj || die p12016
	xml ed -L -u "//Content[@Include='..\..\..\ThirdParty\Dependencies\OpenTK.dll.config']/@Include" -v "/usr/$(get_libdir)/mono/gac/OpenTK/*/OpenTK.dll.config" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj || die p22016

	#no xamarin studio for linux
	#sed -r -e "s|/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/XamarinStudio.exe|/usr/lib/monodevelop/bin/XamarinStudio.exe|g" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	#sed -r -e "s|workingdir="/Applications/Xamarin Studio.app/Contents/Resources/lib/monodevelop/bin/"|workingdir="/usr/lib/monodevelop/bin/"|g" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj
	xml ed -L -s "//Project" -t attr -n "xmlns" -v "http://schemas.microsoft.com/developer/msbuild/2003" ./IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.csproj

	egenkey

	#inject public key into assembly
	public_key=$(sn -tp "${PN}-keypair.snk" | tail -n 7 | head -n 5 | tr -d '\n')
	echo "pk is: ${public_key}"
	cd "${S}"
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Framework.Content.Pipeline\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Framework.Content.Pipeline, PublicKey=${public_key}\")\]|" ./MonoGame.Framework/Properties/AssemblyInfo.cs
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Framework.Net\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Framework.Net, PublicKey=${public_key}\")\]|" ./MonoGame.Framework/Properties/AssemblyInfo.cs
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGameTests\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGameTests, PublicKey=${public_key}\")\]|" ./MonoGame.Framework/Properties/AssemblyInfo.cs
}

src_compile() {
	einfo "Building monogame and tools"
	#nant -t:mono-4.5 build_linux || die
	exbuild_strong /t:Clean MonoGame.Framework.Linux.sln || die

	exbuild_strong /t:Build MonoGame.Framework.Linux.sln || die

	if use addin ; then
		einfo "Building addin"
		exbuild IDE/MonoDevelop/MonoDevelop.MonoGame.Addin.sln || die
	fi
}

src_install() {
	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	cd "${S}"

	esavekey

        ebegin "Installing dlls into the GAC"

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

        use doc && dodoc -r Documentation/*

	MSBUILDTOOLSPATH="/usr/lib/mono/${EBF}/"
	MSBUILDEXTENSIONSPATH="/usr/lib/mono/xbuild/"

	if use addin ; then
		cp "${S}/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml" "${S}/IDE/MonoDevelop/bin/${mydebug}/MonoDevelop.MonoGame.MonoDevelop.MonoGame.addin.xml"

		#addins
		mkdir -p "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/
		cp -r "${S}/IDE/MonoDevelop/bin/${mydebug}"/*  "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/

		#missing addin stuff
		cp -r "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/icons "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/
	fi

	#monogame content builder
	if use mgcb; then
		mkdir -p "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}/Tools/MGCB/bin/Linux/AnyCPU/${mydebug}/MGCB.exe" "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}/Tools/MGCB/bin/Linux/AnyCPU/${mydebug}"/*.dll "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		use addin && cp "${S}/IDE/MonoDevelop/bin/Release/templates/Common/Content.mgcb" "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Content.mgcb"
	fi

	#gui frontend for content processing
	if use pipeline; then
		mkdir -p "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}"/Tools/Pipeline/bin/Linux/AnyCPU/${mydebug}/*.exe "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp "${S}"/Tools/Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Content.Pipeline.dll "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
		cp -r "${S}"/Tools/Pipeline/Templates "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/Tools/"
	fi

	if use addin ; then
		echo "//Dear Gentoo MonoGame developer:" > "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t
		echo "//You need to set LIBGL_DRIVERS_PATH in Solution > Projects > Options > Run > General in MonoDevelop to" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
		echo "//  /usr/lib/dri" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
		echo "//  or in your wrapper script before running your MonoGame app." >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
		cat "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs" >> "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t"
		mv "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs.t" "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Game1.cs"

		cp /usr/$(get_libdir)/mono/gac/Tao.Sdl/*/Tao.Sdl.dll.config "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/" || die
	fi

	mkdir -p "${D}/usr/lib/mono/4.5/"
	cp "${S}/MonoGame.Framework.Content.Pipeline/MonoGame.Content.Builder.targets" "${D}/usr/lib/mono/4.5/"

	mkdir -p "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/"
	cp "${S}/MonoGame.Framework.Content.Pipeline/MonoGame.Content.Builder.targets" "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/MonoGame.Content.Builder.targets"
	cp "${S}/MonoGame.Framework.Content.Pipeline/MonoGame.Common.props" "${D}/${MSBUILDEXTENSIONSPATH}/MonoGame/v3.0/MonoGame.Common.props"
}

pkg_postinst() {
	if use addin ; then
		#update addins
		mautil -reg "${ROOT}"/usr/$(get_libdir)/mono/gac -p "${ROOT}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame reg-build -v
		elog "You need to set your project's LIBGL_DRIVERS_PATH to /usr/lib/dri in"
		elog "Solution > Projects > Options > Run > General in MonoDevelop or in or your wrapper script before running your MonoGame app."
		einfo
		einfo "Say no to File Conflict when creating a new MonoGame Solution for both Tao.Sdl.dll.config and OpenTK.dll.config files."
		einfo
	fi
}

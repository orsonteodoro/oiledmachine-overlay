EAPI=5
inherit eutils autotools mono git-r3

DESCRIPTION="MonoGame"
HOMEPAGE="http://www.monogame.net"
LICENSE="Ms-PL gamepad-config? ( MONOGAME-GamepadConfig )"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="
	media-libs/openal
	>=dev-lang/mono-4.0.0[-nunit]
	>=dev-dotnet/gtk-sharp-2.99.9999
	>=dev-util/monodevelop-5.9.5.9[-nunit]
	>=dev-dotnet/mono-addins-1.0
	dev-dotnet/opentk
	>=dev-dotnet/nant-0.93_pre20151114
	>=dev-dotnet/lidgren-network-gen3-2015.12.18
	media-libs/assimp
	media-gfx/nvidia-texture-tools[csharp]
	dev-dotnet/managed-pvrtc
	virtual/ffmpeg
	dev-dotnet/ndesk-options
	>=dev-dotnet/nunit-3.0.1
	dev-dotnet/tao-framework
	media-libs/libsdl2
	media-libs/freealut
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
"
IUSE="debug bindist gamepad-config mgcb 2mgfx pipeline mp3compression"
SRC_URI=""

S="${WORKDIR}/monogame-${PV}"

RESTRICT="nofetch"

DOTNETTARGET="4.0"

pkg_setup() {
	if [[ ! -f "/usr/$(get_libdir)/mono/nvidia-texture-tools/Nvidia.TextureTools.dll" ]]; then
		die "You can only use the nvidia-texture-tools from the oiledmachine-overlay."
	fi
}
src_unpack() {
        EGIT_REPO_URI="https://github.com/mono/MonoGame.git"
        EGIT_BRANCH="master"
        #EGIT_COMMIT=""
        git-r3_fetch
        git-r3_checkout

	#unpack "${A}"
	cp /usr/$(get_libdir)/mono/gac/OpenTK/*/OpenTK.dll.config ${S}/ThirdParty/Dependencies/
}
src_prepare() {
	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

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
	epatch "${FILESDIR}"/monogame-3.4-graphicsutilcs1.patch
	epatch "${FILESDIR}"/monogame-3.4-graphicsutilcs2.patch
	epatch "${FILESDIR}"/monogame-3.4-sharpfontimportercs.patch
	epatch "${FILESDIR}"/monogame-3.4-linux-absolute-path.patch


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

#//
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='NDesk.Options']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/NDesk.Options/*/NDesk.Options.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core']/@Path" -v "$(ls /usr/$(get_libdir)/monodevelop/AddIns/NUnit/addins/nunit.core.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core.interfaces']/@Path" -v "$(ls /usr/$(get_libdir)/monodevelop/AddIns/NUnit/addins/nunit.core.interfaces.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.framework']/@Path" -v "$(ls /usr/$(get_libdir)/mono/2.0/nunit.framework.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition
	#xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.util']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/nunit.util/*/nunit.util.dll | tail -n 1)" "${S}"/Build/Projects/MonoGame.Tests.References.definition

	sed -i -e "s|\[Ignore\(\)\]|[Ignore(\"\")]|g" "${S}/Test/Framework/GameTest+Properties.cs"
	sed -i -e "s|\Ignore]|Ignore(\"\")]|g" "./Test/Framework/Visual/MiscellaneousTests.cs"
	sed -i -e "s|\Ignore]|Ignore(\"\")]|g" "./Test/Framework/GameTest+Methods.cs"
	sed -i -e "s|\Ignore]|Ignore(\"\")]|g" "./Test/Framework/GameTest.cs"

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit-v2-result-writer" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/$(get_libdir)/monodevelop/AddIns/NUnit/addins/nunit-v2-result-writer.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit.engine" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/$(get_libdir)/mono/2.0/nunit.engine.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit.engine.api" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/$(get_libdir)/mono/2.0/nunit.engine.api.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunit.framework.tests" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/$(get_libdir)/mono/2.0/nunit.framework.tests.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary" "${S}"/Build/Projects/MonoGame.Tests.References.definition \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Name" -v "nunitlite" \
	  | xml ed -i "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n "Path" -v "$(ls /usr/$(get_libdir)/mono/2.0/nunitlite.dll | tail -n 1)" > "${S}"/Build/Projects/MonoGame.Tests.References.definition.t
	cp "${S}"/Build/Projects/MonoGame.Tests.References.definition.t "${S}"/Build/Projects/MonoGame.Tests.References.definition

	sed -i -e "s|using NUnit.Framework;|using NUnit.Core;using NUnit.Framework;|g" "${S}"/Test/Runner/Extensions.cs
	sed -i -e "s|TestDelegate|NUnit.Framework.TestDelegate|g" "${S}"/Test/Framework/GameTest.cs

	xml ed -L -d "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core']"  "${S}"/Build/Projects/MonoGame.Tests.References.definition
	xml ed -L -d "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.core.interfaces']"  "${S}"/Build/Projects/MonoGame.Tests.References.definition
	xml ed -L -d "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='nunit.util']"  "${S}"/Build/Projects/MonoGame.Tests.References.definition

	sed -i -e "s|using NUnit.Core;||g" -e "s|using NUnit.Util;||g" "${S}"/Test/Runner/Interface/CommandLineInterface.cs
	sed -i -e "s|using NUnit.Core;||g" -e "s|using NUnit.Util;||g" "${S}"/Test/Runner/Extensions.cs
	sed -i -e "s|using NUnit.Core;||g" -e "s|using NUnit.Util;||g" "${S}"/Test/Runner/Interface/AggregateTestFilter.cs
	sed -i -e "s|using NUnit.Core;||g" -e "s|using NUnit.Util;||g" "${S}"/Test/Runner/Interface/RunOptions.cs
	sed -i -e "s|using NUnit.Core;||g" -e "s|using NUnit.Util;||g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs
	sed -i -e "s|using NUnit.Core;||g" -e "s|using NUnit.Util;||g" "${S}"/Test/Runner/Interface/RegexTestFilter.cs
	sed -i -e "s|using System;|using System;using NUnit.Framework.Interfaces;|g" "${S}"/Test/Runner/Interface/CommandLineInterface.cs
	sed -i -e "s|using System;|using System;using NUnit.Framework.Interfaces;|g" "${S}"/Test/Runner/Interface/AggregateTestFilter.cs
	sed -i -e "s|using System;|using System;using NUnit.Framework.Interfaces;|g" "${S}"/Test/Runner/Interface/RegexTestFilter.cs
	sed -i -e "s|using System;|using System;using NUnit.Framework.Interfaces;|g" "${S}"/Test/Runner/Interface/RunOptions.cs
	sed -i -e "s|using System;|using System;using NUnit.Framework.Internal;using NUnit.Engine;using NUnit.Framework.Interfaces;|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs
	sed -i -e "s|using System;|using System;using NUnit.Framework.Internal;|g" "${S}"/Test/Runner/Interface/CommandLineInterface.cs

	sed -i -e "s|\: EventListener {|: ITestListener {|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs
	sed -i -e "s|TestResult|ITestResult|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs
	sed -i -e "s|TestName|ITest|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs
	sed -i -e "s|TestOutput (TestOutput testOutput)|TestOutput (string testOutput)|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs #placeholder
	sed -i -e "s|string name, int testCount|ITest test|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs
	sed -i -e "s|\"Run Started: {0}\", name)|\"Run Started: {0}\", test.Name)|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs
	sed -i -e "s|RunFinished (ITestResult result)|RunFinished (TestResult result)|g" "${S}"/Test/Runner/Interface/TestEventListenerBase.cs

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


	epatch "${FILESDIR}"/monogame-3.4-nunitfixes.patch
	epatch "${FILESDIR}"/monogame-3.4-nunitfix2.patch
	epatch "${FILESDIR}"/monogame-3.4-nunitfix3.patch

	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gtk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gtk-sharp/*/gtk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='atk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/atk-sharp/*/atk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gdk-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gdk-sharp/*/gdk-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	#xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glade-sharp']/@Path" -v "$(ls | tail -n 1)" "${S}"/Build//Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glib-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/glib-sharp/*/glib-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='gtk-dotnet']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gtk-dotnet/*/gtk-dotnet.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='pango-sharp']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/pango-sharp/*/pango-sharp.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -d "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='glade-sharp']" "${S}"/Build/Projects/PipelineReferences.definition
	xml ed -L -u "/ExternalProject/Platform[@Type='Linux']/Binary[@Name='Mono.Posix']/@Path" -v "$(ls /usr/$(get_libdir)/mono/gac/Mono.Posix/*/Mono.Posix.dll | tail -n 1)" "${S}"/Build/Projects/PipelineReferences.definition

	xml ed -s "/ExternalProject/Platform[@Type='Linux']" -t elem -n "Binary"  "${S}/Build/Projects/PipelineReferences.definition" \
	  | xml ed -a "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n  "Name" -v "gio-sharp" \
          | xml ed -a "/ExternalProject/Platform[@Type='Linux']/Binary[last()]" -t attr -n  "Path" -v "$(ls /usr/$(get_libdir)/mono/gac/gio-sharp/*/gio-sharp.dll | tail -n 1)" > "${S}"/Build/Projects/PipelineReferences.definition.t
	cp "${S}"/Build/Projects/PipelineReferences.definition.t "${S}"/Build/Projects/PipelineReferences.definition

	mkdir -p "${S}"/ThirdParty/Dependencies/Gtk3
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "atk-sharp.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libatk-1.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/atk-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "gdk-sharp.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libgdk-3.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/gdk-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "glib-sharp.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libglib-2.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/glib-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "gtk-sharp.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libgtk-3.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/gtk-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "pango-sharp.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libpango-1.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/pango-sharp.dll.config
	echo "<configuration/>" | xml ed -s "/configuration" -t elem -n "dllmap"  \
	  | xml ed -a "/configuration/dllmap"  -t attr -n "os" -v "linux" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "dll" -v "gio-sharp.dll" \
          | xml ed -a "/configuration/dllmap"  -t attr -n "target" -v "/usr/$(get_libdir)/libgio-2.0.so" \
          > "${S}"/ThirdParty/Dependencies/Gtk3/gio-sharp.dll.config

	xml ed -L -u "/Addin/@version" -v "${PV}" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	epatch "${FILESDIR}"/monogame-3.4-addin5-compat.patch
	xml ed -L -d "//Dependencies" "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/MonoDevelop.MonoGame.addin.xml

	mkdir -p "ThirdParty/Dependencies/Gtk3"
}
src_configure(){
	true
}
src_compile() {
	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	einfo "Building dlls and tools"
	nant -t:mono-4.5 build_linux || die

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
	sn -k "${PN}-keypair.snk"
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

	cp "${S}/IDE/MonoDevelop/bin/${mydebug}/MonoDevelop.MonoGame.addin.xml" "${S}/IDE/MonoDevelop/bin/${mydebug}/MonoDevelop.MonoGame.MonoDevelop.MonoGame.addin.xml"

	#primary dlls

	mkdir -p "${D}"/usr/lib/mono/4.0/
	cp "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll" "${D}/usr/lib/mono/${DOTNETTARGET}"/
	cp "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Content.Pipeline.dll" "${D}/usr/lib/mono/${DOTNETTARGET}"/
	cp "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Net.dll" "${D}/usr/lib/mono/${DOTNETTARGET}"/
	cp "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll" "${D}/usr/lib/mono/${DOTNETTARGET}"/

        #strong_sign "${S}/${PN}-keypair.snk" "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll"
        #gacutil -i "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll" -root "${D}/usr/$(get_libdir)" \
        #        -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"

        #strong_sign "${S}/${PN}-keypair.snk" "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Content.Pipeline.dll"
        #gacutil -i "${S}/MonoGame.Framework.Content.Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Content.Pipeline.dll" -root "${D}/usr/$(get_libdir)" \
        #        -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"

        #strong_sign "${S}/${PN}-keypair.snk" "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Net.dll"
        #gacutil -i "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Net.dll" -root "${D}/usr/$(get_libdir)" \
        #        -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"

        #strong_sign "${S}/${PN}-keypair.snk" "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll"
        #gacutil -i "${S}/MonoGame.Framework/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.dll" -root "${D}/usr/$(get_libdir)" \
        #        -gacdir "/usr/$(get_libdir)" -package "${PN}" || die "failed"

	eend

        dodoc -r Documentation/*

	#addins
	mkdir -p "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/
	cp -r "${S}/IDE/MonoDevelop/bin/${mydebug}"/*  "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/

	#missing addin stuff
	cp -r "${S}"/IDE/MonoDevelop/MonoDevelop.MonoGame/icons "${D}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/
	

	if use gamepad-config; then
		mkdir -p "${D}/usr/$(get_libdir)/${PN}-${PV}/GamepadConfig"
		cp "${S}"/ThirdParty/GamepadConfig/Gamepad*.dll "${D}/usr/$(get_libdir)/${PN}-${PV}/GamepadConfig"/
		cp "${S}"/ThirdParty/GamepadConfig/*.xml "${D}/usr/$(get_libdir)/${PN}-${PV}/GamepadConfig"/
	fi

	if use mgcb; then
		mkdir -p "${D}/usr/$(get_libdir)/${PN}-${PV}/MGCB"
		cd "${S}"/Tools/MGCB
		cp "${S}/Tools/MGCB/bin/Linux/AnyCPU/${mydebug}/MGCB.exe" "${D}/usr/$(get_libdir)/${PN}-${PV}/MGCB"/
		cp "${S}/Tools/MGCB/bin/Linux/AnyCPU/${mydebug}"/*.dll "${D}/usr/$(get_libdir)/${PN}-${PV}/MGCB"/
		cp "${S}/ProjectTemplates/VisualStudio2010/Linux/Content/Content.mgcb" "${D}/usr/$(get_libdir)/${PN}-${PV}/MGCB/Content.Linux.mgcb"
		cp "${S}/ProjectTemplates/VisualStudio2010/Linux/Content/Content.mgcb" "${D}/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame/templates/Common/Content.Linux.mgcb"
	fi

	if use 2mgfx; then
		cd "${S}"/Tools/2MGFX
		true
	fi
	if use pipeline; then
		mkdir -p "${D}/usr/$(get_libdir)/${PN}-${PV}/Pipeline"
		cd "${S}"/Tools/Pipeline
		cp "${S}"/Tools/Pipeline/bin/Linux/AnyCPU/${mydebug}/*.exe "${D}/usr/$(get_libdir)/${PN}-${PV}/Pipeline"/
		cp "${S}"/Tools/Pipeline/bin/Linux/AnyCPU/${mydebug}/MonoGame.Framework.Content.Pipeline.dll "${D}/usr/$(get_libdir)/${PN}-${PV}/Pipeline"/
	fi

	if use mp3compression; then
		mkdir -p "${D}/usr/$(get_libdir)/${PN}-${PV}/mp3compression"
		cp "${S}"/Tools/MP3Compression/*.dll "${D}/usr/$(get_libdir)/${PN}-${PV}/mp3compression"/
		mkdir -p "${D}/usr/$(get_libdir)/${PN}-${PV}/mp3compression/yeti.mp3"
		cp "${S}"/Tools/MP3Compression/yeti.mp3/*.dll "${D}/usr/$(get_libdir)/${PN}-${PV}/mp3compression/yeti.mp3"/
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


        #mono_multilib_comply
}
pkg_postinst() {
	#update addins
	mautil -reg "${ROOT}"/usr/$(get_libdir)/mono/gac -p "${ROOT}"/usr/$(get_libdir)/monodevelop/AddIns/MonoDevelop.MonoGame reg-build -v
	elog "You need to set your project's LIBGL_DRIVERS_PATH to your video card driver /usr/lib/opengl/{ati,xorg-x11,intel,nvidia}/lib in"
	elog "Solution > Projects > Options > Run > General in MonoDevelop or in or your wrapper script before running your MonoGame app."
	einfo
	einfo "Say no to File Conflict when creating a new MonoGame Solution for both Tao.Sdl.dll.config and OpenTK.dll.config files."
	einfo
}

function strong_sign() {
	pushd "$(dirname ${2})"
	ikdasm "${2}" > "${2}.il" || die "monodis failed"
	mv "${2}" "${2}.orig"
	grep -r -e "permissionset" "${2}.il" #permissionset not supported
	if [[ "$?" == "0" ]]; then
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|.permissionset.*\n.*\}\}||g' "${2}.il"
	fi
	grep -e "\[opt\] bool public" "${2}.il" #broken mangling
	if [[ "$?" == "0" ]]; then
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|\[opt\] bool public|[opt] bool \'public\'|g" "${2}.il"
	fi

	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" #|| die "ilasm failed"
	#rm "${2}.orig"
	#rm "${2}.il"
	popd
}

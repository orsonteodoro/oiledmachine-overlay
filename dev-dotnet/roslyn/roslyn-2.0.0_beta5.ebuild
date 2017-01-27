# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#instructions: https://libraries.io/github/mono/roslyn

EAPI=6
inherit dotnet eutils mono gac nupkg

DESCRIPTION="The .NET Compiler Platform ('Roslyn') provides open-source C# and Visual Basic compilers with rich code analysis APIs."
HOMEPAGE=""
PROJECT_NAME="roslyn"

#this is required because RoslynRestore is built against it

SDK_PREVIEW_VERSION="2"
SDK_VERSION="1.0.0"
SDK_PR="preview"
P_BUILD="002911"
CORE_VERSION="1.0.1"
TOOLSET_VERSION="8"

DOTNET_PLATFORM="ubuntu-x64"
DOTNET_VERSION="${SDK_VERSION}-${SDK_PR}${SDK_PREVIEW_VERSION}-${P_BUILD}"
SRC_URI="https://github.com/dotnet/roslyn/archive/version-${PV//_/-}.tar.gz -> ${P}.tar.gz
         https://dotnetci.blob.core.windows.net/roslyn/roslyn.linux.${TOOLSET_VERSION}.zip
         https://dotnetcli.blob.core.windows.net/dotnet/preview/Binaries/${DOTNET_VERSION}/dotnet-dev-${DOTNET_PLATFORM}.${DOTNET_VERSION}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac bootstrap"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac nupkg"

RDEPEND=">=dev-lang/mono-4
         >=dev-dotnet/newtonsoft-json-8.0.3
         dev-dotnet/dotnet-cli
         >=dev-dotnet/referenceassemblies-pcl-4.5"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
        dev-dotnet/nuget
"

S="${WORKDIR}/${PROJECT_NAME}-version-${PV//_/-}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

pkg_setup() {
	if [[ "${FEATURES}" =~ "usersandbox" ]] ; then
		die "You need to add FEATURES=\"-usersandbox\" to your per-package package.env for the dotnet command to work properly.  See https://wiki.gentoo.org/wiki//etc/portage/package.env ."
	else
		true
	fi
	if [[ "${FEATURES}" =~ "userpriv" ]] ; then
		true
	else
		die "You need to add FEATURES=\"userpriv\" to your per-package package.env for the dotnet command to work properly.  See https://wiki.gentoo.org/wiki//etc/portage/package.env ."
	fi

	dotnet_pkg_setup
}

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}" || die
	mkdir -p Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}
	cd "${S}/Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}"
	unzip "${DISTDIR}"/roslyn.linux.${TOOLSET_VERSION}.zip
	chmod +x RoslynRestore
	chmod +x corerun
	chmod +x csc
	chmod +x vbc

	mkdir -p "${S}/Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/dotnet-cli"
	cd "${S}/Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/dotnet-cli"
	tar -xvf "${DISTDIR}"/dotnet-dev-${DOTNET_PLATFORM}.${DOTNET_VERSION}.tar.gz

#	cp -a /usr/lib/mono/xbuild-frameworks/.* "${S}/Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/reference-assemblies/Framework"
}

src_prepare() {
	mydebug="Release"
	if use debug ; then
		mydebug="Debug"
	fi

	egenkey
	##3.x may be required for roslyn
	#wget https://github.com/NuGet/Home/releases/download/3.3/NuGet.exe

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug ; then
		mydebug="Debug"
	fi

        #export ReferenceAssemblyRoot="${S}/usr/lib/mono/xbuild-frameworks/" #doesn't have v5.0
        export ReferenceAssemblyRoot="${S}/Binaries/toolset/roslyn.linux.8/reference-assemblies/Framework/" #does have v5.0
	export LD_LIBRARY_PATH="/opt/dotnet_cli/shared/Microsoft.NETCore.App/${CORE_VERSION}:${LD_LIBRARY_PATH}"

	#the two restores should be done in the previous phases but emerge clears the homedir

	einfo "Restoring toolset packages..."

	/opt/dotnet_cli/dotnet restore build/ToolsetPackages/project.json --disable-parallel -v Debug

	einfo "Restoring CrossPlatform.sln..."

	#required because the csharp binary was compiled to detect path relative to NuGet.exe
	cp -a /usr/$(get_libdir)/mono/NuGet/${EBF}/NuGet.exe ./

	lock=$(mktemp)
	einfo "Restoring may take a while..."
	(while true
	do
		CPU=$(ps -C "dotnet" -o pcpu --sort -pcpu | head -n 2 | tail -n 1)
		echo -ne "  % CPU activity for restoring CrossPlatform.sln: $CPU\r"
		sleep 1
		if [ ! -f $lock ]; then
			break
		fi
	done) &

	Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/RoslynRestore "${S}/CrossPlatform.sln" "${S}/NuGet.exe" /opt/dotnet_cli/dotnet
	unlink $lock

	if use bootstrap ; then
		einfo "make bootstrap..."
	        Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/corerun Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/MSBuild.exe \
			src/Compilers/CSharp/CscCore/CscCore.csproj \
			/v:m /fl /fileloggerparameters:Verbosity=normal /p:Configuration=${mydebug} \
			/p:BaseNuGetRuntimeIdentifier=ubuntu.14.04 \
			/p:CscToolPath="${S}/Binaries/Bootstrap" /p:CscToolExe=csc /p:VbcToolPath="${S}/Binaries/Bootstrap" /p:VbcToolExe=vbc \
			&& \
	        Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/corerun Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/MSBuild.exe \
			src/Compilers/VisualBasic/VbcCore/VbcCore.csproj \
			/v:m /fl /fileloggerparameters:Verbosity=normal /p:Configuration=${mydebug} \
			/p:BaseNuGetRuntimeIdentifier=ubuntu.14.04 \
			/p:CscToolPath="${S}/Binaries/Bootstrap" /p:CscToolExe=csc /p:VbcToolPath="${S}/Binaries/Bootstrap" /p:VbcToolExe=vbc \
			&& \
	        mkdir -p "${S}/Binaries/Bootstrap" && \
	        cp -f Binaries/${mydebug}/Exes/CscCore/* "${S}/Binaries/Bootstrap" && \
	        cp -f Binaries/${mydebug}/Exes/VbcCore/* "${S}/Binaries/Bootstrap" && \
        	build/scripts/crossgen.sh "${S}/Binaries/Bootstrap" && \
	        rm -rf Binaries/${mydebug}
	fi

	einfo "make all..."
        Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/corerun Binaries/toolset/roslyn.linux.${TOOLSET_VERSION}/MSBuild.exe \
		CrossPlatform.sln \
		/v:m /fl /fileloggerparameters:Verbosity=normal /p:Configuration=${mydebug} \
		/p:BaseNuGetRuntimeIdentifier=ubuntu.14.04 \
		/p:CscToolExe=csc /p:VbcToolExe=vbc
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

       	insinto "/usr/$(get_libdir)/mono/${PN}"

	doins $(find Binaries/${mydebug} -name "*.dll")
	doins $(find Binaries/${mydebug} -name "*.exe")

	dotnet_multilib_comply
}

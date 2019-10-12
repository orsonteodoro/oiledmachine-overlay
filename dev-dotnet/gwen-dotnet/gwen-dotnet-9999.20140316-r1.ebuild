# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="GWEN.Net is a .Net port of GWEN, and is a lightweight GUI library aimed at games."
HOMEPAGE="https://code.google.com/archive/p/gwen-dotnet/"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="GwenNet"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
RDEPEND="dev-dotnet/opentk
         dev-dotnet/sfmldotnet
         dev-dotnet/tao-framework"
DEPEND="${RDEPEND}"
inherit dotnet eutils
SRC_URI="https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/gwen-dotnet/source-archive.zip -> ${P}.zip"
inherit gac
S="${WORKDIR}/gwen-dotnet/trunk/GwenCS"
RESTRICT="mirror"

src_prepare() {
	default
	FILES=$(grep -l -r -e "xcopy" ./)
	for f in $FILES
	do
		echo "Patching $f..."
		sed -i -r -e 's|xcopy "\$\(TargetPath\)" "\$\(SolutionDir\)\\Binaries\\" \/Y \/Q|cp -a "\$(TargetPath)" "$(SolutionDir)/Binaries/"|g' "$f"
		sed -i -r -e 's|xcopy \/E \/C \/Y "\$\(SolutionDir\)media\\\*\.\*" "\$\(TargetDir\)"|cp -a "$(SolutionDir)media"/* "$(TargetDir)"|g' "$f"
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

	sed -i -e 's|<TargetFrameworkProfile>Client</TargetFrameworkProfile>||g' Gwen.Renderer.OpenTK/Gwen.Renderer.OpenTK.csproj
}

src_compile() {
        exbuild STRONG_ARGS_NETFX"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln || die
}

src_install() {
	mydebug=$(usex debug "Debug" "Release")

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
		FW_UPPER=${x:3:1}
		FW_LOWER=${x:4:1}
		egacinstall "${S}/Binaries/Gwen.dll"
		egacinstall "${S}/Binaries/Gwen.Renderer.OpenTK.dll"
		egacinstall "${S}/Binaries/Gwen.Renderer.SFML.dll"
		egacinstall "${S}/Binaries/Gwen.Renderer.Tao.dll"
        done

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/${mydebug}/Gwen.dll.mdb
		doins Gwen.Renderer.Tao/bin/${mydebug}/Gwen.Renderer.Tao.dll.mdb
		doins Gwen.Renderer.OpenTK/bin/${mydebug}/Gwen.Renderer.OpenTK.dll.mdb
		doins Gwen.Renderer.SFML/bin/${mydebug}/Gwen.Renderer.SFML.dll.mdb
	fi

	eend

	dotnet_multilib_comply
}

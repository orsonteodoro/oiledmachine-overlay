# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils gac

DESCRIPTION="GWEN.Net is a GUI library for games"
HOMEPAGE=""
PROJECT_NAME="GwenNet"
COMMIT="f491e6563e30dc45f28e5586f02b89bbd8188086"
GIT_USER="Robmaister"
SRC_URI="https://github.com/Robmaister/gwen-dotnet/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
SNK_FILENAME="${S}/${PN}-keypair.snk"

RDEPEND=">=dev-lang/mono-4
         dev-dotnet/opentk
         dev-dotnet/sfmldotnet
         dev-dotnet/tao-framework
         "
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PN}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
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

	sed -i -e 's|<TargetFrameworkProfile>Client</TargetFrameworkProfile>||g' GwenCS/Gwen.Renderer.OpenTK/Gwen.Renderer.OpenTK.csproj

	egenkey

	eapply_user
}

src_compile() {
	cd "${S}/GwenCS"

        einfo "Building solution"
        exbuild_strong  ${PROJECT_NAME}.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/GwenCS/Binaries/Gwen.dll"
                egacinstall "${S}/GwenCS/Binaries/Gwen.Renderer.OpenTK.dll"
                egacinstall "${S}/GwenCS/Binaries/Gwen.Renderer.SFML.dll"
                egacinstall "${S}/GwenCS/Binaries/Gwen.Renderer.Tao.dll"
        done

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins GwenCS/Gwen/bin/Release/Gwen.dll.mdb
		doins GwenCS/Gwen.Renderer.Tao/bin/Release/Gwen.Renderer.Tao.dll.mdb
		doins GwenCS/Gwen.Renderer.OpenTK/bin/Release/Gwen.Renderer.OpenTK.dll.mdb
		doins GwenCS/Gwen.Renderer.SFML/bin/Release/Gwen.Renderer.SFML.dll.mdb
	fi

	eend

	dotnet_multilib_comply
}

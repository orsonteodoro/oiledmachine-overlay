# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="NRefactory - Refactoring Your C# Code"
HOMEPAGE=""
PROJECT_NAME="NRefactory"
COMMIT="cbb7fdc0dbf451cfbedde41238f2cd49ac7b1e06"
SRC_URI="https://github.com/icsharpcode/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         media-libs/openal
         dev-dotnet/nunit:2
         dev-dotnet/cecil
	 !dev-dotnet/icsharpcode-nrefactory-bin"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/icsharpcode-nrefactory-9999.20161126-refs.patch"
	eapply "${FILESDIR}/icsharpcode-nrefactory-9999.20161126-disable-ikvm.patch"
	eapply "${FILESDIR}/icsharpcode-nrefactory-9999.20161126-disable-cecil-and-ikvm-reflection.patch"

	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}"

	einfo "Building solution"
	exbuild /p:Configuration=${mydebug} "${PROJECT_NAME}.sln" || die
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
		egacinstall "${S}/bin/Release/ICSharpCode.NRefactory.CSharp.dll"
		egacinstall "${S}/bin/Release/ICSharpCode.NRefactory.Cecil.dll"
		egacinstall "${S}/bin/Release/ICSharpCode.NRefactory.Xml.dll"
		egacinstall "${S}/bin/Release/ICSharpCode.NRefactory.CSharp.Refactoring.dll"
		egacinstall "${S}/bin/Release/ICSharpCode.NRefactory.dll"
        done

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "${S}/bin/Release/ICSharpCode.NRefactory.CSharp.dll.mdb"
		doins "${S}/bin/Release/ICSharpCode.NRefactory.Cecil.dll.mdb"
		doins "${S}/bin/Release/ICSharpCode.NRefactory.Xml"{.dll.mdb,.xml}
		doins "${S}/bin/Release/ICSharpCode.NRefactory.CSharp.Refactoring"{.dll.mdb,.xml}
		doins "${S}/bin/Release/ICSharpCode.NRefactory.dll.mdb"
		doins "ICSharpCode.NRefactory.snk"
	fi

	eend

	dotnet_multilib_comply
}

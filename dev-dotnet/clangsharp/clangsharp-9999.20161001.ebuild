# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="Clang bindings for .NET and Mono written in C#"
HOMEPAGE=""
PROJECT_NAME="ClangSharp"
COMMIT="9b5f81a1ac7f0348f8ff82d041d57c3bf36bbe65"
SRC_URI="https://github.com/Microsoft/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="UIUC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         media-gfx/mojoshader"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	cd "${S}"

        einfo "Building solution"
        exbuild_strong ${PROJECT_NAME}.sln || die
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
                egacinstall "${S}/bin/${mydebug}/${PROJECT_NAME}.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins "${S}/bin/${mydebug}/ClangSharp.dll.mdb"
        done

	eend

       	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins ClangSharpPInvokeGenerator/bin/Release/ClangSharpPInvokeGenerator.exe

	dotnet_multilib_comply
}

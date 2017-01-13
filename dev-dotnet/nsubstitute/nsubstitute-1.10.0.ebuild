# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="NSubstitute is a friendly substitute for .NET mocking frameworks."
HOMEPAGE=""
PROJECT_NAME="NSubstitute"
SRC_URI="https://github.com/nsubstitute/${PROJECT_NAME}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         >=dev-dotnet/castle-core-3.3.2"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	dev-util/nunit:2
"

S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	sed -i -r -e "s|CannotReturnNullForValueType.cs|CannotReturnNullforValueType.cs|g" Source/NSubstitute/NSubstitute.csproj

	sed -i -r -e "s|<TreatWarningsAsErrors>true</TreatWarningsAsErrors>|<TreatWarningsAsErrors>false</TreatWarningsAsErrors>|g" Source/NSubstitute.Acceptance.Specs/NSubstitute.Acceptance.Specs.csproj

	egenkey

	eapply_user
}

src_compile() {
	mydebug="NET45-Release"
	if use debug; then
		mydebug="NET45-Debug"
	fi
	cd "${S}/Source"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} NSubstitute.2010.sln || die
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
                egacinstall "${S}/Output/Release/NET${EBF//./}/NSubstitute/NSubstitute.dll"
        done

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "${S}/Output/Release/NET${EBF//./}/NSubstitute/NSubstitute.XML"
		doins "${S}/Output/Release/NET${EBF//./}/NSubstitute/NSubstitute.dll.mdb"
	fi

	eend


	dotnet_multilib_comply
}

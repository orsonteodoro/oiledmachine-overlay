# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="Cross platform GUI framework for desktop and mobile applications in .NET"
HOMEPAGE=""
COMMIT="d7a6d4bbdb5ac1263d3036d9177cadcfb2f0e63e"
SRC_URI="https://github.com/picoe/Eto/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac developer gtk-sharp3 gtk-sharp2"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac || ( gtk-sharp3 gtk-sharp2 )"

RDEPEND=">=dev-lang/mono-4
	 >=dev-util/monodevelop-5
	 gtk-sharp3? ( dev-dotnet/gtk-sharp:3 )
	 gtk-sharp2? ( dev-dotnet/gtk-sharp:2 )
         net45? ( dev-dotnet/referenceassemblies-pcl )
        "
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"
MY_PN="Eto"

S="${WORKDIR}/${MY_PN}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	epatch "${FILESDIR}/${PN}-9999.20171218-remove-projects.patch"
	epatch "${FILESDIR}/${PN}-9999.20171218-posx.patch"
	epatch "${FILESDIR}/${PN}-9999.20171218-prevnextsel.patch"
	epatch "${FILESDIR}/${PN}-9999.20171218-suppress-warnings.patch"
	epatch "${FILESDIR}/${PN}-9999.20171218-csharp6-compat.patch"
	epatch "${FILESDIR}/${PN}-9999.20171218-context.patch"
	epatch "${FILESDIR}/${PN}-9999.20171218-targets.patch"

	PCL_OLD_VERSION="259"
	PCL_NEW_VERSION="78"
	sed -i -r -e "s|Profile${PCL_OLD_VERSION}|Profile${PCL_NEW_VERSION}|g" "${S}/Source/Eto/Eto - pcl.csproj" || die
	sed -i -r -e "s|Profile${PCL_OLD_VERSION}|Profile${PCL_NEW_VERSION}|g" "${S}/Source/Eto.Serialization.Json/Eto.Serialization.Json - pcl.csproj" || die
	sed -i -r -e "s|Profile${PCL_OLD_VERSION}|Profile${PCL_NEW_VERSION}|g" "${S}/Source/Eto.Serialization.Xaml/Eto.Serialization.Xaml - pcl.csproj" || die
	sed -i -r -e "s|Profile${PCL_OLD_VERSION}|Profile${PCL_NEW_VERSION}|g" "${S}/Source/Eto.Test/Eto.Test/Eto.Test - pcl.csproj" || die

	egenkey

	eapply_user
}

src_configure() {
	default
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/Source"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} 'Eto - net45.sln' || die
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
                egacinstall "${S}/BuildOutput/${x}/${mydebug}/Eto.dll"
		if use gtk-sharp3 ; then
	                egacinstall "${S}/BuildOutput/${x}/${mydebug}/Eto.Gtk3.dll"
		fi
		if use gtk-sharp2 ; then
	                egacinstall "${S}/BuildOutput/${x}/${mydebug}/Eto.Gtk2.dll"
		fi
                egacinstall "${S}/BuildOutput/${x}/${mydebug}/Eto.Serialization.Json.dll"
        done

	eend

	dotnet_multilib_comply
}


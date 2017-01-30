# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="CsQuery is a jQuery port for .NET 4. It implements all CSS2 & CSS3 selectors, all the DOM manipulation methods of jQuery, and some of the utility methods."
HOMEPAGE=""
PROJECT_NAME="CsQuery"
COMMIT_CSQ="5a22e28a39c139cbb8170a0eeeee59e73f9e02f9"
COMMIT_HPS="2a450f49bb908d50461eae95dd4f74b872b5094e"
DATE_HPS="20150714"
SRC_URI="https://github.com/jamietre/CsQuery/archive/${COMMIT_CSQ}.zip -> ${P}.zip
         https://github.com/jamietre/HtmlParserSharp/archive/${COMMIT_HPS}.zip -> HtmlParserSharp-${DATE_HPS}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug opentk +gac developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

RESTRICT=""

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT_CSQ}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_unpack()
{
	unpack ${A}
	mv "HtmlParserSharp-${COMMIT_HPS}" HtmlParserSharp
	mv "HtmlParserSharp" ${S}/source/CsQuery/
}

src_prepare() {
	egenkey

	sed -i -e "s|nuget.targets|NuGet.targets|g" source/CsQuery/CsQuery.csproj || die
	sed -i -e "s|enumCSSStyleType|enumCssStyleType|g" source/CsQuery/CsQuery.csproj || die
	sed -i -e "s|IHTMLOptionsCollection|IHtmlOptionsCollection|g" source/CsQuery/CsQuery.csproj || die
	sed -i -e "s|HTMLOptionsCollection|HtmlOptionsCollection|g" source/CsQuery/CsQuery.csproj || die

	epatch "${FILESDIR}/csquery-9999.20151215-ireadonly.patch"
	epatch "${FILESDIR}/csquery-9999.20151215-unix-script.patch"

	sed -i -e "s|nuget.targets|NuGet.targets|g" source/CsQuery.Tests/Csquery.Tests.csproj || die
	sed -i -e 's|jQuery\\Css.cs|jQuery\\css.cs|g' source/CsQuery.Tests/Csquery.Tests.csproj || die

	epatch "${FILESDIR}/csquery-9999.20151215-disable-test.patch"

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/source"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} ${PROJECT_NAME}.sln || die
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
                egacinstall "${S}/source/CsQuery/bin/${mydebug}/CsQuery.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		if use developer ; then
			doins "${S}/source/CsQuery/bin/${mydebug}/CsQuery.dll.mdb"
			doins "${S}/source/CsQuery/bin/${mydebug}/CsQuery.XML"
		fi
        done

	eend

	dotnet_multilib_comply
}

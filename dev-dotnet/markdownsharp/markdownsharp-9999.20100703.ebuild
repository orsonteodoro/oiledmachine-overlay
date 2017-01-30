# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="Open source C# implementation of Markdown processor, as featured on Stack Overflow."
HOMEPAGE=""
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/markdownsharp/markdownsharp-20100703-v113.7z"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
        "
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	dev-util/nunit:2
	dev-dotnet/log4net
"

RESTRICT=""

S="${WORKDIR}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	epatch "${FILESDIR}/${PN}-9999.20100703-refs.patch"
	epatch "${FILESDIR}/${PN}-9999.20100703-no-tests.patch"

	egenkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} MarkdownSharp.sln || die
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
                egacinstall "${S}/MarkdownSharp/bin/${mydebug}/MarkdownSharp.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		if use developer ; then
	                doins "${S}/MarkdownSharp/bin/${mydebug}/MarkdownSharp.dll.mdb"
		fi
        done

	eend

	dotnet_multilib_comply
}

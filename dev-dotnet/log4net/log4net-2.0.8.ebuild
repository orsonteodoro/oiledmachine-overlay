# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="The Apache log4net library is a tool to help the programmer output log statements to a variety of output targets."
HOMEPAGE=""
SRC_URI="http://www-eu.apache.org/dist//logging/log4net/source/log4net-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug opentk +gac developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         !dev-dotnet/log4net-bin"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
        dev-util/nunit:2
"

S="${WORKDIR}/${PN}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/log4net-2.0.7-nunit2.patch"

	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/src"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} log4net.vs2012.sln || die
}

src_install() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/build/bin/net/${EBF}/${mydebug}/log4net.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
                use developer && doins "${S}/build/bin/net/${EBF}/${mydebug}/log4net.dll.mdb"
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins log4net.snk
	fi

	dotnet_multilib_comply
}

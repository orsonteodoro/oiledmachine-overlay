# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="Castle Core, including Castle DynamicProxy, Logging Services and DictionaryAdapter."
HOMEPAGE=""
PROJECT_NAME="Core"
SRC_URI="https://github.com/castleproject/${PROJECT_NAME}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
         dev-dotnet/NLog
	>=dev-lang/mono-4
        dev-dotnet/log4net
        dev-util/nunit:2
"

S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	sed -i -r -e "s|<TreatWarningsAsErrors>true</TreatWarningsAsErrors>|<TreatWarningsAsErrors>false</TreatWarningsAsErrors>|g" src/Castle.Core/Castle.Core.csproj || die

	eapply "${FILESDIR}/castle-core-3.3.3-no-tests.patch"

	egenkey

	eapply_user
}

src_compile() {
	mydebug="NET45-Release"
	if use debug; then
		mydebug="NET45-Debug"
	fi
	pwd
	cd "${S}"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} Castle.Core.sln /p:RootPath="${S}" || die
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
                egacinstall "${S}/src/Castle.Core/bin/NET${EBF//./}-${mydebug}/Castle.Core.dll"

                egacinstall "${S}/src/Castle.Services.Logging.NLogIntegration/bin/NET${EBF//./}-${mydebug}/Castle.Services.Logging.NLogIntegration.dll"
                egacinstall "${S}/src/Castle.Services.Logging.log4netIntegration/bin/NET${EBF//./}-${mydebug}/Castle.Services.Logging.Log4netIntegration.dll"
                egacinstall "${S}/src/Castle.Services.Logging.SerilogIntegration/bin/NET${EBF//./}-${mydebug}/Castle.Services.Logging.SerilogIntegration.dll"


               	insinto "/usr/$(get_libdir)/mono/${PN}"
		if use developer ; then
			doins "${S}/src/Castle.Core/bin/NET${EBF//./}-${mydebug}/Castle.Core"{.xml,.dll.mdb}
			doins "${S}/src/Castle.Services.Logging.NLogIntegration/bin/NET${EBF//./}-${mydebug}/Castle.Services.Logging.NLogIntegration.dll.mdb"
			doins "${S}/src/Castle.Services.Logging.log4netIntegration/bin/NET${EBF//./}-${mydebug}/Castle.Services.Logging.Log4netIntegration.dll.mdb"
			doins "${S}/src/Castle.Services.Logging.SerilogIntegration/bin/NET${EBF//./}-${mydebug}/Castle.Services.Logging.SerilogIntegration.dll.mdb"
		fi
        done

	eend

	dotnet_multilib_comply
}


# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This package is like a meta/virtual package
# The https://github.com/dotnet/cli is the ".NET Core SDK" package on the GitHub
# release page not the https://github.com/dotnet/sdk

# Version details
# https://dotnet.microsoft.com/download/dotnet-core/2.1

EAPI=7
DESCRIPTION="Core functionality needed to create .NET Core projects, that is \
shared between Visual Studio and CLI"
HOMEPAGE="https://github.com/dotnet/sdk"
KEYWORDS="~amd64 ~arm"
IUSE="aspnetcore doc examples"
RESTRICT="fetch"
SLOT=$(ver_cut 1-2 ${PV})
# split due to flaky servers
CORE_V=2.1.18
RDEPEND="aspnetcore? ( =dev-dotnet/aspnetcore-${CORE_V}*:${CORE_V}[doc?] )
	 =dev-dotnet/core-${CORE_V}*:${CORE_V}[doc?,examples?]
	 =dev-dotnet/coreclr-${CORE_V}*:${CORE_V}[doc?]
	 =dev-dotnet/corefx-${CORE_V}*:${CORE_V}[doc?]
	 =dev-dotnet/cli-${PV}*:${PV}[doc?]"

pkg_postinst() {
	einfo "Core version is ${CORE_V}"
	einfo "Long Term Support (LTS) up to 2021-08-21"
}

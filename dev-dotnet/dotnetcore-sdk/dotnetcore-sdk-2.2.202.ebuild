# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CORE_V=2.2.3

# This package is like a virtual package
# The https://github.com/dotnet/cli is the ".NET Core SDK" package on the GitHub release page not the https://github.com/dotnet/sdk .
DESCRIPTION="Core functionality needed to create .NET Core projects, that is shared between Visual Studio and CLI"
HOMEPAGE="https://github.com/dotnet/sdk"
LICENSE="MIT"

IUSE=""

SRC_URI=""
RESTRICT="fetch"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"

RDEPEND2="=dev-dotnet/core-${CORE_V}
	 =dev-dotnet/coreclr-${CORE_V}
	 =dev-dotnet/corefx-${CORE_V}
	 =dev-dotnet/cli-tools-${PV}
	 =dev-dotnet/core-setup-${CORE_V}
	 =dev-dotnet/aspnetcore-${CORE_V}"

pkg_setup() {
	# split due to flaky servers
	ewarn "Still in development"
}

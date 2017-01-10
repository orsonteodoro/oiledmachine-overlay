# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PACKAGE_NAME="ICSharpCode.NRefactory"
DESCRIPTION="NRefactory supports analysis of C# source code"

PACKAGE_VERSION="${PV}"

USE_DOTNET="net45"
IUSE="${USE_DOTNET} +nupkg"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

inherit dotnet nupkg nuget
# nupkg inherits: dotnet eutils versionator mono-env

# without empty SRC_URI, ebuild digest commend will give the message "ebuild ... does not follow correct package syntax"
# this SRC_URI points to icon file
SRC_URI="http://go.microsoft.com/fwlink/?LinkID=288859 -> ${PACKAGE_NAME}.png"
# this is for overlay-based ebuilds, and should be reworked before moving into main tree
RESTRICT="mirror"

HOMEPAGE="https://www.nuget.org/packages/${PACKAGE_NAME}/"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

CDEPEND=">=dev-dotnet/cecil-0.9.5.4"
DEPEND="${CDEPEND}"
#RDEPEND="${CDEPEND}"

pkg_setup() {
	dotnet_pkg_setup

	#bypass sandbox
	enuget_download_rogue_binary "${PACKAGE_NAME}" "${PACKAGE_VERSION}"
}

src_prepare() {
	eapply_user
}

src_install() {
	enupkg "${WORKDIR}/${PACKAGE_NAME}.${PACKAGE_VERSION}.nupkg"

	dotnet_multilib_comply
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PACKAGE_NAME="Google.Api.CommonProtos"
DESCRIPTION="Google.Api.CommonProtos"

PACKAGE_VERSION="${PV//_/-}"

USE_DOTNET="net45"
IUSE="${USE_DOTNET} +nupkg"
REQUIRED_USE="|| ( ${USE_DOTNET} ) nupkg"

inherit dotnet nupkg nuget
# nupkg inherits: dotnet eutils versionator mono-env

# without empty SRC_URI, ebuild digest commend will give the message "ebuild ... does not follow correct package syntax"
# this SRC_URI points to icon file
SRC_URI=""
# this is for overlay-based ebuilds, and should be reworked before moving into main tree
RESTRICT="mirror"

HOMEPAGE="https://www.nuget.org/packages/${PACKAGE_NAME}/"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"

CDEPEND=">=dev-dotnet/google-protobuf-bin-3.0.0"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

src_unpack() {
	enuget_download_rogue_binary2 "${PACKAGE_NAME}" "${PACKAGE_VERSION}"
}

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/mono/${PN}"
	cp -r "${S}/lib"/* "${D}/usr/$(get_libdir)/mono/${PN}/"

	enupkg "${S}/${PACKAGE_NAME}.${PACKAGE_VERSION}.nupkg"

	dotnet_multilib_comply
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="API to access display driver functionality for ATI graphics cards"
HOMEPAGE="http://developer.amd.com/sdks/adlsdk/"
SRC_URI="http://download2-developer.amd.com/amd/GPU/zip/ADL_SDK_V${PV}.zip"

LICENSE="AMD-ADL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND=""
#RDEPEND="${DEPEND}
#	x11-drivers/ati-drivers
#"
DEPEND="${DEPEND}
	app-arch/unzip
"

RESTRICT="fetch"

S="${WORKDIR}"

src_install() {
	use doc && dodoc -r "Public-Documents"/* "adlutil/ADLUTIL User Guide.doc"
	use examples && dodoc -r "Sample" "Sample-Managed"

	insinto "/usr/include/ADL"
	doins include/*
}

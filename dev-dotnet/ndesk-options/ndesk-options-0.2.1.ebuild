# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit mono-env eutils mono gac

DESCRIPTION="NDesk.Options"
HOMEPAGE="http://www.ndesk.org/Options"
SRC_URI="http://www.ndesk.org/archive/ndesk-options/ndesk-options-0.2.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"


RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/ndesk-options-${PV}"

src_prepare() {
	genkey

	eapply_user
}

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	CSFLAGS="${CSFLAGS} -keyfile:\"${S}/${PN}-keypair.snk\"" \
	emake || die "emake failed"
}

src_install() {
        ebegin "Installing dlls into the GAC"

	savekey
	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/lib/ndesk-options/NDesk.Options.dll"
        done

	eend

	cd "${S}"
	dodoc AUTHORS ChangeLog README COPYING
	dodoc -r doc

        mono_multilib_comply
}

function genkey() {
        einfo "Generating Key Pair"
        cd "${S}"
        sn -k "${PN}-keypair.snk"
}

function savekey() {
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"
}


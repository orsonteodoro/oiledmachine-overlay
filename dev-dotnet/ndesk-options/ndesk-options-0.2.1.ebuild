# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools dotnet eutils mono gac

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
	egenkey

	sed -i -r -e "s|gmcs|mcs|g" configure.ac

	eapply_user

	eautoreconf
}

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	CSFLAGS="${CSFLAGS} -sdk:${EBF} -keyfile:\"${S}/${PN}-keypair.snk\"" \
	emake || die "emake failed"
}

src_install() {
        ebegin "Installing dlls into the GAC"

	esavekey
	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/lib/ndesk-options/NDesk.Options.dll"
        done

	eend

	cd "${S}"
	dodoc AUTHORS ChangeLog README COPYING
	dodoc -r doc

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins lib/ndesk-options/NDesk.Options.dll.mdb
	fi

        mono_multilib_comply
}

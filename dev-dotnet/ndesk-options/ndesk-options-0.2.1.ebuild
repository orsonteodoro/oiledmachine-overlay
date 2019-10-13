# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="NDesk.Options"
HOMEPAGE="http://www.ndesk.org/Options"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit autotools dotnet eutils mono
SRC_URI="http://www.ndesk.org/archive/ndesk-options/ndesk-options-0.2.1.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/ndesk-options-${PV}"

src_prepare() {
	default
	sed -i -r -e "s|gmcs|mcs|g" configure.ac || die
	eautoreconf
}

src_compile() {
	CSFLAGS="${CSFLAGS} -sdk:${EBF} -keyfile:\"${DISTDIR}/mono.snk\"" \
	emake || die "emake failed"
}

src_install() {
        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
		FW_UPPER=${x:3:1}
		FW_LOWER=${x:4:1}
		egacinstall "${S}/lib/ndesk-options/NDesk.Options.dll"
        done

	eend

	dodoc AUTHORS ChangeLog README COPYING
	dodoc -r doc

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins lib/ndesk-options/NDesk.Options.dll.mdb
	fi

        mono_multilib_comply
}

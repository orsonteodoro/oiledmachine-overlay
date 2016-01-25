# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mysql-connector-net/mysql-connector-net-1.0.9.ebuild,v 1.3 2008/03/02 09:12:46 compnerd Exp $

EAPI="5"

inherit eutils multilib mono versionator subversion autotools

DESCRIPTION="Tao Framework"
HOMEPAGE="http://sourceforge.net/projects/taoframework/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FEATURES="nofetch"

RDEPEND=">=dev-lang/mono-2.0
		media-libs/openal
		virtual/opengl
		media-libs/libsdl
	"
DEPEND="${RDEPEND}
		app-arch/p7zip"

S="${WORKDIR}/taoframework-${PV}"
src_unpack() {
        ESVN_REPO_URI="svn://svn.code.sf.net/p/taoframework/code/tags/taoframework-2.1.0/"
        ESVN_REVISION="237"
        ESVN_OPTIONS="--trust-server-cert"
	ESVN_PROJECT="taoframework-code"
        subversion_src_unpack
}

src_prepare() {
	sed -i -e 's|monodocer --assembly:$$x/$$x.dll --path:doc/$$x|monodocer --out:doc/$$x $$x/$$x.dll|g' "${S}"/src/Makefile.am
	eautoreconf || die
}

src_configure() {
	econf || die
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install
}

src_install_old() {
	ebegin "Installing dlls into the GAC"
	gacutil -i Binaries/OpenTK/Release/OpenTK.dll -root "${D}/usr/$(get_libdir)" \
		-gacdir "/usr/$(get_libdir)" -package "${PN}" > /dev/null
#	gacutil -i Binaries/OpenTK/Release/OpenTK.Compatibility.dll -root "${D}/usr/$(get_libdir)" \
#		-gacdir "/usr/$(get_libdir)" -package "${PN}" > /dev/null
#	gacutil -i Binaries/OpenTK/Release/OpenTK.GLControl.dll -root "${D}/usr/$(get_libdir)" \
#		-gacdir "/usr/$(get_libdir)" -package "${PN}" > /dev/null
	eend

	dodoc Documentation/*.txt

	mono_multilib_comply
}

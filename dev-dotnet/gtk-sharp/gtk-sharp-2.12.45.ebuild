# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools dotnet

SLOT="2"
DESCRIPTION="GTK bindings for Mono"
HOMEPAGE="https://www.mono-project.com/GtkSharp"
LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="
	!dev-dotnet/atk-sharp
	!dev-dotnet/gdk-sharp
	!dev-dotnet/glade-sharp
	!dev-dotnet/glib-sharp
	!dev-dotnet/gtk-dotnet-sharp
	!dev-dotnet/gtk-sharp-docs
	!dev-dotnet/gtk-sharp-gapi
	!dev-dotnet/pango-sharp
	>=dev-lang/mono-4.4
	>=dev-libs/glib-2.31
	dev-libs/atk
	dev-perl/XML-LibXML
	gnome-base/libglade
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/pango
	virtual/pkgconfig
"
DEPEND=" ${RDEPEND}"

BDEPEND+="
	>=dev-lang/mono-4.4
	sys-devel/gcc
"
#	dev-build/automake:1.11
SRC_URI="
https://download.mono-project.com/sources/gtk-sharp212/${P}.tar.gz
https://github.com/mono/gtk-sharp/commit/a00552ad68ae349e89e440dca21b86dbd6bccd30.patch
	-> ${PN}-a00552a.patch
"
RESTRICT="test"
PATCHES=(
	"${DISTDIR}/${PN}-a00552a.patch"
)
DOCS=( "NEWS" "README" )

src_prepare() {
	default
	eautoreconf
	libtoolize
	eapply_user
}

src_configure() {
	local myconf=(
		--disable-debug
		--disable-dependency-tracking
		--disable-maintainer-mode
		--disable-static
	)
	econf ${myconf[@]}
}

src_compile() {
	emake
}

src_install() {
	default
	sed -i "s/\\r//g" "${D}/usr/bin/"* || die "sed failed"
	find "${ED}" -type f -name '*.la' -delete || die
	dodoc AUTHORS COPYING
	einstalldocs
}

# OILEDMACHINE-OVERLAY-META-REVDEP: monodevelop, dotdevelop

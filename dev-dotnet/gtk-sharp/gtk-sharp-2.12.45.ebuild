# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Gtk# is a Mono/.NET binding to the cross platform Gtk+ GUI toolkit"
DESCRIPTION+=" and the foundation of most GUI apps built with Mono"
HOMEPAGE="http://www.mono-project.com/GtkSharp"
LICENSE="LGPL-2 MIT"
KEYWORDS="~amd64 ~x86 ~ppc"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug"
REQUIRED_USE="^^ ( ${USE_DOTNET} )"
RDEPEND="!dev-dotnet/atk-sharp
	 !dev-dotnet/gdk-sharp
	 !dev-dotnet/glade-sharp
	 !dev-dotnet/glib-sharp
	 !dev-dotnet/gtk-dotnet-sharp
	 !dev-dotnet/gtk-sharp-docs
	 !dev-dotnet/gtk-sharp-gapi
	 !dev-dotnet/pango-sharp
	  dev-libs/atk
	>=dev-libs/glib-2.31
	  dev-perl/XML-LibXML
	  gnome-base/libglade
	  x11-libs/gtk+:2
	  x11-libs/pango"
DEPEND="${RDEPEND}
	sys-devel/automake:1.11
	virtual/pkgconfig"
inherit autotools dotnet
SLOT="2"
SRC_URI="http://download.mono-project.com/sources/gtk-sharp212/${P}.tar.gz"
RESTRICT="test mirror"

src_prepare() {
	default
	eautoreconf
	elibtoolize
}

src_configure() {
	econf	--disable-static \
		--disable-dependency-tracking \
		--disable-maintainer-mode \
		$(use_enable debug)
}

src_compile() {
	addpredict /etc/mono/registry/last-btime
	emake
}

src_install() {
	default
	dotnet_multilib_comply
	sed -i "s/\\r//g" "${D}"/usr/bin/* || die "sed failed"
}

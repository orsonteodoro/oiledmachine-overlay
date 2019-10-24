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
	 !dev-dotnet/gtk-dotnet-sharp
	 !dev-dotnet/gtk-sharp-docs
	 !dev-dotnet/gtk-sharp-gapi
	 !dev-dotnet/gdk-sharp
	 !dev-dotnet/glade-sharp
	 !dev-dotnet/glib-sharp
	 !dev-dotnet/pango-sharp
	  dev-libs/atk
	>=dev-libs/glib-2.32
	  dev-perl/XML-LibXML
	  gnome-base/libglade
	>=x11-libs/cairo-1.10
	  x11-libs/gtk+:3
	  x11-libs/pango"
DEPEND="${RDEPEND}
	sys-devel/automake:1.11
	virtual/pkgconfig"
inherit autotools dotnet
SLOT="3"
EGIT_COMMIT="05e47a49fc62e1108750d2fbdfb883a06a9d1ec6"
BASE_URI="https://github.com/mono/gtk-sharp"
SRC_URI="${BASE_URI}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PVR}.tar.gz 
${BASE_URI}/commit/05e47a49fc62e1108750d2fbdfb883a06a9d1ec6.patch \
	-> ${PN}-${PVR}-use-csc-instead-of-mcs.patch"
RESTRICT="test mirror"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	#step 1: manually mark lib to lib64 to hint which parts to edit
	eapply "${FILESDIR}/gtk-sharp-2.99.9999-multilib-hint.patch"
	#step 2: edit those parts
	FILES=$(grep -l -r -e "lib64")
	for f in $FILES
	do
		sed -i -r -e "s|lib64|$(get_libdir)|g" "$f" || die
	done
	#fix the gac
	sed -i -r -e "s|GACDIR_GENTOO_HINT|/usr/$(get_libdir)|g" \
		configure.ac || die
	sed -i -r \
	  -e "s|GAC_GENTOO_OTHER_ARGS|-root \"${ED}\"/usr/$(get_libdir)|g" \
		configure.ac || die
	# use mcs instead
	eapply -R "${DISTDIR}/${PN}-${PVR}-use-csc-instead-of-mcs.patch"
	eautoreconf
	elibtoolize
}

src_configure() {
	CSFLAGS="${CSFLAGS} -sdk:${EBF}" \
	econf	--disable-static \
		--disable-dependency-tracking \
		--disable-maintainer-mode \
		$(use_enable debug)
}

src_compile() {
	addpredict /etc/mono/registry/last-btime
	CSFLAGS="${CSFLAGS} -sdk:${EBF}" \
	emake
}

src_install() {
	default
	#emake DESTDIR="${D}"
	sed -i "s/\\r//g" "${D}"/usr/bin/* || die "sed failed"
	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins "${S}/cairo/mono.snk"
		doins "gtk-sharp.snk"
	fi
	dotnet_multilib_comply
}

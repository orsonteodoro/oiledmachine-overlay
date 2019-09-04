# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools dotnet

SLOT="3"
DESCRIPTION="Gtk# is a Mono/.NET binding to the cross platform Gtk+ GUI toolkit and the foundation of most GUI apps built with Mono"
LICENSE="LGPL-2 MIT"
HOMEPAGE="http://www.mono-project.com/GtkSharp"
KEYWORDS="~amd64 ~x86 ~ppc"
COMMIT="05e47a49fc62e1108750d2fbdfb883a06a9d1ec6"
SRC_URI="https://github.com/mono/gtk-sharp/archive/${COMMIT}.zip -> ${PN}-${PVR}.zip
	 https://github.com/mono/gtk-sharp/commit/05e47a49fc62e1108750d2fbdfb883a06a9d1ec6.patch -> ${PN}-${PVR}-use-csc-instead-of-mcs.patch"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

RESTRICT="test"
S="${WORKDIR}/${PN}-${COMMIT}"

RDEPEND="
	>=x11-libs/cairo-1.10
	>=dev-lang/mono-3.2.8
	x11-libs/pango
	>=dev-libs/glib-2.32
	dev-libs/atk
	x11-libs/gtk+:3
	gnome-base/libglade
	dev-perl/XML-LibXML
	!dev-dotnet/gtk-sharp-gapi
	!dev-dotnet/gtk-sharp-docs
	!dev-dotnet/gtk-dotnet-sharp
	!dev-dotnet/gdk-sharp
	!dev-dotnet/glib-sharp
	!dev-dotnet/glade-sharp
	!dev-dotnet/pango-sharp
	!dev-dotnet/atk-sharp"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/automake:1.11"

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
	sed -i -r -e "s|GACDIR_GENTOO_HINT|/usr/$(get_libdir)|g" configure.ac || die
	sed -i -r -e "s|GAC_GENTOO_OTHER_ARGS|-root \"${ED}\"/usr/$(get_libdir)|g" configure.ac || die

	# use mcs instead
	eapply -R "${DISTDIR}/${PN}-${PVR}-use-csc-instead-of-mcs.patch"

	eapply_user

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

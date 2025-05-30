# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Bindings to the core Gnome APIs"
HOMEPAGE="http://www.mono-project.com/GtkSharp"
LICENSE="LGPL-2 LGPL-2.1"
if [[ ${PV} != "9999" ]] ; then
KEYWORDS="~amd64 ~x86 ~ppc"
fi
SLOT="2"
# Many files clearly state LGPL-2 and not explicitly newer, but the COPYING states LGPL-2.1.
# Taken from the bootstrap configure script to allow using portage
# functions for building. Should be updated accordingly.
GNOME_SHARP_VERSION=2.24.4 # Not using ${PV} because 9999 depends on this value. Must be bumped with every release.
ASSEMBLY_VERSION=2.24.0.0
POLICY_VERSIONS="2.4 2.6 2.8 2.16 2.20"
GTK_REQUIRED_VERSION=2.13.0
GTK_SHARP_REQUIRED_VERSION=2.12.2
GNOME_REQUIRED_VERSION=2.23.0
GNOMECANVAS_REQUIRED_VERSION=2.20.0
VERSIONCSDEFINES="-define:GTK_SHARP_2_6 -define:GTK_SHARP_2_8 -define:GNOME_SHARP_2_16 -define:GNOME_SHARP_2_20 -define:GNOME_SHARP_2_24"
VERSIONCFLAGS="-DGTK_SHARP_2_6 -DGTK_SHARP_2_8 -DGNOME_SHARP_2_16 -DGNOME_SHARP_2_20 -DGNOME_SHARP_2_24"
GNOME_API_TAG=2.20
IUSE="debug"
RESTRICT="mirror test"
RDEPEND=">=dev-dotnet/gtk-sharp-2.12.21:2
	 gnome-base/gconf
	 gnome-base/libgnomecanvas
	 gnome-base/libgnomeui
	 media-libs/libart_lgpl
	 !dev-dotnet/gnomevfs-sharp
	 !dev-dotnet/gconf-sharp
	 !dev-dotnet/art-sharp"
DEPEND="${RDEPEND}
	dev-build/automake:1.11"
inherit autotools dotnet
if [[ ${PV} == "9999" ]] ; then
EGIT_REPO_URI="https://github.com/mono/gnome-sharp.git"
inherit git-r3
else
SRC_URI="https://github.com/mono/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

pkg_pretend() {
	if [[ ${PV} != "9999" ]] ; then
		if [[ ${PV} > ${GNOME_SHARP_VERSION} ]] ; then
			die "Revision bumps must also update the GNOME_SHARP_VERSION variable."
		fi
	fi
}

src_prepare() {
	default
	eapply "${FILESDIR}/gnome-sharp-2.24.4-unexpected-symbol-fix.patch"
	sed -e "s/@GNOME_SHARP_VERSION@/$GNOME_SHARP_VERSION/" \
		-e "s/@GTK_REQUIRED_VERSION@/$GTK_REQUIRED_VERSION/" \
		-e "s/@GTK_SHARP_REQUIRED_VERSION@/$GTK_SHARP_REQUIRED_VERSION/" \
		-e "s/@GNOME_REQUIRED_VERSION@/$GNOME_REQUIRED_VERSION/" \
		-e "s/@GNOMECANVAS_REQUIRED_VERSION@/$GNOMECANVAS_REQUIRED_VERSION/" \
		-e "s/@VERSIONCSDEFINES@/$VERSIONCSDEFINES/" \
		-e "s/@VERSIONCFLAGS@/$VERSIONCFLAGS/" \
		-e "s/@POLICY_VERSIONS@/$POLICY_VERSIONS/" \
		-e "s/@ASSEMBLY_VERSION@/$ASSEMBLY_VERSION/" "$S/configure.in.in" > "$S/configure.in"
	eautoreconf
	elibtoolize
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default
	dotnet_multilib_comply
}

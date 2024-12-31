# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A generic framework for creating extensible applications"
HOMEPAGE="http://www.mono-project.com/Mono.Addins"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~x86"
USE_DOTNET="net35"
IUSE="${USE_DOTNET} +gtk"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
RDEPEND=">=dev-lang/mono-3
	gtk? ( >=dev-dotnet/gtk-sharp-2.12.21:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit autotools dotnet eutils
SRC_URI="https://github.com/mono/${PN}/archive/${P}.tar.gz -> ${P}.tar.gz"
SLOT="0/$(ver_cut 1-2 ${PV})"
MAKEOPTS="${MAKEOPTS} -j1" #nowarn
S="${WORKDIR}/${PN}-${P}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/gmcs.patch"
	eautoreconf
	## with dev-dotnet/gtk-sharp-2.99.1
	## it gives
	## checking for GTK_SHARP_20... no
	## configure: error: Package requirements (gtk-sharp-2.0) were not met:
	##
	## No package 'gtk-sharp-2.0' found
	sed -i \
-e "s;Mono.Cairo;Mono.Cairo, Version=4.0.0.0, Culture=neutral, PublicKeyToken=0738eb9f132ed756;g" \
		Mono.Addins.Gui/Mono.Addins.Gui.csproj || die "sed failed"
	sed -i \
-e "s;\"System\";\"System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089\";g" \
		Mono.Addins.Gui/Mono.Addins.Gui.csproj || die "sed failed"
}

src_configure() {
	econf $(use_enable gtk gui)
}

src_install() {
	default
	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/Mono.Addins.Setup.dll.mdb
		doins bin/Mono.Addins.CecilReflector.dll.mdb
		doins bin/Mono.Addins.Gui.dll.mdb
		doins bin/mautil.exe.mdb
		doins bin/Mono.Addins.MSBuild.dll.mdb
		doins bin/Mono.Addins.dll.mdb
	fi
	dotnet_multilib_comply
}

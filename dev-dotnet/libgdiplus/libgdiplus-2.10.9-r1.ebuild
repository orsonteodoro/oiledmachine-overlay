# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Library for using System.Drawing with mono"
HOMEPAGE="http://www.mono-project.com"
LICENSE="MIT"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="0"
IUSE="cairo"
RDEPEND=" !cairo? ( >=x11-libs/pango-1.20 )
	 >=dev-libs/glib-2.16:2
	 >=media-libs/fontconfig-2.6
	 >=media-libs/freetype-2.3.7
	 >=media-libs/giflib-4.1.3
	   media-libs/libexif
	 >=media-libs/libpng-1.4:0
	   media-libs/tiff:0
	   virtual/jpeg:0
	   x11-libs/libXrender
	   x11-libs/libX11
	   x11-libs/libXt
	 >=x11-libs/cairo-1.8.4[X]"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/${P}-gold.patch"
	  "${FILESDIR}/${PN}-2.10.1-libpng15.patch"
	  "${FILESDIR}/${PN}-2.10.9-freetype251.patch" )
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"
inherit dotnet eutils mono flag-o-matic
RESTRICT="mirror test"

src_prepare() {
	default
	sed -i -e 's:ungif:gif:g' configure || die
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf --disable-dependency-tracking		\
	      --disable-static				\
	      --with-cairo=system			\
	      $(use !cairo && printf %s --with-pango)
}

src_install () {
	emake -j1 DESTDIR="${D}" "$@" install #nowarn
	local commondoc=( AUTHORS ChangeLog README TODO )
	for docfile in "${commondoc[@]}"
	do
		[[ -e "${docfile}" ]] && dodoc "${docfile}"
	done
	if [[ "${DOCS[@]}" ]]
	then
		dodoc "${DOCS[@]}"
	fi
	prune_libtool_files

	mono_multilib_comply
}

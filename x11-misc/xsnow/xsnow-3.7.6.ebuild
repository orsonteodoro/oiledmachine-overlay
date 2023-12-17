# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

SRC_URI="https://www.ratrabbit.nl/downloads/xsnow/${P}.tar.gz"

DESCRIPTION="let it snow on your desktop and windows"
HOMEPAGE="https://www.ratrabbit.nl/ratrabbit/xsnow/"
LICENSE="
	GPL-3+
	CC0-1.0
"
# muslim-woman-keffiyeh.xpm CC0-1.0
#   https://openclipart.org/detail/256949/muslim-woman-variation-2
#   https://openclipart.org/detail/284445/keffiyeh-pattern-conversion-freebassel-request
# menorah.xpm CC0-1.0
#   https://openclipart.org/detail/291738/hannukah-symbol
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="custom-image keffiyeh-woman keffiyeh-woman-mask-on menorah palestine-flag +ukraine-flag no-flag r1"
REQUIRED_USE="
	|| (
		custom-image
		keffiyeh-woman
		keffiyeh-woman-mask-on
		menorah
		no-flag
		palestine-flag
		ukraine-flag
	)
"
RDEPEND="
	dev-libs/glib:2
	sci-libs/gsl:=
	sys-apps/dbus
	sys-process/procps
	x11-base/xorg-proto
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/libXt
	x11-libs/libXtst
	x11-libs/libxkbcommon
	x11-misc/xcompmgr
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}/${PN}-3.0.7-gamesdir.patch"
)

src_prepare() {
	default
	eautoreconf
	if ! use ukraine-flag ; then
		cat "${FILESDIR}/blank.xpm" > "${S}/src/Pixmaps/extratree.xpm" || die
	fi
	if use palestine-flag ; then
		cat "${FILESDIR}/palestine-flag.xpm" > "${S}/src/Pixmaps/extratree.xpm" || die
	fi
	if use keffiyeh-woman ; then
		cat "${FILESDIR}/muslim-woman-keffiyeh.xpm" > "${S}/src/Pixmaps/extratree.xpm" || die
	fi
	if use keffiyeh-woman-mask-on ; then
		cat "${FILESDIR}/muslim-woman-keffiyeh-mask-on.xpm" > "${S}/src/Pixmaps/extratree.xpm" || die
	fi
	if use menorah ; then
		cat "${FILESDIR}/menorah.xpm" > "${S}/src/Pixmaps/extratree.xpm" || die
	fi
	if use custom-image ; then
		local path="/etc/portage/savedconfig/${CATEGORY}/${PN}/custom.xpm"
		if [[ -e "${path}" ]] ; then
			cat "/etc/portage/savedconfig/${CATEGORY}/${PN}/custom.xpm" > "${S}/src/Pixmaps/extratree.xpm" || die
		else
eerror "The custom image (of maybe 72x72 px with extratree_xpm variable name in file) must be placed in ${path}"
			die
		fi
	fi
}

gen_wrappers() {
exeinto "usr/bin"
newexe - xsnow <<-EOF
#/usr/bin/env bash
if ! pgrep "xcompmgr" ; then
	xcompmgr 2>/dev/null &
	sleep 0.1
	"${EPREFIX}/usr/bin/xsnow-bin" "\$@"
	killall xcompmgr
else
	"${EPREFIX}/usr/bin/xsnow-bin" "\$@"
fi
EOF

exeinto "usr/$(get_libdir)/misc/xscreensaver"
newexe - xsnow <<-EOF
#/usr/bin/env bash
exec "${EPREFIX}/usr/bin/xsnow-bin" -nomenu -root
EOF
}

src_install() {
	default

	# Install xscreensaver hack, which calls xsnow with the correct
	# arguments. xscreensaver calls all hacks with --root, however xsnow
	# only understands -root and will exit with an error if an unknown
	# argument (--root) is provided.
	mv "${ED}/usr/bin/xsnow"{,-bin}
	gen_wrappers
}

# OILEDMACHINE-OVERLAY-TEST:  passed (3.7.6, 20231215)

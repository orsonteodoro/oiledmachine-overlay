# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="https://dwm.suckless.org/"
LICENSE="MIT
	mod_fibonacci? ( all-rights-reserved )
	mod_rotatestack? ( all-rights-reserved )"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="  xinerama
	mod_fibonacci mod_rotatestack mod_sizehintsoff"
SLOT="0"
RDEPEND="media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	xinerama? ( x11-base/xorg-proto )"
FIBONACCI_FN="dwm-fibonacci-5.8.2.diff"
ROTATESTACK_FN="dwm-rotatestack-20161021-ab9571b.diff"
DWM_FN="${P}.tar.gz"
SRC_URI="https://dl.suckless.org/${PN}/${DWM_FN}
	mod_fibonacci? ( ${FIBONACCI_FN} )
	mod_rotatestack? ( ${ROTATESTACK_FN} )"
RESTRICT="fetch"

_boilerplate_dl_link_hints() {
	local fn_d="${1}"
	local dl_location="${2}"
	local msg="${3}"
	local hash="${4}"
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo
	einfo "${msg}"
	einfo "from ${dl_location} and rename it to ${fn_d} place them in ${distdir} ."
	einfo "If copied correctly, the sha1sum should be ${hash} ."
	einfo
}

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	if [ ! -f "${DISTDIR}/${DWM_FN}" ] ; then
		einfo
		einfo "${PN} is NOT fetch restricted but the mods are."
		einfo "Do \`wget -O ${distdir}/${DWM_FN} https://dl.suckless.org/${PN}/${DWM_FN}\`"
		einfo "To get ${PN}."
		einfo
	fi
	if use mod_fibonacci ; then
		_boilerplate_dl_link_hints "${FIBONACCI_FN}" \
			"https://dwm.suckless.org/patches/fibonacci/" \
			"Download the file" \
			"bf556ad02793303a599d0efcb256aad991eaaa39"
	fi
	if use mod_rotatestack ; then
		_boilerplate_dl_link_hints "${ROTATESTACK_FN}" \
			"https://dwm.suckless.org/patches/rotatestack/" \
			"Download the file" \
			"b37cbd30aefd5ad88baa34e7a89dea80480800da"
	fi
}

src_prepare() {
	default
	if use mod_fibonacci ; then
		eapply "${DISTDIR}/${FIBONACCI_FN}"
		eapply "${FILESDIR}/dwm-fibonacci-hotkeys.patch"
	fi
	if use mod_rotatestack ; then
		eapply "${DISTDIR}/${ROTATESTACK_FN}"
	fi
	if use mod_sizehintsoff ; then
		sed -i -e "s|resizehints = 1|resizehints = 0|g" config.def.h || die
	fi
	eapply "${FILESDIR}"/dwm-6.1-no-emoji-title-crash.patch
	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die
	restore_config config.h
	if use mod_sizehintsoff && [[ -e "${S}/config.h" ]] ; then
		sed -i -e "s|resizehints = 1|resizehints = 0|g" config.h || die
	fi
}

src_compile() {
	if use xinerama; then
		emake CC=$(tc-getCC) dwm
	else
		emake CC=$(tc-getCC) XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/dwm-session2 dwm
	insinto /usr/share/xsessions
	doins "${FILESDIR}"/dwm.desktop
	dodoc README
	save_config config.h
}

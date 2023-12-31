# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A dynamic window manager for X11"
HOMEPAGE="https://dwm.suckless.org/"
LICENSE="
	MIT
	mod_fibonacci? ( all-rights-reserved )
	mod_rotatestack? ( all-rights-reserved )
"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="
	mod_fibonacci
	mod_rotatestack
	mod_sizehintsoff
	savedconfig
	xinerama
"
SLOT="0"
RDEPEND="
	>=x11-libs/libXft-2.3.5
	media-libs/fontconfig
	x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	xinerama? ( x11-base/xorg-proto )
"
FIBONACCI_DFN="dwm-fibonacci-6.2.diff"
FIBONACCI_SFN="dwm-fibonacci-6.2.diff"
ROTATESTACK_DFN="dwm-rotatestack-20161021-ab9571b.diff"
ROTATESTACK_SFN="dwm-rotatestack-20161021-ab9571b.diff"
DWM_FN="${P}.tar.gz"
SRC_URI="
https://dl.suckless.org/${PN}/${DWM_FN}
mod_fibonacci? ( ${FIBONACCI_DFN} )
mod_rotatestack? ( ${ROTATESTACK_DFN} )
"
RESTRICT="fetch"
SHA512_FIBONACCI="\
b0d1d21a246cf395c7dca880fa0b660b263c13d3740f78e8c96e2c90dc1f6b59\
618c756497a11d81da3d2f3ed8602e649614e7019d535e2f45e1c39b9e32e325\
"
SHA512_ROTATESTACK="\
65e6d67c27434ad36f2e6d307e00307134084c9124efc1f29361bd9e8f29bd05\
c0bc9f1bf399ba16d53f92193e5d990a75a9ef73d7820ef9c72b639205575f10\
"

_boilerplate_dl_link_hints() {
	local fn_s="${1}"
	local fn_d="${2}"
	local dl_location="${3}"
	local hash="${4}"
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo
	einfo "The following file needs to be downloaded:"
	einfo
	einfo "File:\t\t${fn_s}"
	einfo "Download URI:\t${dl_location}"
	einfo "Destination:\t\t${distdir}/${fn_d}"
	einfo "SHA512 fingerprint:\t${hash}"
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
		_boilerplate_dl_link_hints \
			"${FIBONACCI_SFN}" \
			"${FIBONACCI_DFN}" \
			"https://dwm.suckless.org/patches/fibonacci/" \
			"${SHA512_FIBONACCI}"
	fi
	if use mod_rotatestack ; then
		_boilerplate_dl_link_hints \
			"${ROTATESTACK_SFN}" \
			"${ROTATESTACK_DFN}" \
			"https://dwm.suckless.org/patches/rotatestack/" \
			"${SHA512_ROTATESTACK}"
	fi
}

src_prepare() {
	default
	if use mod_fibonacci ; then
		eapply "${DISTDIR}/${FIBONACCI_DFN}"
	fi
	if use mod_rotatestack ; then
		eapply "${DISTDIR}/${ROTATESTACK_DFN}"
	fi
	if use mod_sizehintsoff ; then
		sed -i -e "s|resizehints = 1|resizehints = 0|g" config.def.h || die
	fi
	eapply "${FILESDIR}/dwm-6.1-no-emoji-title-crash.patch"
	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die

	if use savedconfig ; then
		if [[ -z "${SAVEDCONFIG_PATH}" ]] ; then
eerror
eerror "You must define SAVEDCONFIG_PATH as the abspath to a personal config.h."
eerror
			die
		fi
		cat "${SAVEDCONFIG_PATH}" > config.h || die
	fi
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
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patches, ebuild-changes

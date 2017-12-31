# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/surf/surf-0.6-r1.ebuild,v 1.7 2013/11/01 13:50:07 ago Exp $

EAPI=6
inherit autotools eutils flag-o-matic multilib multilib-minimal multilib-build  savedconfig toolchain-funcs

DESCRIPTION="A simple web browser based on WebKit/GTK+."
HOMEPAGE="http://surf.suckless.org/"
SRC_URI="http://dl.suckless.org/${PN}/${P}.tar.gz"

LICENSE="MIT adblock? ( CC-BY-NA-SA-3.0 MIT ) linkhints? ( SURF-community ) searchengines? ( SURF-community ) rip? ( || ( MIT GPL-2+ ) ) mimehandler? ( SURF-community ) simplebookmarking? ( SURF-community )"
SLOT="0"

_ABIS="abi_x86_32 abi_x86_64 abi_x86_x32 abi_mips_n32 abi_mips_n64 abi_mips_o32 abi_ppc_32 abi_ppc_64 abi_s390_32 abi_s390_64"
IUSE="gtk3 adblock searchengines rip mimehandler linkhints simplebookmarking"
IUSE+=" ${_ABIS}"
REQUIRED_USE="^^ ( ${_ABIS} ) adblock? ( gtk3 ) rip? ( mimehandler savedconfig ) searchengines? ( savedconfig ) simplebookmarking? ( savedconfig )"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	dev-libs/glib
	net-libs/libsoup
	x11-libs/libX11
       !gtk3? (
                =net-libs/webkit-gtk-2.0.4-r200
                >=x11-libs/gtk+-2.14:2
        )
        gtk3? (
                net-libs/webkit-gtk:4/37
                x11-libs/gtk+:3
        )
	sys-apps/dbus[X]
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="
	!sci-chemistry/surf
	${COMMON_DEPEND}
	x11-apps/xprop
	x11-misc/dmenu
        net-misc/curl
        x11-terms/st
	dev-libs/json-glib[${MULTILIB_USEDEP}]
"

pkg_setup() {
	if use savedconfig; then
		if [[ ! -f "/etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR}" ]]; then
			elog "Please copy \$\{FILESDIR\}/${PN}-${PV} to /etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR} and edit accordingly."
			die ""
		fi
	fi
}

src_prepare() {
	eapply "${FILESDIR}"/${P}-gentoo.patch
	if use gtk3 ; then
		eapply "${FILESDIR}"/${PN}-0.6-gtk3.patch
		cat "${FILESDIR}"/configure.ac.0.6 > "${WORKDIR}/${P}"/configure.ac
		cat "${FILESDIR}"/Makefile.am.0.6 > "${WORKDIR}/${P}"/Makefile.am
	fi
	#if use ssl_proxy ; then
	#	eapply "${FILESDIR}"/${PN}-sslproxy.patch
	#fi
	if use adblock ; then
		eapply "${FILESDIR}"/${PN}-0.6-adblock.patch
	fi

	if use searchengines ; then
		eapply "${FILESDIR}"/${PN}-0.6-search.patch
	fi

	if use gtk3 || use linkhints || use adblock || use searchengines || use rip || use mimehandler || use simplebookmarking ; then
		eapply "${FILESDIR}"/${PN}-0.6-copyrights.patch
	fi

	restore_config config.h
	tc-export CC PKG_CONFIG

	touch NEWS AUTHORS ChangeLog

	eapply_user

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf

	if use simplebookmarking ; then
		grep -r -e "BM_ADD" config.h || \
			die "Please copy ${FILESDIR}/${PN}-${PV} to /etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR} and edit accordingly, or manually apply the patch from https://surf.suckless.org/files/simple_bookmarking_redux ."
	fi

	ECONF_SOURCE=${S} \
	PKG_CONFIG_PATH="/usr/$(get_libdir)/pkgconfig" \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	emake
}

multilib_src_install() {
	default
	save_config config.h

	if use adblock ; then
		mkdir -p "${D}/etc/surf/scripts"
		cp -r "${FILESDIR}/events" "${D}/etc/surf/scripts/"
		cp -r "${FILESDIR}/adblock" "${D}/etc/surf/scripts/"
	fi

	mkdir -p "${D}/usr/share/surf"
	if use rip ; then
		cp "${FILESDIR}"/rip* "${D}/usr/share/surf"
	fi
	if use mimehandler ; then
		cp "${FILESDIR}"/mimehandler "${D}/usr/share/surf"
	fi
	if use linkhints ; then
		cp "${FILESDIR}"/script.js "${D}/usr/share/surf"
	fi
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 0.4.1-r1 ]]; then
		ewarn "Please correct the permissions of your \$HOME/.surf/ directory"
		ewarn "and its contents to no longer be world readable (see bug #404983)"
	fi
	if use rip ; then
		elog "If you want external media support cp /usr/share/${PN}/rip* to your home directory."
	fi
	if use mimehandler ; then
		elog "If you want mime support cp /usr/share/${PN}/mimehandler to your home directory."
	fi
	if use linkhints ; then
		elog "If you want link hinting support cp /usr/share/${PN}/{script.js,style.css} to your home/.surf directory."
	fi
	if use adblock ; then
		elog "You must update the adblock filters manually at /etc/surf/adblock/update.sh.  Make sure the current working directory is /etc/surf/adblock/ before running it."
	fi
}

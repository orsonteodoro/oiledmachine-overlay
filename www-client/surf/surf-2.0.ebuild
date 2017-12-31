# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit savedconfig toolchain-funcs \
	multilib multilib-minimal multilib-build autotools flag-o-matic eutils

DESCRIPTION="a simple web browser based on WebKit/GTK+"
HOMEPAGE="https://surf.suckless.org/"
SRC_URI="
	https://dl.suckless.org/${PN}/${P}.tar.gz
"

LICENSE="MIT adblock? ( CC-BY-NA-SA-3.0 ) linkhints? ( SURF-community ) searchengines? ( searchengines ) simplebookmarking? ( SURF-community )"
SLOT="0"
KEYWORDS="amd64 x86"

_ABIS="abi_x86_32 abi_x86_64 abi_x86_x32 abi_mips_n32 abi_mips_n64 abi_mips_o32 abi_ppc_32 abi_ppc_64 abi_s390_32 abi_s390_64"
IUSE="adblock searchengines linkhints simplebookmarking"
IUSE+=" ${_ABIS}"
REQUIRED_USE="^^ ( ${_ABIS} ) linkhints searchengines? ( savedconfig )"

COMMON_DEPEND="
	dev-libs/glib:2
	net-libs/libsoup
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	x11-libs/libX11
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
	!savedconfig? (
		net-misc/curl
		x11-terms/st
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.0-gentoo.patch
)

pkg_setup() {
	if ! use savedconfig; then
		elog "The default config.h assumes you have"
		elog " net-misc/curl"
		elog " x11-terms/st"
		elog "installed to support the download function."
		elog "Without those, downloads will fail (gracefully)."
		elog "You can fix this by:"
		elog "1) Installing these packages, or"
		elog "2) Setting USE=savedconfig and changing config.h accordingly."
		elog "3) Copying ${FILESDIR}/${PN}-${PV} to /etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR} and edit accordingly."
	fi
}

src_prepare() {
	eapply ${PATCHES[@]}

	cat "${FILESDIR}"/configure.ac.2.0 > "${WORKDIR}/${P}"/configure.ac
	cat "${FILESDIR}"/Makefile.am.2.0 > "${WORKDIR}/${P}"/Makefile.am

	if use adblock ; then
		eapply "${FILESDIR}"/${PN}-2.0-adblock.patch
	fi

	if use searchengines ; then
		eapply "${FILESDIR}"/${PN}-2.0-search.patch
	fi

	if use adblock || use searchengines ; then
		eapply "${FILESDIR}"/${PN}-2.0-copyrights.patch
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
	if use linkhints ; then
		cp "${FILESDIR}"/script.js "${D}/usr/share/surf"
	fi
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 0.4.1-r1 ]]; then
		ewarn "Please correct the permissions of your \$HOME/.surf/ directory"
		ewarn "and its contents to no longer be world readable (see bug #404983)"
	fi

	if use linkhints ; then
		elog "If you want link hinting support cp /usr/share/${PN}/{script.js,style.css} to your home/.surf directory."
	fi

	if use adblock ; then
		elog "You must update the adblock filters manually at /etc/surf/adblock/update.sh.  Make sure the current working directory is /etc/surf/adblock/ before running it."
	fi
}

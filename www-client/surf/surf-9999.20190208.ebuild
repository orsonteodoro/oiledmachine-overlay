# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 savedconfig toolchain-funcs
inherit multilib-minimal

DESCRIPTION="a simple web browser based on WebKit/GTK+"
HOMEPAGE="https://surf.suckless.org/"
EGIT_REPO_URI="https://git.suckless.org/surf"
EGIT_BRANCH="surf-webkit2"
EGIT_COMMIT="d068a3878b6b9f2841a49cd7948cdf9d62b55585"

# The GPL-3+ on the adblock comes from EasyList blocklist
LICENSE="MIT
	 mod_adblock? ( CC-BY-NA-SA-3.0 CC-BY-SA-3.0 CC-BY-SA-4.0 GPL-3+ MIT )
	 mod_link_hints? ( all-rights-reserved )
	 mod_searchengines? ( all-rights-reserved )
	 mod_autoopen? ( all-rights-reserved )
	 mod_simple_bookmarking_redux? ( all-rights-reserved )"

SLOT="0"
KEYWORDS=""

COMMON_DEPEND="
	app-crypt/gcr[gtk]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	net-libs/webkit-gtk:4[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
RDEPEND="
	!sci-chemistry/surf
	${COMMON_DEPEND}
	!savedconfig? (
		>=x11-misc/dmenu-4.7
		net-misc/curl
		x11-apps/xprop
		x11-terms/st
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-9999-gentoo.patch
)

IUSE="mod_adblock mod_autoopen mod_link_hints mod_searchengines mod_simple_bookmarking_redux update_adblock"
REQUIRED_USE="mod_searchengines? ( savedconfig )
	      mod_simple_bookmarking_redux? ( savedconfig )
	      update_adblock? ( mod_adblock )"
RESTRICT="fetch"
LINK_HINTS_FN="surf-9999-link-hints.diff"
AUTOOPEN_FN="surf-0.3-autoopen.diff"
SEARCHENGINES_FN="surf-git-20170323-webkit2-searchengines.diff"
SRC_URI="mod_link_hints? ( ${LINK_HINTS_FN} )
	 mod_autoopen? ( ${AUTOOPEN_FN} )
	 mod_searchengines? ( ${SEARCHENGINES_FN} )"

_boilerplate_dl() {
	local fn_s="${1}"
	local fn_d="${2}"
	local dl_location="${3}"
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo
	einfo "Please download"
	einfo "  - ${fn_s}"
	einfo "from ${dl_location} and rename it to ${fn_d} place them in ${distdir}"
	einfo
}

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
	die
}

pkg_nofetch() {
	env
	die
	ewarn "This ebuild is still in development"
	if use mod_link_hints ; then
		_boilerplate_dl_link_hints "${LINK_HINTS_FN}" "https://surf.suckless.org/files/link_hints/" "Copy and paste the Code section into a file" "9527d1240cd4a2c3cde077ae2b287d2f1a5ae758"
	fi
	if use mod_autoopen ; then
		_boilerplate_dl "${AUTOOPEN_FN}" "${AUTOOPEN_FN}" "https://surf.suckless.org/patches/autoopen/"
	fi
	if use mod_simple_bookmarking_redux ; then
		if [ ! -e /etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR} ] ; then
			eerror "Please copy ${FILESDIR}/config.h.9999 or your provided edited version as /etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR} ."
		fi
		if ! grep -r -e "define BM_PICK" /etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR} ; then
			eerror "Missing define BM_PICK and/or keybindings.  Copy the define/keybindings into your savedconfig file.  See https://surf.suckless.org/files/simple_bookmarking_redux/ for details."
		fi
		if ! grep -r -e "define BM_ADD" /etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR} ; then
			eerror "Missing define BM_ADD and/or keybindings.  Copy the define/keybindings into your savedconfig file.  See https://surf.suckless.org/files/simple_bookmarking_redux/ for details."
		fi
	fi
	if use mod_searchengines ; then
		_boilerplate_dl "${SEARCHENGINES_FN}" "${SEARCHENGINES_FN}" "https://surf.suckless.org/patches/searchengines/"
	fi
}

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
	fi
}

src_prepare() {
	default

	cd "${S}"

	if use mod_adblock ; then
		eapply "${FILESDIR}"/${PN}-9999-adblock.patch
	fi

	if use mod_searchengines ; then
		einfo "${SEARCHENGINES_FN} patch may break.  Will triage immediately."
		patch -p1 -i "${DISTDIR}/${SEARCHENGINES_FN}"
		eapply "${FILESDIR}/surf-9999-webkit2-searchengines-compat.patch"
	fi

	restore_config config.h

	tc-export CC PKG_CONFIG

	touch NEWS AUTHORS ChangeLog

	eautoreconf

	multilib_copy_sources
}

multilib_src_install() {
	default

	save_config config.h

	dodoc "${FILESDIR}/LICENSES"

	if use mod_adblock ; then
		insinto /etc/surf/scripts
		doins -r "${FILESDIR}/events" "${FILESDIR}/adblock"
		fperms 0750 /etc/surf/scripts/adblock/{update.sh,adblock.py,blocklists.py,blocksrv.py,convert.py}
	fi

	if use mod_link_hints ; then
		cp -a "${DISTDIR}/surf-9999-link-hints.diff" "${T}/script.js"
		insinto /usr/share/${PN}
		doins "${T}/script.js"
	fi
}

_update_adblock() {
	einfo "Updating adblock rules"
	cd /etc/surf/scripts/adblock
	./update.sh
	einfo "Done updating adblock rules"
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 0.4.1-r1 ]]; then
		ewarn "Please correct the permissions of your \$HOME/.surf/ directory"
		ewarn "and its contents to no longer be world readable (see bug #404983)"
	fi

	if use mod_link_hints ; then
		elog "If you want link hinting support cp /usr/share/${PN}/{script.js,style.css} to your /home/<USER>/.surf directory."
	fi

	if use mod_adblock ; then
		elog "You must update the adblock filters manually at /etc/surf/adblock/update.sh.  Make sure the current working directory is /etc/surf/adblock/ before running it."
	fi

	if use mod_adblock ; then
		einfo "You may run \`emerge --config ${CATEGORY}/${PN}\` to update the adblock."
		if use update_adblock ; then
			_update_adblock
		fi
	fi
}

pkg_config() {
	if use mod_adblock ; then
		_update_adblock
	fi
}

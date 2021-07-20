# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit multilib-minimal python-r1

DESCRIPTION="a simple web browser based on WebKit/GTK+"
HOMEPAGE="https://surf.suckless.org/"
LICENSE="MIT SURF
	 mod_adblock? ( CC-BY-NA-SA-3.0 MIT SURF-MOD_ADBLOCKER )
         mod_adblock_easylist? ( CC-BY-SA-3.0 GPL-3+ SURF-MOD_ADBLOCKER-EASYLIST )
         mod_adblock_spam404? ( CC-BY-SA-4.0 SURF-MOD_ADBLOCKER-SPAM404 )
	 mod_autoopen? ( all-rights-reserved )
	 mod_link_hints? ( all-rights-reserved )
	 mod_searchengines? ( all-rights-reserved )
	 mod_simple_bookmarking_redux? ( all-rights-reserved )"
KEYWORDS="~alpha amd64 ~amd64-fbsd ~amd64-linux ~arm arm64 ~ia64 ~ppc ~ppc64 \
~sparc x86 ~x86-linux ~x86-macos"
SLOT="0"
IUSE+=" doc mod_adblock mod_adblock_spam404 mod_adblock_easylist
mod_autoopen mod_link_hints mod_searchengines mod_simple_bookmarking_redux
tabbed update_adblock +pulseaudio +v4l"
REQUIRED_USE+="
	mod_adblock_easylist? ( mod_adblock )
	mod_adblock_spam404? ( mod_adblock )
	mod_searchengines? ( savedconfig )
	mod_simple_bookmarking_redux? ( savedconfig )
	update_adblock? ( mod_adblock )"
DEPEND+="
	!sci-chemistry/surf
	app-crypt/gcr[gtk,${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	net-libs/webkit-gtk:4[${MULTILIB_USEDEP},pulseaudio?,v4l?]
	mod_adblock? ( $(python_gen_cond_dep 'dev-python/future[${PYTHON_USEDEP}]')
			x11-apps/xprop )
	!savedconfig? ( net-misc/curl[${MULTILIB_USEDEP}]
			x11-apps/xprop
			>=x11-misc/dmenu-4.7
			x11-terms/st )
	tabbed? ( x11-misc/tabbed )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	|| (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config]
		>=dev-util/pkgconfig-0.29.2[${MULTILIB_USEDEP}]
	)
	update_adblock? ( ${PYTHON_DEPS} )"
EGIT_BRANCH="surf-webkit2"
EGIT_COMMIT="761ea9e4c6c4d8aba4a4d39da9c9b4db8ac471b1"
EGIT_REPO_URI="https://git.suckless.org/surf"
AUTOOPEN_FN="surf-0.3-autoopen.diff"
LINK_HINTS_FN="surf-9999-link-hints.diff"
SEARCHENGINES_FN="surf-git-20170323-webkit2-searchengines.diff"
SRC_URI="mod_autoopen? ( ${AUTOOPEN_FN} )
	 mod_link_hints? ( ${LINK_HINTS_FN} )
	 mod_searchengines? ( ${SEARCHENGINES_FN} )"
inherit git-r3 savedconfig toolchain-funcs
PATCHES=( "${FILESDIR}/${PN}-2.1-gentoo.patch" )
DOCS=( README )
SAVEDCONFIG_PATH="${PORTAGE_CONFIGROOT%/}/etc/portage/savedconfig/${CATEGORY}/${PF}"

_boilerplate_dl() {
	local fn_s="${1}"
	local fn_d="${2}"
	local dl_location="${3}"
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
einfo
einfo "Please download"
einfo "  - ${fn_s}"
einfo "from ${dl_location} and rename it to ${fn_d} place them in"
einfo "${distdir}"
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
einfo "If copied correctly, the sha1sum should be ${hash}."
einfo
}

pkg_setup() {
	if use mod_autoopen ; then
		_boilerplate_dl "${AUTOOPEN_FN}" "${AUTOOPEN_FN}" \
			"https://surf.suckless.org/patches/autoopen/"
	fi
	if use mod_link_hints ; then
		_boilerplate_dl_link_hints "${LINK_HINTS_FN}" \
			"https://surf.suckless.org/files/link_hints/" \
			"Copy and paste the Code section into a file" \
			"9527d1240cd4a2c3cde077ae2b287d2f1a5ae758"
	fi
	if use mod_searchengines ; then
		_boilerplate_dl "${SEARCHENGINES_FN}" "${SEARCHENGINES_FN}" \
			"https://surf.suckless.org/patches/searchengines/"
	fi
	if use mod_adblock ; then
		python_setup
	fi
}

src_prepare() {
	default

	cd "${S}" || die

einfo "Disabling accelerated canvas in config.def.h"
	sed -i -e "s#\
\[AcceleratedCanvas\]   =       { { .i = 1 },#\
\[AcceleratedCanvas\]   =       { { .i = 0 },#" "config.def.h" || die

	if use savedconfig ; then
		if [ ! -e "${SAVEDCONFIG_PATH}" ] ; then
eerror
eerror "Please run"
eerror
eerror "  mkdir -p \"/etc/portage/savedconfig/www-client\" ; \ "
eerror "    cp \"${S}/config.def.h\" \"${SAVEDCONFIG_PATH}\""
eerror
eerror "or provide your edited config.h saved as"
eerror
eerror "  ${SAVEDCONFIG_PATH}"
eerror
			die
		fi
	else
einfo
einfo "The default config.h assumes you have"
einfo "  net-misc/curl"
einfo "  x11-terms/st"
einfo "installed to support the download function.  Without those, downloads"
einfo "will fail (gracefully).  You can fix this by:"
einfo "1) Installing these packages, or"
einfo "2) Setting USE=savedconfig and running"
einfo "\`cp ${S}/config.def.h ${SAVEDCONFIG_PATH}\` and changing it accordingly."
einfo
	fi

	if use mod_simple_bookmarking_redux ; then
		if ! grep -F -q -e "define BM_PICK" \
			"${SAVEDCONFIG_PATH}" ; \
		then
eerror
eerror "Missing define BM_PICK and/or keybindings.  Copy the define/keybindings"
eerror "into your savedconfig file (${SAVEDCONFIG_PATH}) .  See"
eerror "https://surf.suckless.org/files/simple_bookmarking_redux/ for details."
eerror
			die
		fi
		if ! grep -q -F -e "define BM_ADD" \
			"${SAVEDCONFIG_PATH}" ; \
		then
eerror
eerror "Missing define BM_ADD and/or keybindings.  Copy the define/keybindings"
eerror "into your savedconfig file (${SAVEDCONFIG_PATH}).  See"
eerror "https://surf.suckless.org/files/simple_bookmarking_redux/ for details."
eerror
			die
		fi
	fi

	if use mod_adblock ; then
		eapply "${FILESDIR}"/${PN}-9999-adblock.patch
		if ! grep -q -F -e "PAGE_LOAD_COMMITTED" \
			"${SAVEDCONFIG_PATH}" ; then
eerror
eerror "Please copy the following mod_adblock code fragment to your"
eerror "savedconfig (${SAVEDCONFIG_PATH}):"
eerror "---------- cut below ----------"
cat "${FILESDIR}/surf-9999-adblock-header-notes.txt" || die
eerror "---------- cut above ----------"
eerror
			die
		fi
	fi

	if use mod_searchengines ; then
einfo "${SEARCHENGINES_FN} patch may break.  Will triage immediately."
		patch -p1 -i "${DISTDIR}/${SEARCHENGINES_FN}"
		eapply "${FILESDIR}/surf-9999-webkit2-searchengines-compat.patch"

		if ! grep -q -F -e "static SearchEngine searchengines[]" \
			"${SAVEDCONFIG_PATH}" ; then
eerror
eerror "You are missing a searchengines array in your savedconfig"
eerror "(${SAVEDCONFIG_PATH}).  For details see"
eerror "https://surf.suckless.org/patches/searchengines/"
eerror
			die
		else
ewarn
ewarn "If you commented out \"static SearchEngine searchengines[]\","
ewarn "uncommented it out in your savedconfig to fix build."
ewarn
		fi
		if ! grep -q -F -e "BM_PICK }," \
			"${SAVEDCONFIG_PATH}" ; then
eerror
eerror "Please copy the following mod_searchengine code fragment to your"
eerror "savedconfig hotkeys array (static Key keys[] in ${SAVEDCONFIG_PATH}):"
eerror "---------- cut below ----------"
cat "${FILESDIR}/surf-9999-search-engine-notes.txt" || die
eerror "---------- cut above ----------"
eerror
			die
		fi
	else
		if test -f "${SAVEDCONFIG_PATH}" \
			&& grep -q -F -e "static SearchEngine searchengines[]" \
			"${SAVEDCONFIG_PATH}" ; then
ewarn
ewarn "Detected static SearchEngine searchengines[].  Comment or remove the"
ewarn "array out from your savedconfig (${SAVEDCONFIG_PATH}) or it will not"
ewarn "build."
ewarn
		fi
	fi

	restore_config config.h

	local config_file="config.def.h"
	if use savedconfig ; then
		config_file="config.h"
	fi

	if grep -q -F \
-e '[AcceleratedCanvas]   =       { { .i = 1 },' "${config_file}"
	then
ewarn
ewarn "Using AcceleratedCanvas = 1 may likely crash WebKitGtk / surf when"
ewarn "using adblocker.  Disable it in your savedconfig (${SAVEDCONFIG_PATH})"
ewarn
	else
		if [[ ! -f "config.h" ]] ; then
			if use mod_adblock ; then
ewarn
ewarn "If you compiled webkit-gtk with accelerated-2d-canvas on by default, it"
ewarn "will likely crash surf.  Either recompile webkit-gtk without"
ewarn "accelerated-2d-canvas USE flag or do"
ewarn "\`cp ${S}/config.def.h ${SAVEDCONFIG_PATH}\` and change to:"
ewarn "[AcceleratedCanvas]   =       { { .i = 0 },     },"
ewarn
			fi
		fi
	fi

	local want_request_rework=0

	if use pulseaudio ; then
		want_request_rework=1
	else
ewarn
ewarn "Microphone support is disabled when the the pulseaudio USE flag is"
ewarn "disabled too."
ewarn
	fi

	if use v4l ; then
		want_request_rework=1
	fi

	if (( ${want_request_rework} == 1 )) ; then
		eapply "${FILESDIR}/surf-2.1-permission-requests-rework.patch"
	fi

	tc-export CC PKG_CONFIG

	touch NEWS AUTHORS ChangeLog

	multilib_copy_sources

	prepare_abi() {
		cd "${BUILD_DIR}" || die
		sed -i -e "s|\
LIBPREFIX = \$(PREFIX)/lib|\
LIBPREFIX = \$(PREFIX)/$(get_libdir)|g" \
			config.mk || die
	}

	multilib_foreach_abi prepare_abi

	local num_abis=$(multilib_get_enabled_abi_pairs | wc -l)
	if [[ "${num_abis}" != "1" ]] ; then
		die "You can only install for one ABI"
	fi
}

multilib_src_compile() {
	PKG_CONFIG="/usr/bin/$(get_abi_CHOST ${ABI})-pkg-config" \
	emake
}

multilib_src_install() {
	PKG_CONFIG="/usr/bin/$(get_abi_CHOST ${ABI})-pkg-config" \
	default

	save_config config.h

	if use v4l || use microphone ; then
		grep -q -e "AccessMicrophone" config.h \
		  && die "AccessMicrophone was replaced by AccessMediaStream"
		grep -q -e "AccessWebcam" config.h \
		  && die "AccessMicrophone was replaced by AccessMediaStream"
	fi

	dodoc LICENSE

	if use mod_adblock ; then
		cat "${FILESDIR}/adblock/README.md" \
			> "${T}/adblock-README.md"
		dodoc "${T}/adblock-README.md"
		insinto /etc/surf/scripts
		doins -r \
			"${FILESDIR}/adblock" \
			"${FILESDIR}/events"
		fperms 0755 /etc/surf/scripts/adblock/adblock.py
		fperms 0755 /etc/surf/scripts/adblock/convert.py
		fperms 0755 /etc/surf/scripts/adblock/update.sh
		fperms 0755 /etc/surf/scripts/events/page_load_committed.sh
		dodoc "${FILESDIR}/licenses/LICENSE.mod_adblock"
		if use mod_adblock_easylist ; then
			dodoc "${FILESDIR}/licenses/LICENSE.EasyList"
		else
			rm "${D}/etc/surf/scripts/adblock/LICENSE.EasyList" || die
			sed -i \
-e 's|https://raw.githubusercontent.com/Spam404/lists/master/adblock-list.txt||' \
			"${D}/etc/surf/scripts/adblock/update.sh" || die
		fi
                if use mod_adblock_spam404 ; then
                        dodoc "${FILESDIR}/licenses/LICENSE.Spam404"
		else
			rm "${D}/etc/surf/scripts/adblock/LICENSE.Spam404" || die
			sed -i \
-e 's|https://easylist-downloads.adblockplus.org/easylist.txt||' \
			"${D}/etc/surf/scripts/adblock/update.sh" || die
			sed -i \
-e 's|https://easylist-downloads.adblockplus.org/malwaredomains_full.txt||' \
			"${D}/etc/surf/scripts/adblock/update.sh" || die
                fi
	fi

	if use mod_autoopen ; then
		dodoc "${FILESDIR}/licenses/LICENSE.mod_autoopen"
	fi

	if use mod_link_hints ; then
		cp -a "${DISTDIR}/surf-9999-link-hints.diff" "${T}/script.js" \
			|| die
		insinto /usr/share/${PN}
		doins "${T}/script.js"
		dodoc "${FILESDIR}/licenses/LICENSE.mod_link_hints"
	fi

	if use mod_simple_bookmarking_redux ; then
		dodoc "${FILESDIR}/licenses/LICENSE.mod_simple_bookmarking_redux"
	fi

	if use mod_searchengines ; then
		dodoc "${FILESDIR}/licenses/LICENSE.mod_searchengines"
	fi
}

_update_adblock() {
	einfo "Updating adblock rules"
	cd /etc/surf/scripts/adblock || die
	./update.sh
	einfo "Done updating adblock rules"
}

src_install_all() {
	einfo "Ran src_install_all,"
	if use tabbed; then
		dobin surf-open.sh
	fi
}

pkg_postinst() {
	if use mod_link_hints ; then
einfo
einfo "If you want link hinting support copy /usr/share/${PN}/{script.js,style.css}"
einfo "to your /home/<USER>/.surf directory."
einfo
	fi

	if use mod_adblock ; then
einfo
einfo "You must update the adblock filters manually at"
einfo "/etc/surf/scripts/adblock/update.sh."
einfo "Make sure the current working directory is /etc/surf/scripts/adblock/"
einfo "before running it."
einfo
einfo "You may run \`emerge --config ${CATEGORY}/${PN}\` to update the adblock."
einfo
		if use update_adblock ; then
			_update_adblock
		else
einfo
einfo "No adblock rules will be installed."
einfo
		fi
	fi
}

pkg_config() {
	if use mod_adblock ; then
		_update_adblock
	fi
}

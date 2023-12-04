# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit flag-o-matic git-r3 multilib-minimal python-r1 toolchain-funcs

EGIT_BRANCH="surf-webkit2"
EGIT_COMMIT="30f5464eb11b96f740b124816cbcfa55f125cf53" # 2023-11-18 11:40
EGIT_REPO_URI="https://git.suckless.org/surf"
AUTOOPEN_FN="surf-0.3-autoopen.diff"
LINK_HINTS_FN="surf-9999-link-hints.diff"
SEARCHENGINES_FN="surf-git-20170323-webkit2-searchengines.diff"
SRC_URI="
	mod_autoopen? (
		${AUTOOPEN_FN}
	)
	mod_link_hints? (
		${LINK_HINTS_FN}
	)
	mod_searchengines? (
		${SEARCHENGINES_FN}
	)
"

DESCRIPTION="a simple web browser based on WebKit/GTK+"
HOMEPAGE="https://surf.suckless.org/"
LICENSE="
	MIT
	SURF
	mod_adblock? (
		CC-BY-NA-SA-3.0
		MIT
		SURF-MOD_ADBLOCKER
	)
        mod_adblock_easylist? (
		CC-BY-SA-3.0
		GPL-3+
		SURF-MOD_ADBLOCKER-EASYLIST
	)
        mod_adblock_spam404? (
		CC-BY-SA-4.0
		SURF-MOD_ADBLOCKER-SPAM404
	)
	mod_autoopen? (
		all-rights-reserved
	)
	mod_link_hints? (
		all-rights-reserved
	)
	mod_searchengines? (
		all-rights-reserved
	)
	mod_simple_bookmarking_redux? (
		all-rights-reserved
	)
"
KEYWORDS="
~alpha ~amd64 ~amd64-fbsd ~amd64-linux ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86
~x86-linux ~x86-macos
"
SLOT="0"
IUSE+="
${EXTERNAL_IUSE}
alsa curl doc gtk3 gtk4 +geolocation mod_adblock mod_adblock_spam404
mod_adblock_easylist mod_autoopen mod_link_hints mod_searchengines
mod_simple_bookmarking_redux mpv tabbed update_adblock plumb -pointer-lock
+pulseaudio savedconfig -smoothscrolling +url-bar +v4l +webgl
r1
"
REQUIRED_USE+="
	^^ (
		gtk3
		gtk4
	)
	alsa? (
		!pulseaudio
	)
	gtk4? (
		!mod_adblock
	)
	mod_adblock? (
		${PYTHON_REQUIRED_USE}
	)
	mod_adblock_easylist? (
		mod_adblock
	)
	mod_adblock_spam404? (
		mod_adblock
	)
	mod_searchengines? (
		savedconfig
	)
	mod_simple_bookmarking_redux? (
		savedconfig
	)
	pulseaudio? (
		!alsa
	)
	update_adblock? (
		mod_adblock
	)
"
SET_PROP_RDEPEND="
"

RDEPEND+="
	!sci-chemistry/surf
	>=x11-misc/dmenu-4.7
	app-shells/bash
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	sys-apps/grep
	x11-apps/xprop
	x11-libs/libX11[${MULTILIB_USEDEP}]
	alsa? (
		!media-plugins/gst-plugins-pulse
		media-libs/gst-plugins-base:1.0[alsa]
		media-plugins/gst-plugins-meta:1.0[-pulseaudio]
	)
	pulseaudio? (
		media-libs/gst-plugins-base:1.0[-alsa]
		media-plugins/gst-plugins-meta:1.0[pulseudio]
	)
	curl? (
		net-misc/curl[${MULTILIB_USEDEP}]
		x11-terms/st
	)
	gtk3? (
		|| (
			(
				app-crypt/gcr:0[gtk,${MULTILIB_USEDEP}]
				net-libs/webkit-gtk:4[${MULTILIB_USEDEP},alsa?,geolocation?,pulseaudio?,v4l?,webgl?,X]
				x11-libs/gtk+:3[${MULTILIB_USEDEP},X]
			)
			(
				app-crypt/gcr:0[gtk,${MULTILIB_USEDEP}]
				net-libs/webkit-gtk:4.1[${MULTILIB_USEDEP},alsa?,geolocation?,pulseaudio?,v4l?,webgl?,X]
				x11-libs/gtk+:3[${MULTILIB_USEDEP},X]
			)
		)
	)
	gtk4? (
		|| (
			(
				app-crypt/gcr:4[gtk,${MULTILIB_USEDEP}]
				gui-libs/gtk:4[X]
				net-libs/webkit-gtk:5[${MULTILIB_USEDEP},alsa?,geolocation?,pulseaudio?,v4l?,webgl?,X]
			)
			(
				app-crypt/gcr:4[gtk,${MULTILIB_USEDEP}]
				gui-libs/gtk:4[X]
				net-libs/webkit-gtk:6[${MULTILIB_USEDEP},alsa?,geolocation?,pulseaudio?,v4l?,webgl?,X]
			)
		)
	)
	mod_adblock? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/future[${PYTHON_USEDEP}]')
	)
	mpv? (
		media-video/mpv
	)
	plumb? (
		x11-misc/xdg-utils
	)
	tabbed? (
		x11-misc/tabbed
	)
	url-bar? (
		sys-apps/sed
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	virtual/pkgconfig
	update_adblock? (
		${PYTHON_DEPS}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2.1-gentoo.patch"
)
DOCS=( README )

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

check_geolocation() {
	if has_version "app-misc/geoclue" ; then
		if ! grep -q -e "submit-data=true" \
			"${EROOT}/etc/geoclue/geoclue.conf" ; then
ewarn
ewarn "${EROOT}/etc/geoclue/geoclue.conf should be changed to submit-data=true"
ewarn "to get GPS coordinates with the router's BSSID for non-mobile devices or"
ewarn "editing the [wifi] section to use another location service."
ewarn
		fi
	fi
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
	check_geolocation
}

check_savedconfig_path() {
	if [[ -z "${SAVEDCONFIG_PATH}" || ! -e "${SAVEDCONFIG_PATH}" ]] ; then
		SAVEDCONFIG_PATH="/etc/portage/savedconfig/www-client/${PN}-${PV}"
eerror
eerror "Please run"
eerror
eerror "  mkdir -p \"/etc/portage/savedconfig/www-client\""
eerror "  cp \"${S}/config.def.h\" \"${SAVEDCONFIG_PATH}\""
eerror
eerror
eerror "Also, make sure to define an environment variable SAVEDCONFIG_PATH."
eerror
eerror "Contents of /etc/portage/env/surf.conf:"
eerror
eerror "  SAVEDCONFIG_PATH=\"${SAVEDCONFIG_PATH}\""
eerror
eerror "Contents of /etc/portage/package.env:"
eerror
eerror "  ${CATEGORY}/${PN} surf.conf"
eerror
eerror
eerror "Also, make sure to enable the savedconfig USE flag."
eerror
		die
	fi
}

src_prepare() {
	default

	cd "${S}" || die

	grep -q -e "VERSION = $(ver_cut 1-2 ${PV})" "config.mk" || die "Bump version"

	if use savedconfig ; then
		check_savedconfig_path
	else
einfo
einfo "The default config.h assumes you have"
einfo
einfo "  net-misc/curl"
einfo "  x11-terms/st"
einfo
einfo "installed to support the download function.  Without those, downloads"
einfo "will fail (gracefully).  You can fix this by doing one of the following:"
einfo
einfo "  1) Installing these packages"
einfo "  2) Setting USE=savedconfig with changes to the savedconfig"
einfo
	fi

	if use mod_simple_bookmarking_redux ; then
		check_savedconfig_path
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
		check_savedconfig_path
		eapply "${FILESDIR}/${PN}-2.1_p20231118-adblock.patch"
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
		check_savedconfig_path
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
eerror
eerror "Detected static SearchEngine searchengines[].  Comment or remove the"
eerror "array out from your savedconfig (${SAVEDCONFIG_PATH}) or it will not"
eerror "build."
eerror
		fi
	fi

	if use savedconfig ; then
		cat "${SAVEDCONFIG_PATH}" > "config.h" || die # new
	fi

	local config_file="config.def.h"
	if use savedconfig ; then
		config_file="config.h"
	fi

	if ! use pulseaudio ; then
ewarn
ewarn "Microphone support is disabled when the the pulseaudio USE flag is"
ewarn "disabled too."
ewarn
	fi

	if use mod_adblock ; then
		eapply "${FILESDIR}/surf-2.1_p20231118-permission-requests-rework-v3-01.patch"
		eapply "${FILESDIR}/surf-2.1_p20231118-permission-requests-rework-v3-02.patch"
	else
		eapply "${FILESDIR}/surf-2.1_p20231118-permission-requests-rework-v3.patch"
	fi

	if use savedconfig ; then
		grep -q -e "AccessMicrophone" "${SAVEDCONFIG_PATH}" \
		  && die "AccessMicrophone was replaced by one row of AccessMediaStream in ${SAVEDCONFIG_PATH}"
		grep -q -e "AccessWebcam" "${SAVEDCONFIG_PATH}" \
		  && die "AccessWebcam was replaced by one row of AccessMediaStream in ${SAVEDCONFIG_PATH}"
	else
		einfo "Modding ${config_file}"
		grep -q -e "AccessMicrophone" "${config_file}" \
		  && die "AccessMicrophone was replaced by one row of AccessMediaStream in ${config_file}"
		grep -q -e "AccessWebcam" "${config_file}" \
		  && die "AccessWebcam was replaced by one row of AccessMediaStream in ${config_file}"
	fi

	if use savedconfig ; then
		if grep -q -e "AcceleratedCanvas" "${config_file}" ; then
eerror
eerror "The [AcceleratedCanvas] row was removed and is no longer supported in"
eerror "${SAVEDCONFIG_PATH}"
eerror
			die
		fi
	fi

	if use savedconfig ; then
		if grep -q -e "Plugins" "${config_file}" ; then
eerror
eerror "The [Plugins] and \".i = Plugins\" rows have been removed and are no"
eerror "longer supported in ${SAVEDCONFIG_PATH}"
eerror
			die
		fi
	fi

	if use savedconfig && use pointer-lock ; then
		if grep -q -e "GDK_KEY_Escape" "${config_file}" ; then
eerror
eerror "You must change GDK_KEY_Escape to another key (GDK_KEY_Pause) in order"
eerror "to release the pointer-lock properly in ${SAVEDCONFIG_PATH}"
eerror
			die
		fi
	elif ! use savedconfig && use pointer-lock ; then
		sed -i -e "s|GDK_KEY_Escape|GDK_KEY_Pause|g" \
			"${config_file}" || die
	fi

	local my_cppflags=""
	use geolocation && my_cppflags+=" -DUSE_GEOLOCATION"
	use pointer-lock && my_cppflags+=" -DUSE_POINTER_LOCK"
	use pulseaudio && my_cppflags+=" -DUSE_MICROPHONE"
	use v4l && my_cppflags+=" -DUSE_CAMERA"

	sed -i -e "s|CPPFLAGS =|CPPFLAGS = ${my_cppflags}|g" \
		config.mk || die

	tc-export CC PKG_CONFIG

	touch NEWS AUTHORS ChangeLog

	if use smoothscrolling ; then
		sed -i -e "s|\[SmoothScrolling\]     =       { { .i = [01] },     },|\[SmoothScrolling\]     =       { { .i = 1 },     },|g" "config.def.h" || die
		sed -i -e "s|\[SmoothScrolling\]     =       { { .i = [01] },     },|\[SmoothScrolling\]     =       { { .i = 1 },     },|g" "${config_file}" || die
	else
		sed -i -e "s|\[SmoothScrolling\]     =       { { .i = [01] },     },|\[SmoothScrolling\]     =       { { .i = 0 },     },|g" "config.def.h" || die
		sed -i -e "s|\[SmoothScrolling\]     =       { { .i = [01] },     },|\[SmoothScrolling\]     =       { { .i = 0 },     },|g" "${config_file}" || die
	fi

	if use webgl ; then
		sed -i -e "s|\[WebGL\]               =       { { .i = [01] },     },|\[WebGL\]               =       { { .i = 1 },     },|g" "config.def.h" || die
		sed -i -e "s|\[WebGL\]               =       { { .i = [01] },     },|\[WebGL\]               =       { { .i = 1 },     },|g" "${config_file}" || die
	else
		sed -i -e "s|\[WebGL\]               =       { { .i = [01] },     },|\[WebGL\]               =       { { .i = 0 },     },|g" "config.def.h" || die
		sed -i -e "s|\[WebGL\]               =       { { .i = [01] },     },|\[WebGL\]               =       { { .i = 0 },     },|g" "${config_file}" || die
	fi

	SURF_ZOOM_LEVEL=${SURF_ZOOM_LEVEL:-"1.2"} # Fix tiny wiki tables
	sed -E -i -e "s|\[ZoomLevel\]           =       \{ \{ .f = [.0-9]+ \},   \},|\[ZoomLevel\]           =       { { .f = ${SURF_ZOOM_LEVEL} },   },|g" "config.def.h" || die
	sed -E -i -e "s|\[ZoomLevel\]           =       \{ \{ .f = [.0-9]+ \},   \},|\[ZoomLevel\]           =       { { .f = ${SURF_ZOOM_LEVEL} },   },|g" "${config_file}" || die

	eapply "${FILESDIR}/surf-2.1_p20231118-gtk4.patch"

	if has_version "net-libs/webkit-gtk:6" && use gtk4 ; then
einfo "Switching to webkit-gtk:6"
		sed -i -e "s|webkit2gtk-4.0|webkitgtk-6.0|g" config.mk || die
		sed -i -e "s|webkit2gtk-web-extension-4.0|webkitgtk-web-extension-6.0|g" config.mk || die
		sed -i -e 's|gtk[+]-3.0|gtk4|g' config.mk || die
		sed -i -e 's|gcr-3|gcr-4|g' config.mk || die
		append-cflags -DWEBKIT_API_VERSION=0600
	elif has_version "net-libs/webkit-gtk:5" && use gtk4 ; then
einfo "Switching to webkit-gtk:5"
		sed -i -e "s|webkit2gtk-4.0|webkit2gtk-5.0|g" config.mk || die
		sed -i -e "s|webkit2gtk-web-extension-4.0|webkit2gtk-web-extension-5.0|g" config.mk || die
		sed -i -e 's|gtk[+]-3.0|gtk4|g' config.mk || die
		sed -i -e 's|gcr-3|gcr-4|g' config.mk || die
		append-cflags -DWEBKIT_API_VERSION=0500
	elif has_version "net-libs/webkit-gtk:4.1" && use gtk3 ; then
einfo "Switching to webkit-gtk:4.1"
		sed -i -e "s|webkit2gtk-4.0|webkit2gtk-4.1|g" config.mk || die
		sed -i -e "s|webkit2gtk-web-extension-4.0|webkit2gtk-web-extension-4.1|g" config.mk || die
		append-cflags -DWEBKIT_API_VERSION=0401
	else
		append-cflags -DWEBKIT_API_VERSION=0400
	fi

	if has_version "net-libs/webkit-gtk[gles2,wayland]" \
		|| has_version "net-libs/webkit-gtk[opengl,wayland]" ; then
		append-cflags -DWEBKIT_WPE=1
	fi

	multilib_copy_sources

	prepare_abi() {
		einfo "ABI=${ABI} prepare_abi"
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
	einfo "ABI=${ABI} multilib_src_compile"
	export PKG_CONFIG_LIBDIR="${ESYSROOT}/usr/$(get_libdir)/pkgconfig"
	export PKG_CONFIG="$(tc-getPKG_CONFIG)"
	export PKG_CONFIG_PATH="${ESYSROOT}/usr/share/pkgconfig"
	emake
}

multilib_src_install() {
	default

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
			rm "${ED}/etc/surf/scripts/adblock/LICENSE.EasyList" || die
			sed -i \
-e 's|https://raw.githubusercontent.com/Spam404/lists/master/adblock-list.txt||' \
			"${ED}/etc/surf/scripts/adblock/update.sh" || die
		fi
                if use mod_adblock_spam404 ; then
                        dodoc "${FILESDIR}/licenses/LICENSE.Spam404"
		else
			rm "${ED}/etc/surf/scripts/adblock/LICENSE.Spam404" || die
			sed -i \
-e 's|https://easylist-downloads.adblockplus.org/easylist.txt||' \
			"${ED}/etc/surf/scripts/adblock/update.sh" || die
			sed -i \
-e 's|https://easylist-downloads.adblockplus.org/malwaredomains_full.txt||' \
			"${ED}/etc/surf/scripts/adblock/update.sh" || die
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
		grep -q -r -e "GDK_b" \
&& die "GDK_b must be renamed to GDK_KEY_b in your config.h"
	fi

	if use mod_searchengines ; then
		dodoc "${FILESDIR}/licenses/LICENSE.mod_searchengines"
	fi
}

_update_adblock() {
	einfo "Updating adblock rules"
	cd "${EROOT}/etc/surf/scripts/adblock" || die
	./update.sh
	einfo "Done updating adblock rules"
}

multilib_src_install_all() {
	debug-print-function ${FUNCNAME} "${@}"
	use tabbed && dobin surf-open.sh
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
einfo
einfo "  ${EPREFIX}/etc/surf/scripts/adblock/update.sh."
einfo
einfo "Make sure the current working directory is"
einfo
einfo "  ${EPREFIX}/etc/surf/scripts/adblock/"
einfo
einfo "before running it."
einfo
einfo "You may run \`emerge --config ${CATEGORY}/${PN}\` to update adblock."
einfo
		if use update_adblock ; then
			_update_adblock
		else
einfo
einfo "No adblock rules will be installed."
einfo
		fi
	fi

	if use pointer-lock ; then
ewarn
ewarn "The pointer-lock feature may be currently bugged when in motion."
ewarn
		if ! use savedconfig ; then
ewarn
ewarn "The stop loading pages Esc key has been changed to the Pause key in"
ewarn "order for the pointer-lock to release properly."
ewarn

		fi
	fi

	if use gtk4 && use savedconfig ; then
ewarn
ewarn "You must change SETPROP in the header dropping -w \$1 from dmenu's arg"
ewarn "for URL bar or find compatibility and rebuild again.  See the"
ewarn "surf-2.1-gtk4.patch for details."
ewarn
	fi

	check_geolocation
}

pkg_config() {
	use mod_adblock && _update_adblock
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild, new-patches
# OILEDMACHINE-OVERLAY-TEST:  passed (webkit-gtk 2.42.2:4/37, 20231202)
# USE="gtk3 smoothscrolling -curl -doc -geolocation -gtk4 -mod_adblock
# -mod_adblock_easylist -mod_adblock_spam404 -mod_autoopen -mod_link_hints
# -mod_searchengines -mod_simple_bookmarking_redux -mpv -plumb -pointer-lock
# -pulseaudio -savedconfig -tabbed -update_adblock -url-bar -v4l"
# ABI_X86="(64) -32 (-x32)" PYTHON_TARGETS="python3_10 -python3_11"
# search engine(s):  passed
# video site(s):  passed
# wiki(s):  passed

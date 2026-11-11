# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For versioning, the ebuild does accept the 157.0 like in the ftp folder.
# See also https://ftp.mozilla.org/pub/firefox/releases/

MOZ_ESR=

MOZ_PV=${PV}
MOZ_PV_SUFFIX=
if [[ ${PV} =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi

if [[ -n ${MOZ_ESR} ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
	HOMEPAGE="https://www.firefox.com https://www.firefox.com/enterprise/"
	SLOT="esr"
else
	HOMEPAGE="https://www.firefox.com"
	SLOT="rapid"
fi

MOZ_PN="${PN%-bin}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

MITIGATION_DATE="Nov 10, 2026" # Official annoucement (advisories)
MITIGATION_LAST_UPDATE=1794287940 # From `date +%s -d "09-Nov-2026 21:19"` From ftp source code
MITIGATION_URI="https://www.mozilla.org/en-US/security/advisories/mfsa2026-125/"
VULNERABILITIES_FIXED=(
	# 160.0
	"CVE-2026-124852;IBC;"
	"CVE-2026-124853;IBC, SBE;"
	"CVE-2026-124854;PE;"
	"CVE-2026-124855;SBE;"
	"CVE-2026-124856;IBC;"
	"CVE-2026-124857;UAF;"
	"CVE-2026-124858;UAF;"
	"CVE-2026-124859;IBC, SBE;"
	"CVE-2026-124860;UAF;"
	"CVE-2026-124861;UAF, SBE;"
	"CVE-2026-124862;UAF;"
	"CVE-2026-124863;UAF;"
	"CVE-2026-124864;UAF, SBE;"
	"CVE-2026-124865;UAF;"
	"CVE-2026-124866;UAF;"
	"CVE-2026-124867;UAF;"
	"CVE-2026-124868;IBC;"
	"CVE-2026-124869;UAF;"
	"CVE-2026-124870;IBC;"
	"CVE-2026-124871;UAF;"
	"CVE-2026-124872;UAF;"
	"CVE-2026-124873;;"
	"CVE-2026-124874;SOPB, WBSPB;"
	"CVE-2026-124875;IBC;"
	"CVE-2026-124876;UAF;"
	"CVE-2026-124877;UAF;"
	"CVE-2026-124878;UAF;"
	"CVE-2026-124879;;"
	"CVE-2026-124880;UAF;"
	"CVE-2026-124881;UAF;"
	"CVE-2026-124882;UAF;"
	"CVE-2026-124883;UAF;"
	"CVE-2026-124884;UAF;"
	"CVE-2026-124885;UAF;"
	"CVE-2026-124886;;"
	"CVE-2026-124887;IBC;"
	"CVE-2026-124888;IBC;"
	"CVE-2026-124889;UAF;"
	"CVE-2026-124890;UAF;"
	"CVE-2026-124891;IBC;"
	"CVE-2026-124892;UAF;"
	"CVE-2026-124893;UAF;"
	"CVE-2026-124894;UAF;"
	"CVE-2026-124895;UAF;"
	"CVE-2026-124896;;"
	"CVE-2026-124897;UAF;"
	"CVE-2026-124898;UAF;"
	"CVE-2026-124899;UAF;"
	"CVE-2026-124900;UAF, SBE;"
	"CVE-2026-124901;;"
	"CVE-2026-124902;RC, SOPB, WBSPB;"
	"CVE-2026-124903;UAF, SBE;"
	"CVE-2026-124904;UAF;"
	"CVE-2026-124905;SBE;"
	"CVE-2026-124906;UAF;"
	"CVE-2026-124907;UAF, PE, SBE;"
	"CVE-2026-124908;UAF;"
	"CVE-2026-124909;ID;"
	"CVE-2026-124910;SB;"
	"CVE-2026-124911;CJ;"
	"CVE-2026-124912;;"
	"CVE-2026-124913;IOV;"
	"CVE-2026-124914;IOV;"
	"CVE-2026-124915;IBC;"
	"CVE-2026-124917;UAF, SBE;"
	"CVE-2026-124918;IBC, PE;"
	"CVE-2026-124919;UAF, PE;"
	"CVE-2026-124920;UM, ID;"
	"CVE-2026-124921;SBE;"
	"CVE-2026-124922;UAF;"
	"CVE-2026-124923;SBE;"
	"CVE-2026-124924;IBC;"
	"CVE-2026-124925;ID;"
	"CVE-2026-124926;IBC;"
	"CVE-2026-124927;IOV;"
	"CVE-2026-124928;SB;"
	"CVE-2026-124929;ID;"
	"CVE-2026-124930;ID;"
	"CVE-2026-124931;SOPB, WBSPB;"
	"CVE-2026-124932;UAF;"
	"CVE-2026-124933;SBE;"
	"CVE-2026-124934;;"
	"CVE-2026-124935;UB;"
	"CVE-2026-124936;;"
	"CVE-2026-124937;;"
	"CVE-2026-124938;SB;"
	"CVE-2026-124939;JITM;"
	"CVE-2026-124940;SB;"
	"CVE-2026-124941;ID;"
	"CVE-2026-124942;;"
	"CVE-2026-124943;UAF;"
	"CVE-2026-124944;ID;"
	"CVE-2026-124945;;"
	"CVE-2026-124946;;"
	"CVE-2026-124947;IBC;"
	"CVE-2026-124948;UAF, IBC;"
	"CVE-2026-124949;;"
	"CVE-2026-124950;SOPB, WBSPB;"
	"CVE-2026-124951;PE;"
)

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/glib-2.91.9999"
	"media-libs/alsa-lib-9999"
	"media-libs/fontconfig-9999"
	"media-libs/freetype-9999"
	"sys-apps/dbus-9999"
	"sys-libs/libselinux-9999"
	"x11-libs/cairo-9999"
	"x11-libs/gtk+-3.24.9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libXcursor-9999"
)

inherit chkl desktop linux-info optfeature pax-utils secure-version vf web-kernel-config xdg

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

SRC_URI="amd64? ( ${MOZ_SRC_BASE_URI}/linux-x86_64/en-US/${MOZ_P}.tar.xz -> ${PN}_x86_64-${PV}.tar.xz )
	arm64? ( ${MOZ_SRC_BASE_URI}/linux-aarch64/en-US/${MOZ_P}.tar.xz -> ${PN}_aarch64-${PV}.tar.xz )"

DESCRIPTION="Firefox Web Browser"

KEYWORDS="-* amd64 ~arm64"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="
apulse +gmp-autoupdate +libpulse selinux wayland
ebuild_revision_5
"
REQUIRED_USE="
	|| (
		apulse
		libpulse
	)
"

RESTRICT="strip mirror" # Speed up downloads and reduce snooping

BDEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	!www-client/firefox-bin:0
	$(secure-version_gen_ffmpeg_depends '4.0-8.1' '' 'single')
	>=app-accessibility/at-spi2-core-${AT_SPI2_CORE_PV}
	>=dev-libs/glib-${GLIB_PV}
	>=media-libs/alsa-lib-${ALSA_LIB_PV}
	>=media-libs/fontconfig-${FONTCONFIG_PV}
	>=media-libs/freetype-${FREETYPE_PV}
	>=sys-apps/dbus-${DBUS_PV}
	>=sys-libs/glibc-${GLIBC_PV}
	>=x11-libs/cairo-${CAIRO_PV}[X]
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}
	>=x11-libs/gtk+-${GTK3_PV}:3[X,wayland?]
	>=x11-libs/libX11-${LIBX11_PV}
	>=x11-libs/libXcursor-${LIBXCURSOR_PV}
	>=x11-libs/libXext-${LIBXEXT_PV}
	>=x11-libs/libXfixes-${LIBXFIXES_PV}
	>=x11-libs/libXi-${LIBXI_PV}
	>=x11-libs/libXrandr-${LIBXRANDR_PV}
	>=x11-libs/libXrender-${LIBXRENDER_PV}
	>=x11-libs/libxcb-${LIBXCB_PV}
	>=x11-libs/pango-${PANGO_PV}
	sys-kernel/secure-kernel:*
	virtual/freedesktop-icon-theme
	x11-libs/libXcomposite
	x11-libs/libXdamage
	apulse? (
		>=media-libs/libpulse-${LIBPULSE_PV}
	)
	libpulse? (
		media-sound/apulse
	)
	selinux? (
		sec-policy/selinux-mozilla:*
	)
"

# ESR and rapid dependencies.
if [[ -n ${MOZ_ESR} ]] ; then
	RDEPEND+=" !www-client/firefox-bin:rapid"
else
	RDEPEND+=" !www-client/firefox-bin:esr"
fi

QA_PREBUILT="opt/${MOZ_PN}/*"

# Allow MOZ_GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z "${MOZ_GMP_PLUGIN_LIST+set}" ]] ; then
	MOZ_GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

MOZ_LANGS=(
	ach af an ar ast az be bg bn br bs ca-valencia ca cak cs cy
	da de dsb el en-CA en-GB en-US eo es-AR es-CL es-ES es-MX et eu
	fa ff fi fr fy-NL ga-IE gd gl gn gu-IN he hi-IN hr hsb hu hy-AM
	ia id is it ja ka kab kk km kn ko lij lt lv mk mr ms my
	nb-NO ne-NP nl nn-NO oc pa-IN pl pt-BR pt-PT rm ro ru sco
	si sk skr sl son sq sr sv-SE ta te th tl tr trs uk ur uz vi
	xh zh-CN zh-TW
)

mozilla_set_globals() {
	# https://bugs.gentoo.org/587334
	local MOZ_TOO_REGIONALIZED_FOR_L10N=(
		fy-NL ga-IE gu-IN hi-IN hy-AM nb-NO ne-NP nn-NO pa-IN sv-SE
	)

	local lang xflag
	for lang in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${lang} == en ]] || [[ ${lang} == en-US ]] ; then
			continue
		fi

		# strip region subtag if $lang is in the list
		if has ${lang} "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			xflag=${lang%%-*}
		else
			xflag=${lang}
		fi

		SRC_URI+=" l10n_${xflag/[_@]/-}? ("
		SRC_URI+=" ${MOZ_SRC_BASE_URI}/linux-x86_64/xpi/${lang}.xpi -> ${MOZ_P_DISTFILES}-${lang}.xpi"
		SRC_URI+=" )"
		IUSE+=" l10n_${xflag/[_@]/-}"
	done
}
mozilla_set_globals

moz_install_xpi() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local DESTDIR=${1}
	shift

	insinto "${DESTDIR}"

	local emid xpi_file xpi_tmp_dir
	for xpi_file in "${@}" ; do
		emid=
		xpi_tmp_dir=$(mktemp -d --tmpdir="${T}")

		# Unpack XPI
		unzip -qq "${xpi_file}" -d "${xpi_tmp_dir}" || die

		# Determine extension ID
		if [[ -f "${xpi_tmp_dir}/install.rdf" ]] ; then
			emid=$(sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' "${xpi_tmp_dir}/install.rdf")
			[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
		elif [[ -f "${xpi_tmp_dir}/manifest.json" ]] ; then
			emid=$(sed -n -e 's/.*"id": "\([^"]*\)".*/\1/p' "${xpi_tmp_dir}/manifest.json")
			[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
		else
			die "failed to determine extension id"
		fi

		einfo "Installing ${emid}.xpi into ${ED}${DESTDIR} ..."
		newins "${xpi_file}" "${emid}.xpi"
	done
}

pkg_setup() {
	CONFIG_CHECK="~SECCOMP"
	WARNING_SECCOMP="CONFIG_SECCOMP not set! This system will be unable to play DRM-protected content."

	linux-info_pkg_setup
	web-kernel-config_setup

	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security fixes applied:  ${MITIGATION_URI}"
	fi
	vf_show
}

src_unpack() {
	local _lp_dir="${WORKDIR}/language_packs"
	local _src_file

	mkdir "${S}" || die

	if [[ ! -d "${_lp_dir}" ]] ; then
		mkdir "${_lp_dir}" || die
	fi

	for _src_file in ${A} ; do
		if [[ ${_src_file} == *.xpi ]]; then
			cp "${DISTDIR}/${_src_file}" "${_lp_dir}" || die "Failed to copy '${_src_file}' to '${_lp_dir}'!"
		else
			MY_SRC_FILE=${_src_file}
		fi
	done
}

src_configure() {
	chkl_check_many_timestamps
}

src_install() {
	# Set MOZILLA_FIVE_HOME
	local MOZILLA_FIVE_HOME="/opt/${MOZ_PN}"

	dodir /opt
	pushd "${ED}"/opt &>/dev/null || die
	unpack "${MY_SRC_FILE}"
	popd &>/dev/null || die

	pax-mark m \
		"${ED}${MOZILLA_FIVE_HOME}"/${MOZ_PN} \
		"${ED}${MOZILLA_FIVE_HOME}"/${MOZ_PN}-bin \
		"${ED}${MOZILLA_FIVE_HOME}"/plugin-container

	# Prevent auto-updater from popping up.
	echo "This installation is managed by Gentoo's package manager." > "${ED}${MOZILLA_FIVE_HOME}"/is-packaged-app

	# Install system-wide preferences
	local PREFS_DIR="${MOZILLA_FIVE_HOME}/browser/defaults/preferences"
	insinto "${PREFS_DIR}"
	newins "${FILESDIR}"/gentoo-default-prefs.js all-gentoo.js

	local GENTOO_PREFS="${ED}${PREFS_DIR}/all-gentoo.js"

	if ! use gmp-autoupdate ; then
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
			einfo "Disabling auto-update for ${plugin} plugin ..."
			cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to disable autoupdate for ${plugin} media plugin"
			pref("media.${plugin}.autoupdate",   false);
			EOF
		done
	fi

	# Install language packs
	local langpacks=( $(find "${WORKDIR}/language_packs" -type f -name '*.xpi') )
	if [[ -n "${langpacks}" ]] ; then
		moz_install_xpi "${MOZILLA_FIVE_HOME}/distribution/extensions" "${langpacks[@]}"
	fi

	# Install icons
	local icon_srcdir="${ED}/${MOZILLA_FIVE_HOME}/browser/chrome/icons/default"
	local icon_symbolic_file="${FILESDIR}/firefox-symbolic.svg"

	insinto /usr/share/icons/hicolor/symbolic/apps
	newins "${icon_symbolic_file}" ${PN}-symbolic.svg

	local icon size
	for icon in "${icon_srcdir}"/default*.png ; do
		size=${icon%.png}
		size=${size##*/default}

		if [[ ${size} -eq 48 ]] ; then
			newicon "${icon}" ${PN}.png
		fi

		newicon -s ${size} "${icon}" ${PN}.png
	done

	# Install menu
	local app_name="Mozilla ${MOZ_PN^} (bin)"
	local desktop_file="${FILESDIR}/${PN}-r3.desktop"
	local desktop_filename="${PN}.desktop"
	local exec_command="${PN} --name=firefox-bin"
	local icon="${PN}"
	local use_wayland="false"

	if use wayland ; then
		use_wayland="true"
	fi

	cp "${desktop_file}" "${WORKDIR}/${PN}.desktop-template" || die

	# Add apulse support through our wrapper shell launcher, patchelf-method broken since 119.0.
	# See bgo#916230, bgo#941873
	local apulselib=
	if has_version -r media-sound/apulse[-sdk] ; then
		apulselib="${EPREFIX}/usr/$(get_libdir)/apulse"
		ewarn "media-sound/apulse with -sdk use flag detected!"
		ewarn "Firefox-bin will be installed with a wrapper, that attempts to load"
		ewarn "apulse instead of pipewire/pulseadio. This may lead to sound issues."
		ewarn "Please either enable sdk use flag for apulse, or remove apulse"
		ewarn "completely and re-install firefox-bin to utilize pipewire/pulseaudio instead."
	fi

	sed -i \
		-e "s:@NAME@:${app_name}:" \
		-e "s:@EXEC@:${exec_command}:" \
		-e "s:@ICON@:${icon}:" \
		"${WORKDIR}/${PN}.desktop-template" \
		|| die

	newmenu "${WORKDIR}/${PN}.desktop-template" "${desktop_filename}"

	rm "${WORKDIR}/${PN}.desktop-template" || die

	# Install wrapper script
	[[ -f "${ED}/usr/bin/${PN}" ]] && rm "${ED}/usr/bin/${PN}"
	newbin "${FILESDIR}/${PN}-r1.sh" ${PN}

	# Update wrapper
	sed -i \
		-e "s:@PREFIX@:${EPREFIX}/usr:" \
		-e "s:@MOZ_FIVE_HOME@:${EPREFIX}${MOZILLA_FIVE_HOME}:" \
		-e "s:@APULSELIB_DIR@:${apulselib}:" \
		-e "s:@DEFAULT_WAYLAND@:${use_wayland}:" \
		"${ED}/usr/bin/${PN}" \
		|| die
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use gmp-autoupdate ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
			elog "\t ${plugin}"
		done
		elog
	fi

	local show_doh_information show_normandy_information

	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		# New install; Tell user that DoH is disabled by default
		show_doh_information=yes
		show_normandy_information=yes
	fi

	if [[ -n "${show_doh_information}" ]] ; then
		elog
		elog "Note regarding Trusted Recursive Resolver aka DNS-over-HTTPS (DoH):"
		elog "Due to privacy concerns (encrypting DNS might be a good thing, sending all"
		elog "DNS traffic to Cloudflare by default is not a good idea and applications"
		elog "should respect OS configured settings), \"network.trr.mode\" was set to 5"
		elog "(\"Off by choice\") by default."
		elog "You can enable DNS-over-HTTPS in ${PN^}'s preferences."
	fi

	# bug 713782
	if [[ -n "${show_normandy_information}" ]] ; then
		elog
		elog "Upstream operates a service named Normandy which allows Mozilla to"
		elog "push changes for default settings or even install new add-ons remotely."
		elog "While this can be useful to address problems like 'Armagadd-on 2.0' or"
		elog "revert previous decisions to disable TLS 1.0/1.1, privacy and security"
		elog "concerns prevail, which is why we have switched off the use of this"
		elog "service by default."
		elog
		elog "To re-enable this service set"
		elog
		elog "    app.normandy.enabled=true"
		elog
		elog "in about:config."
	fi

	optfeature_header "Optional programs for extra features:"
	optfeature "speech syntesis (text-to-speech) support" app-accessibility/speech-dispatcher
	optfeature "fallback mouse cursor theme e.g. on WMs" gnome-base/gsettings-desktop-schemas
	# optfeature "ffmpeg-based audio/video codec support, required for HTML5 video rendering" media-video/ffmpeg
	optfeature "desktop notifications" x11-libs/libnotify
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 152.0.6 (interactive, 20260714)

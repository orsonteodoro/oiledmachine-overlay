# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit desktop python-any-r1 webapp xdg

DESCRIPTION="HTML5 client for Xpra"
HOMEPAGE="https://github.com/Xpra-org/xpra-html5"
LICENSE="
	MPL-2.0
	Apache-2.0
	all-rights-reserved
	BSD
	CC-BY-SA-3.0
	GPL-2
	LGPL-2.1+
	LGPL-3+
	MIT
"
# MIT and GPL-2 - html5/js/lib/jquery.ba-throttle-debounce.js
# BSD MIT all-rights-reserved ^^ ( BSD GPL-2 ) - html5/js/lib/forge.js *
# Apache 2.0 - html5/js/lib/AudioContextMonkeyPatch.js
# LGPL-2.1+ - html5/js/lib/aurora/flac.js.map
# LGPL-3+ - html5/js/lib/aurora/aac.js
# || ( MIT GPL-2 ) - html5/js/lib/jszip.js
#
# *Contains a modified MIT license with all rights reserved.
# The plain MIT license does not come with all rights reserved.

KEYWORDS="~amd64 ~x86"
IUSE+=" +brotli +gzip httpd menu-only local minify"
REQUIRED_USE+="
	^^ (
		httpd
		local
		menu-only
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	x11-themes/gnome-backgrounds
	httpd? (
		virtual/httpd-basic
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	gzip? (
		app-arch/gzip
	)
	brotli? (
		app-arch/brotli
	)
	minify? (
		dev-util/uglifyjs
	)
"
PDEPEND+="
	>=x11-wm/xpra-5
"
SRC_URI="
https://github.com/Xpra-org/xpra-html5/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
RESTRICT="mirror"
LOCAL_INSTALL_URI="file:///usr/share/xpra/www/index.html"

pkg_setup()
{
	webapp_pkg_setup
	python-any-r1_pkg_setup

	if ( use menu-only || use httpd ) \
	&& [[ -z "${XPRA_HTML5_BROWSER}" && -z "${XPRA_HTML5_PROTO}" \
		&& -z "${XPRA_HTML5_SERVER}" && -z "${XPRA_HTML5_PORT}" ]] ; then
eerror
eerror "You must set XPRA_HTML5_BROWSER, XPRA_HTML5_PROTO, XPRA_HTML5_SERVER,"
eerror "XPRA_HTML5_PORT to able to be able to set the browser path for a"
eerror "desktop menu entry.  See \`epkginfo -x www-apps/xpra-html5\` for"
eerror "details."
eerror
		die
	fi

	if use local \
	[[ -z "${XPRA_HTML5_BROWSER}" ]] ; then
ewarn
ewarn "Setting XPRA_HTML5_BROWSER as a per-package environmental variable"
ewarn "containing the browser path is recommended for a desktop menu entry."
ewarn "See \`epkginfo -x www-apps/xpra-html5\` for details."
ewarn
	fi
}

src_install() {
	local minifier=""
	if use minify ; then
		minifier="uglifyjs"
	fi

	if use httpd ; then
		webapp_src_preinst

		if [[ -z "${MY_HTDOCSDIR}" ]] ; then
			die "MY_HTDOCSDIR must be set"
		fi

		einfo "${EPYTHON} ./setup.py install \"${D}/${MY_HTDOCSDIR}\" ${minifier}"
		${EPYTHON} ./setup.py install "${D}/${MY_HTDOCSDIR}" ${minifier}

		webapp_serverowned -R "${MY_HTDOCSDIR}"
		webapp_src_install
	elif use local ; then
		dodir /usr/share/xpra/html5
#		einfo "${EPYTHON} ./setup.py install \"${D}/usr/share/xpra/html5\" ${minifier}"
#		${EPYTHON} ./setup.py install "${D}/usr/share/xpra/html5" ${minifier}

		einfo "${EPYTHON} ./setup.py install \"${D}\" ${minifier}"
		${EPYTHON} ./setup.py install "${D}" ${minifier}
	fi

	if ( use httpd || use menu-only ) \
	&& [[ -n "${XPRA_HTML5_BROWSER}" && -n "${XPRA_HTML5_PROTO}" \
		&& -n "${XPRA_HTML5_SERVER}" && -n "${XPRA_HTML5_PORT}" ]] ; then
		local iconp="${MY_HTDOCSDIR}/favicon.png"
		if use menu-only ; then
			iconp=""
		fi

einfo
einfo "Adding menu for ${PN} using ${XPRA_HTML5_BROWSER} with"
einfo "http://${XPRA_HTML5_SERVER}:${XPRA_HTML5_PORT}"
einfo

		make_desktop_entry \
			"${XPRA_HTML5_BROWSER} ${XPRA_HTML5_PROTO}://${XPRA_HTML5_SERVER}:${XPRA_HTML5_PORT}" \
			"${PN}" \
			"${iconp}" \
			"Network;VideoConference"
	elif use local && [[ -n "${XPRA_HTML5_BROWSER}" ]] ; then
		einfo "Adding menu for ${PN} using ${XPRA_HTML5_BROWSER}"
		make_desktop_entry \
			"${XPRA_HTML5_BROWSER} ${LOCAL_INSTALL_URI}" \
			"${PN}" \
			"/usr/share/xpra/html5/favicon.png" \
			"Network;VideoConference"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
einfo
einfo "${PN} requires xpra to be installed."
einfo
einfo "To configure, see:"
einfo "See https://github.com/Xpra-org/xpra-html5/tree/v4.1.2#configuration"
einfo
	if use httpd || use menu-only ; then
einfo
einfo "To use the browser only client, you enter for the URI:"
einfo "${XPRA_HTML5_PROTO}://${XPRA_HTML5_SERVER}:${XPRA_HTML5_PORT}"
einfo
	elif use local ; then
einfo
einfo "To use the browser only client, you enter for the URI:"
einfo "${LOCAL_INSTALL_URI}"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

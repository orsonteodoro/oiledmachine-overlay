# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit desktop python-r1 xdg

DESCRIPTION="HTML5 client for Xpra"
HOMEPAGE="https://github.com/Xpra-org/xpra-html5"
LICENSE="MPL-2.0
	Apache-2.0
	all-rights-reserved
	BSD
	GPL-2
	LGPL-2.1+
	LGPL-3+
	MIT"
# MIT and GPL-2 - html5/js/lib/jquery.ba-throttle-debounce.js
# BSD MIT all-rights-reserved ^^ ( BSD GPL-2 ) - html5/js/lib/forge.js *
# Apache 2.0 - html5/js/lib/AudioContextMonkeyPatch.js
# LGPL-2.1+ html5/js/lib/aurora/flac.js.map
# LGPL-3+ html5/js/lib/aurora/aac.js
# || ( MIT GPL-2 ) - html5/js/lib/jszip.js
#
# *Contains a modified MIT license with all rights reserved and retaining notice clauses \
# the plain MIT license does not come with all rights reserved.
# ^^ (MIT GPL-3)  html5/js/lib/jszip.js
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE+=" +brotli +gzip minify"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
SLOT="0/${PV}"
#RDEPEND+=" x11-wm/xpra" # avoid circular
BDEPEND+=" ${PYTHON_DEPS}
	gzip? ( app-arch/gzip )
	brotli? ( app-arch/brotli  )
	minify? ( dev-util/uglifyjs )"
SRC_URI="https://github.com/Xpra-org/xpra-html5/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
RESTRICT="mirror"

pkg_setup()
{
	python_setup
}

src_install() {
	dodir /usr/share/xpra

	local minifier=""
	if use minify ; then
		minifier="uglifyjs"
	fi

	einfo "${EPYTHON} ./setup.py install \"${D}/usr/share/xpra/html5\" ${minifier}"
	${EPYTHON} ./setup.py install "${D}/usr/share/xpra/html5" ${minifier}

	if [[ -n "${XPRA_HTML5_BROWSER}" ]] ; then
		einfo "Adding menu for ${PN} using ${XPRA_HTML5_BROWSER}"
		make_desktop_entry \
			"${XPRA_HTML5_BROWSER} file:///usr/share/xpra/html5/index.html" \
			"${PN}" \
			"/usr/share/xpra/html5/favicon.png" \
			"Network;VideoConference"
	else
		ewarn "Setting XPRA_HTML5_BROWSER as a per-package envvar containing the browser path is recommended for a desktop menu entry."
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "${PN} requires xpra to be installed."
	einfo
	einfo "To configure, see:"
	einfo "See https://github.com/Xpra-org/xpra-html5/tree/v4.1.2#configuration"
	einfo
	einfo "To use the browser only client, you enter for the URI:"
	einfo "file:///usr/share/xpra/html5/index.html"
}

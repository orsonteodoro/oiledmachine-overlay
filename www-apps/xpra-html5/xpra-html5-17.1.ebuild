# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LOCAL_INSTALL_URI="file:///usr/share/xpra/www/index.html"
PYTHON_COMPAT=( python3_{8..11} )
WEBAPP_MANUAL_SLOT="yes"

inherit desktop python-any-r1 webapp xdg

KEYWORDS="~amd64 ~x86"
SRC_URI="
https://github.com/Xpra-org/xpra-html5/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

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

RESTRICT="mirror"
SLOT="0"
IUSE+=" apache +brotli +gzip local menu-only minify ssl"
REQUIRED_USE+="
	^^ (
		apache
		local
		menu-only
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	x11-themes/gnome-backgrounds
	apache? (
		>=www-servers/apache-2.4.57:2[apache2_modules_env,apache2_modules_log_config,ssl?]
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

pkg_setup()
{
	webapp_pkg_setup
	python-any-r1_pkg_setup

	if ( use menu-only || use apache ) \
		&& \
	[[ \
		   -z "${XPRA_HTML5_BROWSER}" \
		&& -z "${XPRA_HTML5_SERVER}" \
		&& -z "${XPRA_HTML5_PORT}" \
	]] ; then
eerror
eerror "You must set XPRA_HTML5_BROWSER, XPRA_HTML5_SERVER, XPRA_HTML5_PORT to"
eerror "able to be able to set the browser path for a desktop menu entry.  See"
eerror "\`epkginfo -x www-apps/xpra-html5\` for details."
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

gen_apache_conf_with_ssl() {
einfo "MY_HTDOCSDIR:  ${MY_HTDOCSDIR}"
einfo "MY_HTDOCSDIR_VHOST:  ${MY_HTDOCSDIR_VHOST}"
#  MY_HTDOCSDIR:  /usr/share/webapps//xpra/11.2/htdocs
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_xpra-2.4.conf" # Apache 2.4
Define APACHE_LOG_DIR /var/log/apache2

Listen ${XPRA_HTML5_PORT}

<VirtualHost *:${XPRA_HTML5_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        SSLEngine on
        SSLProtocol ALL -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        SSLHonorCipherOrder Off
        SSLCertificateFile /etc/ssl/apache2/server.crt
        SSLCertificateKeyFile /etc/ssl/apache2/server.key

        <Directory "/var/www/${XPRA_HTML5_SERVER}/htdocs/xpra-html5/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_xpra-2.4.conf"
}

gen_apache_conf_without_ssl() {
einfo "MY_HTDOCSDIR:  ${MY_HTDOCSDIR}"
einfo "MY_HTDOCSDIR_VHOST:  ${MY_HTDOCSDIR_VHOST}"
#  MY_HTDOCSDIR:  /usr/share/webapps//xpra/11.2/htdocs
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_xpra-2.4.conf" # Apache 2.4
Define APACHE_LOG_DIR /var/log/apache2

Listen ${XPRA_HTML5_PORT}

<VirtualHost *:${XPRA_HTML5_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/${XPRA_HTML5_SERVER}/htdocs/xpra-html5/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_xpra-2.4.conf"
}

src_install() {
	local minifier=""
	if use minify ; then
		minifier="uglifyjs"
	fi

	if use apache ; then
		webapp_src_preinst

		if [[ -z "${MY_HTDOCSDIR}" ]] ; then
			die "MY_HTDOCSDIR must be set"
		fi

		# See https://github.com/Xpra-org/xpra-html5/blob/v11.2/setup.py#L551
einfo
einfo "D: ${D}"
einfo "MY_HTDOCSDIR:  ${MY_HTDOCSDIR}"
einfo "Minifier:  ${minifier}"
einfo
einfo "${EPYTHON} ./setup.py install \"${D}/${MY_HTDOCSDIR}\" \"${D}/${MY_HTDOCSDIR}\" ${minifier}"
		${EPYTHON} ./setup.py install \
			"${D}" \
			"${MY_HTDOCSDIR}" \
			${minifier}

		webapp_serverowned -R "${MY_HTDOCSDIR}"

		if use vhosts ; then
			_VHOST_ROOT="/var/www/${HASHTOPOLIS_ADDRESS}"
		else
			_VHOST_ROOT="${VHOST_ROOT}"
		fi
		MY_HTDOCSDIR_VHOST="${_VHOST_ROOT}/htdocs/xpra-html5"

		if use ssl ; then
			gen_apache_conf_with_ssl
		else
			gen_apache_conf_without_ssl
		fi

		fowners apache:apache "/etc/apache2/vhosts.d/40_xpra-2.4.conf"
		fperms 0600 "/etc/apache2/vhosts.d/40_xpra-2.4.conf"

		webapp_src_install
	elif use local ; then
		dodir /usr/share/xpra/html5
#einfo "${EPYTHON} ./setup.py install \"${D}/usr/share/xpra/html5\" ${minifier}"
#		${EPYTHON} ./setup.py install "${D}/usr/share/xpra/html5" ${minifier}

einfo "${EPYTHON} ./setup.py install \"${D}\" ${minifier}"
		${EPYTHON} ./setup.py install "${D}" ${minifier}
	fi

	if ( use apache || use menu-only ) \
	&& [[ \
		   -n "${XPRA_HTML5_BROWSER}" \
		&& -n "${XPRA_HTML5_SERVER}" \
		&& -n "${XPRA_HTML5_PORT}" \
	]] ; then
		local iconp="${MY_HTDOCSDIR}/favicon.png"
		if use menu-only ; then
			iconp=""
		fi
einfo
einfo "Adding menu for ${PN} using ${XPRA_HTML5_BROWSER} with"
einfo "http://${XPRA_HTML5_SERVER}:${XPRA_HTML5_PORT}"
einfo
		local proto=$(usex ssl "https" "http")
		make_desktop_entry \
			"${XPRA_HTML5_BROWSER} ${proto}://${XPRA_HTML5_SERVER}:${XPRA_HTML5_PORT}" \
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
	local proto=$(usex ssl "https" "http")
	if use apache ; then
		webapp_pkg_postinst
ewarn "The apache2 server must be restarted."
	fi
	xdg_pkg_postinst
einfo
einfo "${PN} requires xpra to be installed."
einfo
einfo "To configure, see:"
einfo
einfo "  https://github.com/Xpra-org/xpra-html5/tree/v4.1.2#configuration"
einfo
	if use apache || use menu-only ; then
einfo
einfo "To use the browser only client, you enter for the URI:"
einfo "${proto}://${XPRA_HTML5_SERVER}:${XPRA_HTML5_PORT}"
einfo
	elif use local ; then
einfo
einfo "To use the browser only client, you enter for the URI:"
einfo "${LOCAL_INSTALL_URI}"
einfo
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERAY-TEST:  PASSED (11.2, 20240315)
# USE="apache ssl -local" - passed
# USE="apache -ssl -local" - passed
# USE="-apache -ssl local" - passed

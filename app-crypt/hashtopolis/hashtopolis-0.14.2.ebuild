# Copyrgiht 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To generate lockfiles do:
# PATH="${OILEDMACHINE_OVERLAY_PATH}/scripts:${PATH}"
# NPM_UPDATER_PROJECT_ROOT="web-ui-0.14.2" NPM_UPDATER_VERSIONS="0.14.2" npm_updater_update_locks.sh

ANGULAR_SUPPORT=0
HASTOPOLIS_WEBUI_PV="${PV}"
MY_ETCDIR="/etc/webapps/${PF}"
NODE_SLOT="18"
NPM_AUDIT_FIX=1
PYTHON_COMPAT=( "python3_"{10..11} )
WEBAPP_MANUAL_SLOT="yes"

NPM_AUDIT_FIX_ARGS=(
	"--prefer-offline"
)

NPM_INSTALL_ARGS=(
	"--prefer-offline"
)

if [[ "${ANGULAR_SUPPORT}" == "1" ]] ; then
	inherit npm
fi
inherit lcnr webapp

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/server-9999"
	S_WEBUI="${WORKDIR}/web-ui-9999"
else
	KEYWORDS="~amd64" # Unfinished
	S="${WORKDIR}/server-${PV}"
	S_WEBUI="${WORKDIR}/web-ui-${HASTOPOLIS_WEBUI_PV}"
	SRC_URI="
https://github.com/hashtopolis/server/archive/v${PV}.tar.gz -> hashtopolis-server-${PV}.tar.gz
	"
	if [[ "${ANGULAR_SUPPORT}" == "1" ]] ; then
		SRC_URI+="
			angular? (
https://github.com/hashtopolis/web-ui/archive/refs/tags/v${HASTOPOLIS_WEBUI_PV}.tar.gz
	-> hashtopolis-webui-${HASTOPOLIS_WEBUI_PV}.tar.gz
			)
		"
	fi
fi

DESCRIPTION="Hashtopolis is a Hashcat wrapper for distributed password recovery"
HOMEPAGE="https://github.com/hashtopolis/server"
WEB_UI_NODE_MODULES_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	(
		CC-BY-4.0
		MIT
		OFL-1.1
	)
	(
		CC-BY-4.0
		MIT
		Unicode-DFS-2016
		W3C-Community-Final-Specification-Agreement
		W3C-Software-and-Document-Notice-and-License
	)
	(
		Apache-2.0
		BSD
		custom
		public-domain
	)
	(
		custom
		MIT
	)
	0BSD
	Apache-2.0
	BSD
	BSD-2
	CC0-1.0
	CC-BY-4.0
	CC-BY-3.0
	custom
	ISC
	MIT
	PSF-2.2
	Unlicense
	|| (
		Apache-2.0
		MIT
	)
	|| (
		Apache-2.0
		MPL-2.0
	)
	|| (
		BSD
		GPL-2
	)
	|| (
		GPL-3
		MIT
	)
"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		GPL-2+
	)
	CC-BY-4.0
	BSD
	MIT
	OFL-1.1
"
if [[ "${ANGULAR_SUPPORT}" == "1" ]] ; then
	THIRD_PARTY_LICENSES+="
		angular? (
			${WEB_UI_NODE_MODULES_LICENSES}
			(
				CC-BY-4.0
				MIT
			)
			0BSD
			Apache-2.0
			BSD
			CC0-1.0
			CC-BY-4.0
			GPL-3
			MIT
			OFL-1.1
		)
	"
fi
# The PSF-2.2 is similar to PSF-2.4 but shorter list
# static/7zr.bin - All Rights Reserved, GPL-2+
# web-ui-0.14.2/node_modules/@angular/localize/node_modules/convert-source-map/LICENSE - all-rights-reserved MIT
# web-ui-0.14.2/node_modules/atob/LICENSE || ( Apache-2.0 MIT )
# web-ui-0.14.2/node_modules/atob/LICENSE.DOCS - CC-BY-3.0
# web-ui-0.14.2/node_modules/caniuse-lite/LICENSE - CC-BY-4.0
# web-ui-0.14.2/node_modules/dompurify/LICENSE || ( Apache-2.0 MPL-2.0 )
# web-ui-0.14.2/node_modules/@fortawesome/fontawesome-common-types/LICENSE.txt - custom
# web-ui-0.14.2/node_modules/@fortawesome/fontawesome-free-regular/LICENSE.txt - CC-BY-4.0 MIT OFL-1.1
# web-ui-0.14.2/node_modules/@fortawesome/fontawesome/LICENSE.txt - custom
# web-ui-0.14.2/node_modules/fs-monkey/LICENSE - Unlicense
# web-ui-0.14.2/node_modules/hashtype-detector/LICENSE - GPL-3
# web-ui-0.14.2/node_modules/jackspeak/LICENSE.md - custom "Blue Oak Model License" 1.0.0
# web-ui-0.14.2/node_modules/jsbn/LICENSE - custom ( MIT + retain copyright notice )
# web-ui-0.14.2/node_modules/jszip/lib/license_header.js - || ( GPL-3 MIT )
# web-ui-0.14.2/node_modules/jszip/LICENSE.markdown - || ( GPL-3 MIT )
# web-ui-0.14.2/node_modules/node-forge/LICENSE - || ( BSD GPL-2 )
# web-ui-0.14.2/node_modules/reflect-metadata/CopyrightNotice.txt - Apache-2.0 all-rights-reserved
# web-ui-0.14.2/node_modules/thrift/LICENSE - custom Apache-2.0 BSD public-domain
# web-ui-0.14.2/node_modules/typescript/ThirdPartyNoticeText.txt - CC-BY-4.0 MIT Unicode-DFS-2016 W3C-Community-Final-Specification-Agreement W3C-Software-and-Document-Notice-and-License
LICENSE="
	${THIRD_PARTY_LICENSES}
	GPL-3
"
RESTRICT="test"
SLOT="0"
IUSE+=" agent ssl"
if [[ "${ANGULAR_SUPPORT}" == "1" ]] ; then
	# angular support is broken
	IUSE+=" angular"
fi
# apache optional: apache2_modules_env, apache2_modules_log_config
RDEPEND="
	>=dev-lang/php-8.3.3:8.3[apache2,curl,filter,gd,mysql,pdo,session,simplexml,ssl,xmlwriter]
	>=dev-php/composer-2.7.1
	>=dev-vcs/git-2.43.0
	>=net-misc/curl-7.88.1
	>=www-servers/apache-2.4.57:2[apache2_modules_env,apache2_modules_log_config,ssl?]
	dev-php/pear
	virtual/mysql
"
DEPEND="
	${RDEPEND}
	>=app-arch/unzip-6.0
"
if [[ "${ANGULAR_SUPPORT}" == "1" ]] ; then
	BDEPEND+="
		angular? (
			>=net-libs/nodejs-18.15:${NODE_SLOT}
			net-libs/nodejs:=
		)
	"
fi
PDEPEND="
	agent? (
		>=app-crypt/hashtopolis-python-agent-0.7.1
	)
"
PATCHES=(
)

check_php_support_in_apache() {
	if has_version "www-servers/apache" ; then
		if ! grep -q -e "APACHE2_OPTS.*-D PHP" /etc/conf.d/apache2 ; then
ewarn "Apache is not configured for PHP.  Add \"-D PHP\" to APACHE2_OPTS in /etc/conf.d/apache2"
		fi
	fi
}

pkg_setup() {
	check_php_support_in_apache
	webapp_pkg_setup
	if has "angular" ${IUSE} && use angular ; then
ewarn "The angular USE flag is currently broken."
		npm_pkg_setup
	fi
}

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${WORKDIR}/server-9999"
		EGIT_REPO_URI="https://github.com/hashtopolis/server.git"
		use fallback-commit && EGIT_COMMIT="375f2ce022c4b3e0780abf9dcca1e6af8e966c1a"
		git-r3_fetch
		git-r3_checkout

		EGIT_BRANCH="master"
		EGIT_CHECKOUT_DIR="${WORKDIR}/web-ui-9999"
		EGIT_REPO_URI="https://github.com/hashtopolis/web-ui.git"
		use fallback-commit && EGIT_COMMIT="4c9b30888fd1b1e48c469afc4884d0e427e22122"
		git-r3_fetch
		git-r3_checkout
	else
		unpack "hashtopolis-server-${PV}.tar.gz"
		if has "angular" ${IUSE} && use angular ; then
			unpack "hashtopolis-webui-${HASTOPOLIS_WEBUI_PV}.tar.gz"
		fi
	fi

	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		:
	else
		cd "${S}" || die
		composer install \
			--working-dir="${S}" \
			|| die
	fi

	if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
		if has "angular" ${IUSE} ; then
			if use angular ; then
				:
			else
eerror "Enable the angular USE flag before updating lockfile"
				die
			fi
		fi
	fi

	if has "angular" ${IUSE} && use angular ; then
		npm_hydrate
		cd "${S_WEBUI}" || die
		if [[ -n "${NPM_UPDATE_LOCK}" ]] ; then
			mkdir -p "${WORKDIR}/lockfile-image" || die
			local lockfile
			local lockfiles=(
				"package-lock.json"
			)
# Reduce version constraints caused by lockfiles.
			rm -vf "${lockfiles[@]}"

einfo "Running \`npm install ${NPM_INSTALL_ARGS[@]}\` per package-lock.json"
			for lockfile in "${lockfiles[@]}" ; do
				local d="$(dirname ${lockfile})"
				pushd "${S_WEBUI}/${d}" || die
					if [[ "${NPM_AUDIT_FIX}" == "1" ]] ; then
						enpm install ${NPM_INSTALL_ARGS[@]}
					fi
				popd
			done

einfo "Running \`npm audit fix ${NPM_AUDIT_FIX_ARGS[@]}\` per package-lock.json"
			if [[ "${NPM_AUDIT_FIX}" == "1" ]] ; then
				for lockfile in "${lockfiles[@]}" ; do
					local d="$(dirname ${lockfile})"
					pushd "${S_WEBUI}/${d}" || die
						enpm audit fix "${NPM_AUDIT_FIX_ARGS[@]}"
					popd
				done
			fi

einfo "Copying lockfiles"
			lockfiles_disabled=(
	# Disabled to prevent too many args for wget in relation to SRC_URI.
				$(find . -name "package-lock.json")
			)
			for lockfile in "${lockfiles[@]}" ; do
				local d="$(dirname ${lockfile})"
				local dest="${WORKDIR}/lockfile-image/${d}"
				mkdir -p "${dest}"
einfo "${d}/package.json -> ${dest}"
				cp -a "${d}/package.json" "${dest}"
einfo "${d}/package-lock.json -> ${dest}"
				cp -a "${d}/package-lock.json" "${dest}"
			done

einfo "Lockfile update done"
			exit 0
		else
			_npm_cp_tarballs
			if [[ -e "${FILESDIR}/${PV}" ]] ; then
				cp -aT "${FILESDIR}/${PV}" "${S_WEBUI}" || die
			fi
			npm_hydrate
			local offline=${NPM_OFFLINE:-2}
			if [[ "${offline}" == "1" ]] ; then
				enpm install \
					--offline \
					"${NPM_INSTALL_ARGS[@]}"
			elif [[ "${offline}" == "1" ]] ; then
				enpm install \
					--prefer-offline \
					"${NPM_INSTALL_ARGS[@]}"
			else
				enpm install \
					"${NPM_INSTALL_ARGS[@]}"
			fi
			# Audit fix already done in NPM_UPDATE_LOCK=1
		fi
	fi
}

set_vhost_angular_config_with_ssl() {
#  MY_HTDOCSDIR:  /usr/share/webapps//hashtopolis/0.14.2/htdocs
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf" # Apache 2.4
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}
Listen ${HASHTOPOLIS_FRONTEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        SSLEngine on
        SSLProtocol ALL -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        SSLHonorCipherOrder Off
        SSLCertificateFile /etc/ssl/apache2/server.crt
        SSLCertificateKeyFile /etc/ssl/apache2/server.key

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>

<VirtualHost *:${HASHTOPOLIS_FRONTEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-frontend"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        SSLEngine on
        SSLProtocol ALL -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        SSLHonorCipherOrder Off
        SSLCertificateFile /etc/ssl/apache2/server.crt
        SSLCertificateKeyFile /etc/ssl/apache2/server.key

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-frontend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}

set_vhost_angular_config_without_ssl() {
#  MY_HTDOCSDIR:  /usr/share/webapps//hashtopolis/0.14.2/htdocs
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf" # Apache 2.4
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}
Listen ${HASHTOPOLIS_FRONTEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>

<VirtualHost *:${HASHTOPOLIS_FRONTEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-frontend"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-frontend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}

set_vhost_angularless_config_with_ssl() {
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf"
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        SSLEngine on
        SSLProtocol ALL -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        SSLHonorCipherOrder Off
        SSLCertificateFile /etc/ssl/apache2/server.crt
        SSLCertificateKeyFile /etc/ssl/apache2/server.key

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}

set_vhost_angularless_config_without_ssl() {
	insinto "/etc/apache2/vhosts.d"
cat <<EOF > "${T}/40_hashtopolis-2.4.conf"
Define APACHE_LOG_DIR /var/log/apache2

Listen ${HASHTOPOLIS_BACKEND_PORT}

# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend"

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/${HASHTOPOLIS_ADDRESS}/htdocs/hashtopolis/hashtopolis-backend/">
            AllowOverride All
            Require all granted
        </Directory>
</VirtualHost>
EOF
	doins "${T}/40_hashtopolis-2.4.conf"
}


set_server_config() {
	local HASHTOPOLIS_ADDRESS=${HASHTOPOLIS_ADDRESS:-"localhost"}
	local HASHTOPOLIS_BACKEND_PORT=${HASHTOPOLIS_BACKEND_PORT:-8080}
	local HASHTOPOLIS_FRONTEND_PORT=${HASHTOPOLIS_FRONTEND_PORT:-4200}

	if use vhosts ; then
		_VHOST_ROOT="/var/www/${HASHTOPOLIS_ADDRESS}"
	else
		_VHOST_ROOT="${VHOST_ROOT}"
	fi
	MY_HTDOCSDIR_VHOST="${_VHOST_ROOT}/htdocs/hashtopolis"
	MY_HTDOCSDIR_VHOST_BACKEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
	MY_HTDOCSDIR_VHOST_FRONTEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
einfo "MY_HTDOCSDIR_VHOST:  ${MY_HTDOCSDIR_VHOST}"
einfo "MY_HTDOCSDIR_VHOST_BACKEND:  ${MY_HTDOCSDIR_VHOST_BACKEND}"
einfo "MY_HTDOCSDIR_VHOST_FRONTEND:  ${MY_HTDOCSDIR_VHOST_FRONTEND}"

	if has angular ${IUSE} && use angular ; then
		cd "${S_WEBUI}" || die
		sed -i \
			-e 's/localhost:8080/${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/g' \
			"src/config/default/app/main.ts" \
			|| die

		if use ssl ; then
			set_vhost_angular_config_with_ssl
		else
			set_vhost_angular_config_without_ssl
		fi

		if use ssl ; then
			export HASHTOPOLIS_BACKEND_URL="https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/api/v2"
		else
			export HASHTOPOLIS_BACKEND_URL="http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/api/v2"
		fi
		envsubst \
			< "${S_WEBUI}/dist/assets/config.json.example" \
			> "${S_WEBUI}/dist/assets/config.json" \
			|| die
	else
		if use ssl ; then
			set_vhost_angularless_config_with_ssl
		else
			set_vhost_angularless_config_without_ssl
		fi
	fi

#	sed -i -e "30d" "src/inc/confv2.php" || die
#	sed -i -e "30i \"files\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/files\"," "src/inc/confv2.php" || die

#	sed -i -e "31d" "src/inc/confv2.php" || die
#	sed -i -e "31i \"import\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/import\"," "src/inc/confv2.php" || die

#	sed -i -e "31d" "src/inc/confv2.php" || die
#	sed -i -e "31i \"log\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/log\"," "src/inc/confv2.php" || die

#	sed -i -e "31d" "src/inc/confv2.php" || die
#	sed -i -e "31i \"config\" => \"${MY_HTDOCSDIR}/hashtopolis-backend/config\"," "src/inc/confv2.php" || die
}

src_compile() {
	if has "angular" ${IUSE} && use angular ; then
		cd "${S_WEBUI}" || die

	# Avoid fatal: not a git repository
		git init || die
		touch "dummy" || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		git add dummy || die
		git commit -m "Dummy" || die
		git tag "v${PV}" || die

		npm_hydrate
		enpm run build

		# Prevent blank page
		sed -i -e "s| type=\"module\"||g" "dist/index.html" || die
	fi
	grep -F -e " ng: command not found" "${T}/build.log" && die "Detected error.  Try again."
}

src_install() {
	webapp_src_preinst

	cd "${S}" || die
	set_server_config
	cd "${S}" || die
	insinto "${MY_HTDOCSDIR}/hashtopolis-backend"
	doins -r "src/"*

	if has "angular" ${IUSE} && use angular ; then
		pushd "${S_WEBUI}" || die
			insinto "${MY_HTDOCSDIR}/hashtopolis-frontend"
			doins -r dist/*
		popd
	fi

	chown -R root:root "${ED}${MY_HTDOCSDIR}/"

	fowners apache:apache "/etc/apache2/vhosts.d/40_hashtopolis-2.4.conf"
	fperms 0600 "/etc/apache2/vhosts.d/40_hashtopolis-2.4.conf"

	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/files"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/import"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/log"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/config"

	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/files/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/import/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/log/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/config/"

	# Ownership apache:apache required for login:
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/files/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/inc/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/inc/Encryption.class.php"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/inc/load.php"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/install/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/lang/"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/templates/"

	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/files"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/import"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/log"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/config"

	# TODO: fix permissions for admin to work

	webapp_hook_script "${FILESDIR}/permissions"

	dosym \
		"${MY_ETCDIR}/backend/php/inc/conf.php" \
		"${MY_HTDOCSDIR}/hashtopolis-backend/inc/conf.php"

	if has "angular" ${IUSE} && use angular ; then
		LCNR_SOURCE="${S_WEBUI}"
		LCNR_TAG="web-ui-node_modules-third-party-licenses"
		lcnr_install_files
	fi

	LCNR_SOURCE="${S}/vendor"
	LCNR_TAG="composer-third-party-licenses"
	lcnr_install_files

	webapp_src_install
}

print_usage() {
	local HASHTOPOLIS_ADDRESS=${HASHTOPOLIS_ADDRESS:-"localhost"}
	local HASHTOPOLIS_BACKEND_PORT=${HASHTOPOLIS_BACKEND_PORT:-8080}
	local HASHTOPOLIS_FRONTEND_PORT=${HASHTOPOLIS_FRONTEND_PORT:-4200}
	if has angular ${IUSE} && use angular ; then
einfo
		if use ssl ; then
einfo "To add an admin, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access the backend, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
einfo "To access the frontend, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_FRONTEND_PORT}"
		else
einfo "To add an admin, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access the backend, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
einfo "To access the frontend, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_FRONTEND_PORT}"
		fi
einfo
	else
einfo
		if use ssl ; then
einfo "To add an admin, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access, use https://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
		else
einfo "To add an admin, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/install"
einfo "To access, use http://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
		fi
einfo
	fi
ewarn
ewarn "Use user admin and password hashtopolis to enter http[s]://${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}"
ewarn "You must change the password it or delete the account."
ewarn
ewarn
ewarn "When you are done setting up admin(s), delete the install folder."
ewarn
}

pkg_postinst() {
ewarn "Run \`emerge =hashtopolis-server-${PV} --config\` to complete installation."
	webapp_pkg_postinst
	print_usage
}

# See https://www.gentoo.org/glep/glep-0011.html
pkg_config() {
	if ! pgrep "mysqld" >/dev/null 2>&1 && ! pgrep "mariadbd" >/dev/null 2>&1 ; then
eerror
eerror "A SQL server has not been started!  Start it first!"
eerror
eerror "For OpenRC:  /etc/init.d/mysql restart"
eerror "For systemd:  systemctl restart mysqld.service"
eerror
		die
	fi
	check_php_support_in_apache

	if use vhosts ; then
		_VHOST_ROOT="/var/www/${HASHTOPOLIS_ADDRESS}"
	else
		_VHOST_ROOT="${VHOST_ROOT}"
	fi
	MY_HTDOCSDIR_VHOST="${_VHOST_ROOT}/htdocs/hashtopolis"
	MY_HTDOCSDIR_VHOST_BACKEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
	MY_HTDOCSDIR_VHOST_FRONTEND="${_VHOST_ROOT}/htdocs/hashtopolis/hashtopolis-backend"
einfo "MY_HTDOCSDIR_VHOST:  ${MY_HTDOCSDIR_VHOST}"
einfo "MY_HTDOCSDIR_VHOST_BACKEND:  ${MY_HTDOCSDIR_VHOST_BACKEND}"
einfo "MY_HTDOCSDIR_VHOST_FRONTEND:  ${MY_HTDOCSDIR_VHOST_FRONTEND}"

	if [[ ! -e "/etc/hashtopolis/server/salt" ]] ; then
		mkdir -p "/etc/hashtopolis/server"
		local password_salt=$(dd bs=4096 count=1 if="/dev/random" of="/dev/stdout" 2>/dev/null | sha256sum | base64 -w 0)
		echo "${password_salt}" > "/etc/hashtopolis/server/salt" || die
		chmod 0600 "/etc/hashtopolis/server/salt" || die
	fi

einfo "Enter a new password for the user hastopolis for SQL access:"
	read -s hashtopolis_password
	local hashtopolis_password_=$(echo -n "${hashtopolis_password}:$(cat /etc/hashtopolis/server/salt)" | sha256sum | cut -f 1 -d " ")
	hashtopolis_password=$(dd bs=4096 count=1 if="/dev/random" of="/dev/stdout" 2>/dev/null | base64)

einfo "Clean install hashtopolis database and user? [Y/n]"
	read
	if [[ "${REPLY^^}" == "Y" || -z "${REPLY}" ]] ; then
einfo "Creating database and non-root user hashtopolis with SQL server and database user root..."
mysql -h "127.0.0.1" -u root -p <<EOF
DROP DATABASE IF EXISTS hashtopolis;
DROP USER IF EXISTS 'hashtopolis'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE hashtopolis;
CREATE USER 'hashtopolis'@'localhost' IDENTIFIED BY "${hashtopolis_password_}";
GRANT ALL PRIVILEGES ON hashtopolis.* TO 'hashtopolis'@'localhost' WITH GRANT OPTION;
EOF
	fi

einfo "Creating ${MY_ETCDIR}/backend/php/inc/conf.php"
	mkdir -p "${MY_ETCDIR}/backend/php/inc/"
	SQL_PORT=${SQL_PORT:-3306}
cat <<EOF > "${MY_ETCDIR}/backend/php/inc/conf.php"
<?php
//START CONFIG
\$CONN['user'] = 'hashtopolis';
\$CONN['pass'] = "${hashtopolis_password_}";
\$CONN['server'] = 'localhost';
\$CONN['db'] = 'hashtopolis';
\$CONN['port'] = "${SQL_PORT}";
//END CONFIG
EOF
	hashtopolis_password_=$(dd bs=4096 count=1 if="/dev/random" of="/dev/stdout" 2>/dev/null | base64)

#einfo "Enter a new admin password for the Admin GUI:"
#	read -s hashtopolis_admin_password
#	HASHTOPOLIS_ADMIN_PASSWORD="${hashtopolis_admin_password}"

einfo "Protecting sensitive config"
	chown "apache:apache" "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend/inc/load.php" || die
	chown "apache:apache" "${MY_ETCDIR}/backend/php/inc/conf.php"
	chmod 0600 "${MY_ETCDIR}/backend/php/inc/conf.php"

info "Creating user admin and configuring database"
	php -f "${MY_HTDOCSDIR_VHOST}/hashtopolis-backend/inc/load.php" || die

	hashtopolis_admin_password=$(dd bs=4096 count=1 if="/dev/random" of="/dev/stdout" 2>/dev/null | base64)

ewarn "The apache2 server must be restarted."
	print_usage
}

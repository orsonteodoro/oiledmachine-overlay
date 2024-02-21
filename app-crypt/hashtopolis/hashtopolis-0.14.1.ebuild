# Copyrgiht 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 )
HASTOPOLIS_WEBUI_PV="0.14.1"
MY_ETCDIR="/etc/webapps/${PF}"
NODE_VERSION=18
WEBAPP_MANUAL_SLOT="yes"

inherit npm webapp

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashtopolis/server.git"
else
#	KEYWORDS="~amd64" # Unfinished
	SRC_URI="
https://github.com/hashtopolis/server/archive/v${PV}.tar.gz -> hashtopolis-server-${PV}.tar.gz
		angular? (
https://github.com/hashtopolis/web-ui/archive/refs/tags/v${HASTOPOLIS_WEBUI_PV}.tar.gz
	-> hashtopolis-webui-${HASTOPOLIS_WEBUI_PV}.tar.gz
		)
	"
fi
S="${WORKDIR}/server-${PV}"
S_WEBUI="${WORKDIR}/web-ui-${HASTOPOLIS_WEBUI_PV}"

DESCRIPTION="Hashtopolis - A Hashcat wrapper for distributed password recovery"
HOMEPAGE="https://github.com/hashtopolis/server"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		GPL-2+
	)
	CC-BY-4.0
	MIT
	OFL-1.1
	angular? (
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
# static/7zr.bin - All Rights Reserved, GPL-2+
LICENSE="
	${THIRD_PARTY_LICENSES}
	GPL-3
"
SLOT="0"
IUSE="angular"
RESTRICT="test"
RDEPEND="
	>=www-servers/apache-2.4.57:2
	>=dev-vcs/git-2.43.0
	>=net-misc/curl-7.88.1
	>=dev-lang/php-8.3.2:8.3[apache2,curl,filter,gd,mysql,pdo,session,simplexml,ssl,xmlwriter]
	>=dev-php/composer-2.7.1
	dev-php/pear
	virtual/mysql
"
DEPEND="
	${RDEPEND}
	>=app-arch/unzip-6.0
"
BDEPEND="
	angular? (
		>=net-libs/nodejs-18.15:18
	)
"
PATCHES=(
)

check_network_sandbox() {
	# For composer/npm
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
}

check_php_support_in_apache() {
	if has_version "www-servers/apache" ; then
		if ! grep -q -e "APACHE2_OPTS.*-D PHP" /etc/conf.d/apache2 ; then
ewarn "Apache is not configured for PHP.  Add \"-D PHP\" to APACHE2_OPTS in /etc/conf.d/apache2"
		fi
	fi
}

pkg_setup() {
	check_network_sandbox
	check_php_support_in_apache
	webapp_pkg_setup
	if use angular ; then
		npm_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}" || die
	composer install \
		--working-dir="${S}" \
		|| die

	if use angular ; then
		cd "${S_WEBUI}" || die
		npm_hydrate
		enpm install
	fi
}

set_server_config() {
	HASHTOPOLIS_ADDRESS=${HASHTOPOLIS_ADDRESS:-"127.0.0.1"}
	HASHTOPOLIS_BACKEND_PORT=${HASHTOPOLIS_BACKEND_PORT:-8080}
	HASHTOPOLIS_FRONTEND_PORT=${HASHTOPOLIS_BACKEND_PORT:-4200}
	if use angular ; then
		cd "${S_WEBUI}" || die
		sed -i \
			-e 's/localhost:8080/${HASHTOPOLIS_ADDRESS}:${HASHTOPOLIS_BACKEND_PORT}/g' \
			src/config/default/app/main.ts \
			|| die

		keepdir "${MY_ETCDIR}/apache"
cat <<EOF > "${ED}${MY_ETCDIR}/apache/000-default.conf"
# IMPORTANT, if you don't set the HASHTOPOLIS_APIV2_ENABLE environment variable in the config. The APIv2 will not be enabled!
<VirtualHost *:${HASHTOPOLIS_BACKEND_PORT}>

        ServerAdmin webmaster@localhost
        DocumentRoot ${MY_HTDOCSDIR}/hashtopolis-backend

        SetEnv HASHTOPOLIS_APIV2_ENABLE 1

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory "/var/www/hashtopolis-backend/">
            AllowOverride All
        </Directory>
</VirtualHost>

<VirtualHost *:${HASHTOPOLIS_FRONTEND_PORT}>
        ServerAdmin webmaster@localhost
        DocumentRoot ${MY_HTDOCSDIR}/hashtopolis-frontend

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF
cat <<EOF > "${ED}${MY_ETCDIR}/frontend/apache/ports.conf"
Listen ${HASHTOPOLIS_BACKEND_PORT}
Listen ${HASHTOPOLIS_FRONTEND_PORT}
EOF
	else
		keepdir "${MY_ETCDIR}/apache"
cat <<EOF > "${ED}${MY_ETCDIR}/apache/000-default.conf"
DocumentRoot ${MY_HTDOCSDIR}/hashtopolis-backend
EOF
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
	if use angular ; then
		cd "${S_WEBUI}" || die
		npm_hydrate
		enpm run build
	fi
}

src_install() {
	webapp_src_preinst

	cd "${S}" || die

	set_server_config
	insinto "${MY_HTDOCSDIR}/hashtopolis-backend"
einfo "MY_HTDOCSDIR:  ${MY_HTDOCSDIR}"
	doins -r src/*

	if use angular ; then
		cd "${S_WEBUI}" || die
		insinto "${MY_HTDOCSDIR}/hashtopolis-frontend"
		doins -r dist/*
	fi

	chown -R root:root "${ED}${MY_HTDOCSDIR}/"

	if use angular ; then
		fowners root:root "${MY_ETCDIR}/apache/000-default.conf"
		fowners root:root "${MY_ETCDIR}/apache/ports.conf"
		fperms 0600 "${MY_ETCDIR}/apache/000-default.conf"
		fperms 0600 "${MY_ETCDIR}/apache/ports.conf"
	else
		fowners root:root "${MY_ETCDIR}/apache/000-default.conf"
		fperms 0600 "${MY_ETCDIR}/apache/000-default.conf"
	fi

	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/files"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/import"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/log"
	keepdir "${MY_HTDOCSDIR}/hashtopolis-backend/config"

	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/files"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/import"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/log"
	webapp_serverowned "${MY_HTDOCSDIR}/hashtopolis-backend/config"

	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/files"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/import"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/log"
	fperms 0662 "${MY_HTDOCSDIR}/hashtopolis-backend/config"

	# TODO: fix permissions for admin to work

	webapp_hook_script "${FILESDIR}/permissions"

	dosym \
		"${MY_ETCDIR}/backend/php/inc/conf.php" \
		"${MY_HTDOCSDIR}/hashtopolis-backend/inc/conf.php"

	webapp_src_install
}

print_usage() {
einfo
einfo "To add an admin, use http[s]://localhost/hashtopolis/hashtopolis-backend/install/index.php"
einfo "To access, use http[s]://localhost/hashtopolis/hashtopolis-backend"
einfo
ewarn
ewarn "When you are done setting up admin(s), delete the install folder."
ewarn
}

pkg_postinst() {
ewarn "Run \`emerge =hashtopolis-server-0.14.1 --config\` to complete installation."
	webapp_pkg_postinst
	print_usage
}

# See https://www.gentoo.org/glep/glep-0011.html
pkg_config() {
	if [[ ! -e "/etc/hashtopolis/server/salt" ]] ; then
		mkdir -p "/etc/hashtopolis/server"
		local password_salt=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | sha256sum | base64 -w 0)
		echo "${password_salt}" > "/etc/hashtopolis/server/salt" || die
		chmod 0600 "/etc/hashtopolis/server/salt" || die
	fi

einfo "Enter a new password for the user hastopolis for SQL access:"
	read -s hashtopolis_password
	local hashtopolis_password_=$(echo -n "${hashtopolis_password}:$(cat /etc/hashtopolis/server/salt)" | sha256sum | cut -f 1 -d " ")
	hashtopolis_password=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)

einfo "Do a fresh install and create Hashtopolis database? [Y/n]"
	read
	if [[ "${REPLY^^}" == "Y" || -z "${REPLY}" ]] ; then
		einfo "Creating database and user hashtopolis with SQL server with user root..."
mysql -h "127.0.0.1" -u root -p <<EOF
DROP DATABASE IF EXISTS hashtopolis;
DROP USER IF EXISTS 'hashtopolis'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE hashtopolis;
CREATE USER 'hashtopolis'@'localhost' IDENTIFIED BY "${hashtopolis_password_}";
GRANT ALL PRIVILEGES ON hashtopolis.* TO 'hashtopolis'@'localhost' WITH GRANT OPTION;
EOF
	fi
einfo "Done new db"

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
	hashtopolis_password_=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)

#einfo "Enter a new admin password for the Admin GUI:"
#	read -s hashtopolis_admin_password
#	HASHTOPOLIS_ADMIN_PASSWORD="${hashtopolis_admin_password}"

einfo "Protecting sensitive config"
	chown apache:apache "${MY_HTDOCSDIR}/hashtopolis-backend/inc/load.php" || die
	chown apache:apache "${MY_ETCDIR}/backend/php/inc/conf.php"
	chmod 0600 "${MY_ETCDIR}/backend/php/inc/conf.php"

einfo "Running load.php"
	php -f "${MY_HTDOCSDIR}/hashtopolis-backend/inc/load.php" || die

	hashtopolis_admin_password=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)

ewarn "The apache2 server must be restarted."
	print_usage
}

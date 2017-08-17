# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

#WANT_AUTOMAKE="1.11"

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils eutils flag-o-matic systemd user versionator wxwidgets python-single-r1 versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="http://boinc.ssl.berkeley.edu/"
SRC_URI="https://github.com/BOINC/boinc/archive/client_release/${MY_PV}/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="stripchart fastcgi mysql mysql-cluster mariadb mariadb-galera ldap debug examples mod_fcgid mod_fastcgi extras wrapper"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="
	virtual/cron
        dev-python/mysql-python
         ${PYTHON_DEPS}
	!sci-misc/boinc-bin
	!app-admin/quickswitch
	>=app-misc/ca-certificates-20080809
	dev-libs/openssl:0=
	net-misc/curl[ssl,-gnutls(-),-nss(-),curl_ssl_openssl(+)]
	sys-apps/util-linux
	sys-libs/zlib
        media-libs/gd[jpeg,png]
        dev-lang/php[cli,xml,gd,simplexml,mysqli]
	virtual/mysql
	www-servers/apache[apache2_modules_alias,apache2_modules_authn_file,apache2_modules_auth_basic,apache2_modules_authz_user,apache2_modules_mime,apache2_modules_cgi]
	stripchart? ( sci-visualization/gnuplot[gd] )
	mariadb-galera? ( dev-db/mariadb-galera[tools,server] )
	mariadb? ( dev-db/mariadb )
	mysql? ( dev-db/mysql[-minimal] )
	mysql-cluster? ( dev-db/mysql-cluster[-minimal] )
	ldap? ( net-nds/openldap )
	virtual/mta
	app-text/xmlstarlet
        fastcgi? ( dev-libs/fcgi
              || ( mod_fcgid?   ( www-apache/mod_fcgid )
                   mod_fastcgi? ( www-apache/mod_fastcgi ) )
        )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	app-text/docbook-xml-dtd:4.4
	app-text/docbook2X
	!fastcgi? ( !!dev-libs/fcgi )
"
REQUIRED_USE="^^ ( mysql mysql-cluster mariadb mariadb-galera ) stripchart? ( !fastcgi ) fastcgi? ( !stripchart ) mod_fcgid? ( !mod_fastcgi fastcgi ) mod_fastcgi? ( !mod_fcgid fastcgi ) fastcgi? ( || ( mod_fastcgi mod_fcgid ) ) "

S="${WORKDIR}/boinc-client_release-${MY_PV}-${PV}"

AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_setup() {
	einfo "This ebuild doesn't work yet"
	#die

	emerge -pvO boinc 2>/dev/null | grep boinc | cut -c -16 | grep R &>/dev/null
	if [[ "$?" != "0" ]]; then
		die "sci-misc/boinc must be installed."
	fi

	if use mod_fcgid; then
		grep -r -e "-D FCGID" "${ROOT}"/etc/conf.d/apache2 &>/dev/null
		if [[ "$?" != "0"  ]]; then
			die "APACHE2_OPTS requires -D FCGID in /etc/conf.d/apache2"
		fi
	fi

	if use mod_fastcgi; then
		grep -r -e "-D FCGID" "${ROOT}"/etc/conf.d/apache2 &>/dev/null
		if [[ "$?" != "0" ]]; then
			die "APACHE2_OPTS requires -D FCGID in /etc/conf.d/apache2"
		fi
	fi

	if use debug; then
		if [[ ! ( ${FEATURES} =~ "nostrip" ) ]]; then
			die Emerge again with FEATURES="nostrip" or remove the debug use flag
		fi
	fi
}

src_prepare() {
	# prevent bad changes in compile flags, bug 286701
	sed -i -e "s:BOINC_SET_COMPILE_FLAGS::" configure.ac || die "sed failed"

	epatch "${FILESDIR}"/boinc-server-7.4.42-static-boinczip.patch
	#epatch "${FILESDIR}"/boinc-7.4.42-proc_.patch
	#epatch "${FILESDIR}"/boinc-server-7.4.42-nodeprecated-warnings.patch
	epatch "${FILESDIR}"/boinc-server-7.4.42-disable-badges-fix.patch
	epatch "${FILESDIR}"/boinc-server-7.4.42-gnuplot-loc.patch
	epatch "${FILESDIR}"/boinc-server-7.4.42-mysqllib.patch
	if use fastcgi; then
		epatch "${FILESDIR}"/boinc-server-7.4.42-fcgi-printf.patch
		epatch "${FILESDIR}"/boinc-server-7.4.42-fcgi-mysql.patch
	fi

	if use debug; then
		A="DUMP_CORE_ON_SEGV 0" B="DUMP_CORE_ON_SEGV 1" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' ${S}/sched/sched_main.cpp
		epatch "${FILESDIR}"/boinc-server-7.4.42-debug_sched.patch
		elog "You need to 'touch debug_sched' in your boinc server project root for scheduling debuging logging."
		elog "See https://boinc.berkeley.edu/trac/wiki/ServerDebug for details."
	fi
	#epatch "${FILESDIR}"/boinc-server-7.4.42-sched_send-coproc_null_check.patch
        #epatch "${FILESDIR}"/boinc-server-7.4.42-sched-send-null-check.patch
	epatch "${FILESDIR}"/boinc-server-7.4.42-php-fixes.patch
	#epatch "${FILESDIR}"/boinc-server-7.4.42-size-classes-fixes.patch
	use wrapper && epatch "${FILESDIR}"/boinc-server-7.4.42-build-wrapper.patch

	epatch "${FILESDIR}"/boinc-server-7.6.1-printf.patch

	epatch_user

	autotools-utils_src_prepare
}

src_configure() {
	#if use debug; then
	#fi
	local myeconfargs=(
		--enable-server
		--disable-client
		--disable-static
		--enable-unicode
		--with-ssl
                --without-x
                --disable-manager
                --without-wxdir
		--enable-libraries
		--enable-fcgi
	)

	append-cppflags -D_GLIBCXX_USE_CXX11_ABI=0

	if use debug; then
		filter-flags -O1 -O2 -O3 -O4 -Os -Ofast
		CFLAGS="${CFLAGS} -g -O0" \
		CXXFLAGS="${CXXFLAGS} -g -O0" \
		CPPFLAGS="${CPPFLAGS} -g -O0" \
		LDFLAGS="${LDFLAGS} -g -O0" \
		autotools-utils_src_configure
	else
		autotools-utils_src_configure
	fi
}

src_compile() {
	MAKEOPTS="-j1" \
	emake || die "emake failed"
	if use wrapper; then
		cd "${S}"/samples/wrapper
		make
	fi
}

src_install() {
	autotools-utils_src_install

	mv "${D}"/usr/usr/share/boinc-server-maker/* "${D}"/usr/share/boinc-server-maker
	mkdir -p "${D}"/usr/share/boinc-server-maker/py
	mv "${D}"/usr/lib/boinc-server-maker/tools "${D}"/usr/share/boinc-server-maker
	mv "${D}"/usr/lib/boinc-server-maker/sched "${D}"/usr/share/boinc-server-maker/py/Boinc
	mv "${D}"/usr/lib/boinc-server-maker/vda "${D}"/usr/share/boinc-server-maker/py/Boinc
	mv "${D}"/usr/lib/boinc-server-maker/lib "${D}"/usr/share/boinc-server-maker/py/Boinc
	mv "${D}"/usr/lib/boinc-apps-examples "${D}"/usr/share/boinc-server-maker/examples
	cp "${S}"/py/boinc_path_config.py "${T}"/boinc_path_config.py
	cd "${D}"/usr/share/boinc-server-maker/
	rm -rf lib
	ln -s py/Boinc/sched sched
	ln -s py/Boinc/lib lib
	cp "${S}"/tools/gui_urls.xml "${D}"/usr/share/boinc-server-maker/tools
	cp -r "${S}"/html/project.sample "${D}"/usr/share/boinc-server-maker/html
	use stripchart && cp -r "${S}"/stripchart "${D}"/usr/share/boinc-server-maker

	cat "${T}"/boinc_path_config.py | awk -v Z1="/usr/share/boinc-server-maker" -v Z2="${S}" "{ sub(Z2, Z1); print; }" > "${D}"/usr/share/boinc-server-maker/tools/boinc_path_config.py

	# cleanup cruft
	rm -rf "${ED}"/etc
	rm -rf "${D}"/usr/include
	#rm -rf "${D}"/usr/$(get_libdir) #
	#rm -rf "${D}"/usr/lib #
	rm -rf "${D}"/usr/usr

 	rm "${D}"/usr/$(get_libdir)/libboinc.a
 	rm "${D}"/usr/$(get_libdir)/libboinc.la
 	rm "${D}"/usr/$(get_libdir)/libboinc_api.*
 	rm "${D}"/usr/$(get_libdir)/libboinc_crypt.*
 	rm "${D}"/usr/$(get_libdir)/libboinc_graphics2.*
 	rm "${D}"/usr/$(get_libdir)/libboinc_opencl.*

	#copy for pkg-config
	mkdir "${D}/usr/share/boinc-server-maker/extras"
	cp "${FILESDIR}/boinc-server" "${D}/usr/share/boinc-server-maker/extras/"
	if use examples; then
		cp -r "${FILESDIR}/apps.example" "${D}/usr/share/boinc-server-maker/extras/"
		cp -r "${FILESDIR}/templates" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/config.xml.example" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/project.xml.example" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/plan_class_spec.xml.example" "${D}/usr/share/boinc-server-maker/extras/"
	fi

	if use extras; then
		cp "${FILESDIR}/add_host" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/auto_generate_wu" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/limit_jobs" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/make_masterwu" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/update_app" "${D}/usr/share/boinc-server-maker/extras/"
		cp "${FILESDIR}/update_binaries" "${D}/usr/share/boinc-server-maker/extras/"
	fi
	if use wrapper; then
		mkdir -p "${D}/usr/share/boinc-server-maker/wrapper"
		cp "${S}"/samples/wrapper/wrapper "${D}/usr/share/boinc-server-maker/wrapper/"
	fi
}

pkg_preinst() {
	enewuser boincadm -1 "/bin/bash" "${ROOT}/var/lib/boinc-server" "apache,boinc,cron"
}

pkg_postinst() {
	elog "The boinc-server-maker is installed in /usr/share/boinc-server-maker folder."
	elog "Use 'emerge --config boinc-server' to set it up"
        einfo "Remember to restart your web server for changes to take effect."
        elog "For existing Boinc server project installs, call update_binaries in your project to update the executibles."
}

pkg_config() {
        einfo "Enter the mysql admin username (e.g. root):"
        read DB_USERNAME
	if [[ "${#DB_USERNAME}" == "0" ]]; then
		DB_USERNAME="root"
	fi
        einfo "Enter the mysql admin password (hidden):"
        read -s DB_PASSWORD

	einfo "Enter the mysql password for boincadm (hidden):"
        read -s DB_PASSWORDADM

	elog "Adding boincadm to database..."
	"${ROOT}"/etc/init.d/mysql start
	mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" -e "FLUSH PRIVILEGES;"
	mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" -e "DROP USER 'boincadm'@'localhost';"
	mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" -e "FLUSH PRIVILEGES;"
	mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" -e "CREATE USER 'boincadm'@'localhost' IDENTIFIED BY '${DB_PASSWORDADM}';"
	mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" -e "GRANT ALL ON *.* TO 'boincadm'@'localhost';"

	elog "Setting mariadb binlog_format to MIXED globally for bin/create_work to work..."
	mysql --user="${DB_USERNAME}" --password="${DB_PASSWORD}" -e "SET GLOBAL binlog_format=MIXED;"

        einfo "Enter the project folder name (e.g. boinc_project):"
        read PROJECTNAME
	if [[ "${#PROJECTNAME}" == "0" ]]; then
		PROJECTNAME="boinc_project"
	fi

        einfo "Enter the project nice name (e.g. Boinc Project):"
        read PROJECTNICENAME
	if [[ "${#PROJECTNICENAME}" == "0" ]]; then
		PROJECTNICENAME="Boinc Project"
	fi

	einfo "Enter the boinc-server project url ( e.g. http://127.0.0.1 ):"
        read URL
	if [[ "${#URL}" == "0" ]]; then
		URL="http://127.0.0.1"
	fi

        einfo "Enter the boinc-server project db name ( e.g. boinc_project ):"
        read DB_NAME
	if [[ "${#DB_NAME}" == "0" ]]; then
		DB_NAME="boinc_project"
	fi

	cd "${ROOT}/usr/share/boinc-server-maker"
	USER="boincadm" \
	python2 tools/make_project --project_root "/var/lib/boinc-server/projects/${PROJECTNAME}" --url_base "${URL}"  --db_name "${DB_NAME}" --db_user "${DB_USERNAME}" --db_passwd "${DB_PASSWORD}" \
                       --delete_prev_inst --drop_db_first --project_root "/var/lib/boinc-server/projects/${PROJECTNAME}" --srcdir /usr/share/boinc-server-maker "${PROJECTNAME}" "${PROJECTNICENAME}"
	einfo "Done with make_project"
	unset DB_PASSWORD
	unset DB_PASSWORDADM

        cd "${ROOT}/var/lib/boinc-server/projects"
	chown -R boincadm:boinc "${PROJECTNAME}"
        cd "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
	chgrp -R apache upload
	chmod -R g+w upload
	chgrp -R apache "log_$(hostname)"
	chmod -R g+w "log_$(hostname)"
	chgrp -R apache html/cache
	chmod -R g+w html/cache
	chgrp -R apache html/user_profile
	chmod -R g+w html/user_profile
	chgrp -R apache html/languages
	chmod -R g+w html/languages
	chmod o+rx html/inc
	chgrp apache download
	chmod g+rxs download
	chgrp apache bin/feeder
	chmod g+xs bin/feeder
	chgrp apache html/cache
	chgrp apache html/user_profile/images
	chmod o-r config.xml
	chgrp apache config.xml
	sed -i -r -e "s|</config>|  <uldl_pid>/var/run/apache2.pid</uldl_pid></config>|g" config.xml


	einfo "Adding job to /etc/crontab..."
	grep -r -e "/var/lib/boinc-server/projects/${PROJECTNAME}/bin/start" "${ROOT}"/etc/crontab 2>&1 > /dev/null
	if [[ "$?" != "0" ]]; then
		echo "0,5,10,15,20,25,30,35,40,45,50,55 * * * * cd /var/lib/boinc-server/projects/${PROJECTNAME} ; /usr/bin/python2 /var/lib/boinc-server/projects/${PROJECTNAME}/bin/start --cron" >> "${ROOT}"/etc/crontab
		crontab /etc/crontab
	fi

	einfo "Adding Apache module to /etc/apache/modules.d/99_${PROJECTNAME}.conf..."
	cat "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}/${PROJECTNAME}.httpd.conf" > "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
	if use fastcgi; then
		if use mod_fcgid; then
			echo "AddHandler fcgid-script cgi" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo "<Location /${PROJECTNAME}_cgi>" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo " SetHandler fcgid-script" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo " Options ExecCGI" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo " allow from all" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo "</Location>" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
		fi
		if use mod_fastcgi; then
			echo "AddHandler fastcgi-script cgi" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo "<Location /${PROJECTNAME}_cgi>" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo " SetHandler fastcgi-script" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo " Options ExecCGI" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo " allow from all" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
			echo "</Location>" >> "${ROOT}/etc/apache2/modules.d/99_${PROJECTNAME}.conf"
		fi
		cd "${ROOT}/usr/share/boinc-server-maker/py/Boinc/sched"
		cp fcgi_file_upload_handler "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}/cgi-bin"
		cp fcgi "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}/cgi-bin"
		chown boincadm:boinc "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}/cgi-bin/fcgi"
		chown boincadm:boinc "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}/cgi-bin/fcgi_file_upload_handler"
	fi

	einfo "${URL}/${PROJECTNAME}_ops folder protection..."
        cd "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
        einfo "Enter the .htaccess admin folder username for ${URL}/${PROJECTNAME}_ops (e.g. admin):"
        read ADMIN_FOLDER_USERNAME
        einfo "Enter the .htaccess admin folder password for ${URL}/${PROJECTNAME}_ops (hidden):"
        read -s ADMIN_FOLDER_PASSWORD
	if [[ "${#ADMIN_FOLDER_USERNAME}" == "0" ]]; then
		ADMIN_FOLDER_USERNAME="admin"
	fi
	htpasswd -b -c html/ops/.htpasswd "${ADMIN_FOLDER_USERNAME}" "${ADMIN_FOLDER_PASSWORD}"
  	unset ADMIN_FOLDER_PASSWORD

	cd "/var/lib/boinc-server/projects/${PROJECTNAME}"
	if use ldap; then
		einfo "Enter the LDAP host (e.g. ldap1.ssl.berkeley.edu)"
		read LDAPHOST
		if [[ "${#LDAPHOST}" == "0" ]]; then
			LDAPHOST="ldap1.ssl.berkeley.edu"
		fi
		einfo "Enter the LDAP base DN (e.g. ou=people,dc=ssl,dc=berkeley,dc=edu)"
		read LDAPBASENAME
		if [[ "${#LDAPBASENAME}" == "0" ]]; then
			LDAPBASENAME="ou=people,dc=ssl,dc=berkeley,dc=edu"
		fi
		A="${LDAPHOST}" B="${LDAPBASENAME}" perl -p -i -e 's|\Qrequire_once("../inc/util.inc");\E|require_once("../inc/util.inc");\ndefine("LDAP_HOST", "ldap://$ENV{'A'}");\ndefine("LDAP_BASE_DN", "$ENV{'B'}");|g' html/project/project.inc 
	else
		A="" B="" perl -p -i -e 's|\Qrequire_once("../inc/util.inc");\E|require_once("../inc/util.inc");\ndefine("LDAP_HOST", "ldap://$ENV{'A'}");\n//define("LDAP_BASE_DN", "$ENV{'B'}");|g' html/project/project.inc
	fi

        #einfo "Enter the project name:"
        #read X
	if [[ "${#PROJECTNICENAME}" != "0" ]]; then
		A="REPLACE WITH PROJECT NAME" B="${PROJECTNICENAME}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc

		A="XXX" B="${PROJECTNICENAME}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/user/index.php
		A="XXX" B="${PROJECTNICENAME}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/user/sample_index.php
		A="XXX" B="${PROJECTNICENAME}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/user/sample_index.php
	fi

        einfo "Enter the copyright holder:"
        read COPYRIGHT_HOLDER
        X="${COPYRIGHT_HOLDER}"
	if [[ "${#X}" != "0" ]]; then
		A="REPLACE WITH COPYRIGHT HOLDER" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

        einfo "Enter your institution:"
        read INSTITUTION_NAME
        einfo "Enter your institution's url:"
	read INSTITUTION_URL
  	X="${INSTITUTION_NAME}" 
  	Y="${INSTITUTION_URL}"
	if [[ "${#X}" != "0" && "${#Y}" != 0 ]]; then
		A="[describe your institution, with link to web page]" B1="${X}" B2="${Y}" perl -p -i -e 's|\Q$ENV{'A'}\E|<a href=\\"$ENV{'B2'}\\">$ENV{'B1'}</a>|g' html/user/sample_index.php
		A="[describe your institution, with link to web page]" B1="${X}" B2="${Y}" perl -p -i -e 's|\Q$ENV{'A'}\E|<a href=\\"$ENV{'B2'}\\">$ENV{'B1'}</a>|g' html/user/index.php
	fi

        #einfo "Enter your research project name:"
        #read X
        einfo "Enter your research project about page url (e.g. ${URL}/${PROJECTNAME}/about.html):"
	read RESEARCH_PROJECT_URL
  	Y="${RESEARCH_PROJECT_URL}"
	if [[ "${#PROJECTNICENAME}" != "0" && "${#Y}" != 0 ]]; then
		A="[Link to page describing your research in detail]" B1="${PROJECTNICENAME}" B2="${Y}" perl -p -i -e 's|\Q$ENV{'A'}\E|<a href=\\"$ENV{'B2'}\\">More details about $ENV{'B1'}</a>|g' html/user/sample_index.php
		A="[Link to page describing your research in detail]" B1="${PROJECTNICENAME}" B2="${Y}" perl -p -i -e 's|\Q$ENV{'A'}\E|<a href=\\"$ENV{'B2'}\\">More details about $ENV{'B1'}</a>|g' html/user/index.php
	fi

        einfo "Enter the people involed in your research project:"
        read RESEARCHERS_NAME
        einfo "Enter url to the people involed in your research project (e.g. ${URL}/${PROJECTNAME}/people.html):"
	read RESEARCHERS_URL
        einfo "Enter the project email address:"
	read RESEARCHERS_EMAIL
	X="${RESEARCHERS_NAME}"
  	Y="${RESEARCHERS_URL}"
  	Z="${RESEARCHERS_EMAIL}"
	if [[ "${#X}" != "0" && "${#Y}" != 0 && "${#Z}" != 0 ]]; then
		A="[Link to page listing project personnel, and an email address]" B1="${X}" B2="${Y}" B3="${Z}" perl -p -i -e 's|\Q$ENV{'A'}\E|The researchers: <a href=\\"$ENV{'B2'}\\">$ENV{'B1'}</a>. Contact: <a href=\\"mailto:$ENV{'B3'}\\">$ENV{'B3'}</a>.|g' html/user/sample_index.php
		A="[Link to page listing project personnel, and an email address]" B1="${X}" B2="${Y}" B3="${Z}" perl -p -i -e 's|\Q$ENV{'A'}\E|The researchers: <a href=\\"$ENV{'B2'}\\">$ENV{'B1'}</a>. Contact: <a href=\\"mailto:$ENV{'B3'}\\">$ENV{'B3'}</a>.|g' html/user/index.php
	fi

        einfo "Enter the admin email (e.g. admin@\$master_url):"
        read ADMIN_EMAIL
  	X="${ADMIN_EMAIL}"
	if [[ "${#X}" != "0" ]]; then
		A="admin@\$master_url" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enter the moderator emails seperated by | (e.g. moderator1@\$master_url|moderator2@\$master_url):"
        read MODERATORS_EMAILS
  	X="${MODERATORS_EMAILS}"
	if [[ "${#X}" != "0" ]]; then
		A="moderator1@\$master_url|moderator2@\$master_url" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enable mailer? (y/n)"
	read ENABLE_MAILER
  	X="${ENABLE_MAILER}"
	if [[ "${X}" == "y" ]]; then
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|//\nif \(0\) \{\n|//\n|g" html/project/project.inc
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|return \\$||g" -e "s|mail;\n\}\n\}\n|\}\n|g" html/project/project.inc
	fi

	einfo "Enter the SMTP server host (e.g. smtp.gmail.com):"
        read SMTP_HOST
  	X="${SMTP_HOST}"
	if [[ "${#X}" != "0" ]]; then
		A="smtp.gmail.com" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enter if we should enable SMTP authentication (e.g. either true or false):"
        read ENABLE_SMTP_AUTH
  	X="${ENABLE_SMTP_AUTH}"
	if [[ "${#X}" != "0" ]]; then
		A="true" B="${X,,}" perl -p -i -e 's|\QSMTPAuth = true\E|SMTPAuth = $ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enter the encryption type (e.g. either tls or ssl)"
        read MAIL_ENCRYPTION
  	X="${MAIL_ENCRYPTION}"
	if [[ "${#SMTP_ENCRYPTION}" != "0" ]]; then
		A="tls" B="${X,,}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enter the SMTP server port (e.g. 587):"
        read SMTP_SERVER_PORT
  	X="${SMTP_SERVER_PORT}"
	if [[ "${#X}" != "0" ]]; then
		A="587" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enter the SMTP username (e.g. john.doe@gmail.com):"
	read SMTP_USERNAME
  	X="${SMTP_USERNAME}"
	if [[ "${#X}" != "0" ]]; then
		A="john.doe@gmail.com" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enter the SMTP password (hidden):"
        read -s SMTP_PASSWORD
  	X="${SMTP_PASSWORD}"
	if [[ "${#X}" != "0" ]]; then
		A="\"xxx\"" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|"$ENV{'B'}"|g' html/project/project.inc
	fi
	unset X
	unset SMTP_PASSWORD

	einfo "Enter the reply to email (e.g. admin@boincproject.com):"
        read REPLY_EMAIL
  	X="${REPLY_EMAIL}"
	if [[ "${#X}" != "0" ]]; then
		A="admin@boincproject.com" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	einfo "Enter the reply to name (e.g. John Doe):"
        read REPLY_NAME
  	X="${REPLY_NAME}"
	if [[ "${#X}" != "0" ]]; then
		A="John Doe" B="${X}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/project/project.inc
	fi

	if use fastcgi; then
	        cd "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		A="${PROJECTNAME}_cgi/cgi" B="${PROJECTNAME}_cgi/fcgi" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' html/user/schedulers.txt
		sed -i -r -e "s|file_upload_handler|fcgi_file_upload_handler|g" config.xml
	fi

	if use stripchart; then
		einfo "Setting up cli and cgi stripchart..."
		elog "See /usr/share/boinc-server-maker/stripchart/README for details on using stripchart."
	        cd "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "${ROOT}"/usr/share/boinc-server-maker/stripchart/stripchart.cgi cgi-bin
		cp "${ROOT}"/usr/share/boinc-server-maker/stripchart/stripchart.cnf cgi-bin
		cp "${ROOT}"/usr/share/boinc-server-maker/stripchart/stripchart cgi-bin
		chown boincadm:boinc cgi-bin/stripchart.cgi
		chown boincadm:boinc cgi-bin/stripchart.cnf
		chown boincadm:boinc cgi-bin/stripchart

		mkdir lib
		touch lib/datafiles
		touch lib/querylist
		chown -R boincadm:boinc lib
		chmod g+rw lib
		chgrp apache lib
		xml ed -L -s "/boinc/config" -t elem -n "stripchart_cgi_url" -v "${URL}/${PROJECTNAME}_cgi" config.xml
	fi

	if use examples; then
		cd "${ROOT}/usr/share/boinc-server-maker/extras"
		cp -r "apps.example" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp -r "templates" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "config.xml.example" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "project.xml.example" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "plan_class_spec.xml.example" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
	fi

	if use extras; then
		cd "${ROOT}/usr/share/boinc-server-maker/extras"
		cp "auto_generate_wu" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "limit_jobs" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "make_masterwu" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "update_app" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		cp "update_binaries" "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
	fi

	einfo "Installing init service..."
	cp "${ROOT}/usr/share/boinc-server-maker/extras/boinc-server" "${ROOT}/etc/init.d/boinc-server-${PROJECTNAME}"
	A="boinc_project" B="${PROJECTNAME}" perl -p -i -e 's|\Q$ENV{'A'}\E|$ENV{'B'}|g' "${ROOT}/etc/init.d/boinc-server-${PROJECTNAME}"
	elog "Your init service is located at /etc/init.d/boinc-server-${PROJECTNAME}."
	${ROOT}/etc/init.d/boinc-server-${PROJECTNAME} restart
	elog "Consider doing..."
	elog "rc-update add boinc-server-${PROJECTNAME}."

	if use debug; then
	        cd "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
		touch debug_sched
		einfo "You need to delete debug_sched to disable scheduler logging."
		chown boincadm:boinc debug_sched
	fi

	#xml sel -t -v "//grace_period_hours[text()]" #for conditional
	cd "${ROOT}/var/lib/boinc-server/projects/${PROJECTNAME}"
	#xml ed -L -s "/boinc/config" -t elem -n "grace_period_hours" -v "24.0" config.xml
        #xml ed -L -s "/boinc/config" -t elem -name "debug_version_select" config.xml
	#xml ed -L -u "/boinc/daemons/daemon/cmd[text()='feeder -d 3 ']" -v "feeder -d 3 --allapps " config.xml

  cd "${ROOT}/var/lib/boinc"

  elog "See /var/lib/boinc/add_host script on adding this project to the Boinc client project lists."

	einfo
	einfo "The Boinc project is located at /var/lib/boinc-server/projects/${PROJECTNAME}."
	einfo "You still need to edit your templates and run the commands listed in the update_app example script."
	einfo
	if use examples; then
	einfo
	einfo "Several example templates were added"
	einfo "templates/workunit_template.xml.example"
	einfo "templates/results_template.xml.example"
	einfo "templates/version.xml.example"
	einfo "project.xml.example"
	einfo "plan_class_spec.xml.example"
	einfo
	einfo "An example application was added to apps.example folder."
	einfo
  fi
	einfo
	einfo "Helpful server-side references on editing those files..."
	einfo "https://boinc.berkeley.edu/trac/wiki/JobTemplates"
	einfo "https://boinc.berkeley.edu/trac/wiki/AppVersionNew"
	einfo ""
	einfo "Helpful client application debugging documentation..."
	einfo "https://boinc.berkeley.edu/trac/wiki/AppDebug"
	einfo
	einfo "Helpful client-side references..."
	einfo "https://boinc.berkeley.edu/trac/wiki/BasicApi"
	einfo ""
	einfo "The project url and website is ${URL}/${PROJECTNAME}/ ."
	einfo "The admin panel can be found at ${URL}/${PROJECTNAME}_ops/ ."
	einfo ""
        einfo "The first time install of Boinc server project is done."
        einfo "Remember to restart your web server for changes to take effect."
	einfo
	if use extras; then
	einfo "Several helper scripts were added."
	einfo "add_host was added to /var/lib/boinc to allow you to add your project on the local machine"
	einfo "update_binaries - updates the project's binaries"
	einfo "make_masterwu - creates the work units"
	einfo "update_app - script to install the boinc app"
	fi
	einfo
}

#for details
#https://boinc.berkeley.edu/boinc.pdf
#https://github.com/ComputationalBiophysicsCollaborative/AsyncRE/wiki/Boinc-Server-Guide
#http://www.spy-hill.net/myers/help/boinc/Create_Project.html

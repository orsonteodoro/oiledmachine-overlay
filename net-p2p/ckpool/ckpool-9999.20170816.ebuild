# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils flag-o-matic toolchain-funcs webapp

DESCRIPTION="Ultra low overhead massively scalable multi-process, multi-threaded modular bitcoin mining pool, proxy, passthrough, library and database interface in c for Linux."
HOMEPAGE="https://bitbucket.org/ckolivas/ckpool/overview"
COMMIT="5e93cf821949967682c4c0693d55ad23a9a9964a"
COMMIT_SHORT="${COMMIT:0:12}"
SRC_URI="https://bitbucket.org/ckolivas/ckpool/get/${COMMIT_SHORT}.zip -> ${PN}.${PV}.zip"

LICENSE="GPL-3"

IUSE="ckdb"
REQUIRED_USE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="net-p2p/bitcoind
         ckdb? ( dev-db/postgresql[server]
                 sci-libs/gsl
                 dev-libs/openssl
                )
	>=dev-libs/jansson-2.6
	dev-lang/php[crypt,snmp,sockets,session]
	virtual/httpd-php:*
        "
DEPEND="${RDEPEND}
	dev-lang/yasm"

need_httpd_cgi

S="${WORKDIR}/ckolivas-ckpool-${COMMIT_SHORT}"

pkg_setup() {
	if use ckdb ; then
		ewarn "Your webserver needs ssl support."
		webapp_pkg_setup
	fi
}

src_prepare() {
	rm -rf "${S}/src/jansson-2.6"
	epatch "${FILESDIR}"/${PN}-9999.20170816-external-jansson.patch
	epatch "${FILESDIR}"/${PN}-9999.20170816-php-paths.patch
	epatch "${FILESDIR}"/${PN}-9999.20170816-relative-path.patch
	epatch "${FILESDIR}"/${PN}-9999.20170816-admin.patch
	epatch "${FILESDIR}"/${PN}-0.9.4-fix-index.patch
	epatch "${FILESDIR}"/${PN}-0.9.4-email-fix.patch
	eapply_user

	eautoreconf
}

src_configure() {
	append-cppflags -DJSON_NO_UTF8=0 -DJSON_EOL=0
	LIBS="-L/usr/$(get_libdir) -ljansson" \
	econf $(use_with ckdb)
}

src_compile() {
	default
}

src_install() {
	if use ckdb ; then
		webapp_src_preinst
	fi

	emake DESTDIR="${D}" install
	mkdir -p "${D}/etc/ckpool"
	cp -a {cknode.conf,ckpassthrough.conf,ckpool.conf,ckproxy.conf,ckredirector.conf} "${D}/etc/ckpool"
	mkdir -p "${D}/usr/share/${PN}"
	dodoc README

	chmod +x "${D}"/usr/bin/{ckpool,ckpmsg,notifier}

	if use ckdb ; then
		chmod +x "${D}"/usr/bin/ckdb
		insinto "${MY_HTDOCSDIR#${EPREFIX}}"
		doins -r pool
		insinto "${MY_HTDOCSDIR#${EPREFIX}}"
		doins -r html/*

		insinto "${MY_SQLSCRIPTSDIR}"
		doins -r sql/*

		mkdir -p "${D}/etc/conf.d"
		mkdir -p "${D}/etc/init.d"
		cp -a "${FILESDIR}"/ckpool.confd "${D}"/etc/conf.d/ckpool
		cp -a "${FILESDIR}"/ckpool "${D}"/etc/init.d
		chmod +x "${D}"/etc/init.d/ckpool

		cp -a "${FILESDIR}"/ckdb.confd "${D}"/etc/conf.d/ckdb
		cp -a "${FILESDIR}"/ckdb "${D}"/etc/init.d
		chmod +x "${D}"/etc/init.d/ckdb

		webapp_src_install
	fi
}

pkg_postinst() {
	einfo "Use \`emerge =${CATEGORY}/${PN}-${PV} --config\` for new installations to populate the postgres database."
	if use ckdb ; then
		webapp_pkg_postinst
		ewarn "For the html interface, the user name 'admin' has been enabled with special menus."
	fi
}

pkg_config() {
	einfo "Enter password for postgres:"
	read -s
	PGPASSWORD=${REPLY} psql -U postgres -c "CREATE DATABASE ckdb OWNER postgres"
	PGPASSWORD=${REPLY} psql -U postgres -d ckdb -f "${MY_SQLSCRIPTSDIR}"/ckdb.sql
	unset PGPASSWORD
	unset REPLY
}

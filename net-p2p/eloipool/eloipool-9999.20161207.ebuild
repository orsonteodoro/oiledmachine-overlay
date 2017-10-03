# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_3,3_4} )

inherit autotools eutils flag-o-matic toolchain-funcs distutils-r1 git-r3

DESCRIPTION=""
HOMEPAGE=""
COMMIT="d488480c263c57a1e5151a6db3090d1413d3a054"
MAINTAINER="luke-jr"
#SRC_URI="https://github.com/${MAINTAINER}/${PN}/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="AGPL-3+"
SLOT="0"

IUSE="mysql postgres sqlite"
REQUIRED_USE=""
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.3[ipv6,sqlite?]
        dev-vcs/git
	=dev-python/bitcoinrpc-1.0[${PYTHON_USEDEP},jsonrpc-compat]
	net-p2p/bitcoind
	dev-python/midstate
	mysql? ( virtual/mysql
		 dev-python/pymysql )
        postgres? ( dev-db/postgresql
		      dev-python/psycopg )
	sqlite? ( dev-db/sqlite )
"

#dev-python/bitcoinrpc is broken on the bitcoin overlay.  use the one from oiledmachine overlay.

RDEPEND="
"

EGIT_REPO_URI="https://github.com/luke-jr/eloipool.git"
EGIT_COMMIT="d488480c263c57a1e5151a6db3090d1413d3a054"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

python_prepare_all() {
	eapply_user

	distutils-r1_python_prepare_all
}

src_compile() {
	true
}

src_install() {
        inst() {
		mkdir -p "${D}/$(python_get_sitedir)"
		cp -a ${S} "${D}/$(python_get_sitedir)"
		chmod +x "${D}/$(python_get_sitedir)/eloipool.py"
        }

	python_foreach_impl inst

	link() {
		mkdir -p "${D}/usr/lib/python-exec/${EPYTHON}"
		ln -s "$(python_get_sitedir)/eloipool.py" "${D}/usr/lib/python-exec/${EPYTHON}/eloipool.py"
	}

	python_foreach_impl link

	mkdir -p "${D}/usr/bin/"
	ln -s "${D}/usr/lib/python-exec/python-exec2" "${D}/usr/bin/eloipool.py"

	mkdir -p "${D}/usr/init.d"
	mkdir -p "${D}/usr/conf.d"
	cp -a "${FILESDIR}/eloipool" "${D}/etc/init.d"
	cp -a "${FILESDIR}/eloipool.confd" "${D}/etc/conf.d/eloipool"
	chmod +x "${D}/etc/init.d/eloipool"
}

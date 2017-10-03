# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit python-r1

DESCRIPTION="Efficient JSON-RPC for Python"
HOMEPAGE="https://github.com/jgarzik/python-bitcoinrpc"
MyP="python-${PN}-${PV}"
SRC_URI="https://github.com/jgarzik/python-bitcoinrpc/archive/v${PV}.tar.gz -> ${PN}.${PV}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+jsonrpc-compat"

DEPEND="jsonrpc-compat? ( !dev-python/jsonrpc )
	${PYTHON_DEPS}
"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MyP}"

src_install() {
	myinstall() {
		if use jsonrpc-compat ; then
			insinto "$(python_get_sitedir)/jsonrpc"
			doins -r jsonrpc/* || die 'doins failed'
			python_optimize
		fi
		insinto "$(python_get_sitedir)/bitcoinrpc"
		doins -r bitcoinrpc/* || die 'doins failed'
		python_optimize
	}
	python_foreach_impl myinstall
}

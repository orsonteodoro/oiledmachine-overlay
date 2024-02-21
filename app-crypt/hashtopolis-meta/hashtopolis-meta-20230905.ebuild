# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Hashtopolis metapackage"
HOMEPAGE="https://github.com/hashtopolis/server"
LICENSE="metapackage"
SLOT="0"
IUSE="+client +server"
REQUIRED_USE="
	|| (
		client
		server
	)
"
RESTRICT="test"
RDEPEND="
	client? (
		~app-crypt/hashtopolis-python-agent-0.14.1
	)
	server? (
		~app-crypt/hashtopolis-0.7.1
	)
"
DEPEND="
	${RDEPEND}
"

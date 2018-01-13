# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_EXTRA_FILES="cli.js"

inherit node-module

DESCRIPTION="Get the path to the user home directory"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

src_install() {
        node-module_src_install
	install_node_module_binary "cli.js" "/usr/local/bin/${PN}-${SLOT}"
}


# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="RFC4122 (v1, v4, and v5) UUIDs"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md AUTHORS HISTORY.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/uuid" "/usr/local/bin/${PN}-${SLOT}"
}

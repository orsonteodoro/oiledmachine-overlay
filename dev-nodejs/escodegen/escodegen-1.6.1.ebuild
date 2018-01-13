# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="estraverse:1.9.1 esutils:1.1.6 esprima:1.2.2 optionator:0.5.0"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="ECMAScript code generator"

LICENSE="BSD-2 BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/esgenerate.js" "/usr/local/bin/esgenerate-${SLOT}"
	install_node_module_binary "bin/${PN}.js" "/usr/local/bin/${PN}-${SLOT}"
}

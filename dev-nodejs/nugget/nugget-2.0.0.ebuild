# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="debug:2.1.3 minimist:1.1.0 pretty-bytes:1.0.2 progress-stream:1.1.0 request:2.45.0 single-line-log:0.4.1 throttleit:0.0.2"
NODE_MODULE_EXTRA_FILES="bin.js multiple.png"

inherit node-module

DESCRIPTION="minimalist wget clone written in node. HTTP GETs a file and saves it to the current working directory"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( collaborators.md readme.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin.js" "/usr/local/bin/${PN}-${SLOT}"
}

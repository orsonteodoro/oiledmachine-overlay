# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="minimist:0.1.0 debug:0.7.4 async:0.9.0 mkdirp:0.5.0 concat-stream:1.4.6 through2:0.6.3 yauzl:2.1.0"
NODE_MODULE_EXTRA_FILES="cli.js"

inherit node-module

DESCRIPTION="unzip a zip file into a directory using 100% pure gluten-free organic javascript"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

src_install() {
        node-module_src_install
	install_node_module_binary "cli.js" "/usr/local/bin/${PN}-${SLOT}"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_NAME="${PN//-/.}" #emerge doesn't like names with periods in it

inherit node-module

DESCRIPTION="The modern build of lodash.isNative as a module"

LICENSE=""
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_install() {
	node-module_src_install
	install_node_module_depend "${PN//-/.}:${PV}"
}

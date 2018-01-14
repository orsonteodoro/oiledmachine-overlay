# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="electron-download:3.0.1 extract-zip:1.0.3"
NODE_MODULE_EXTRA_FILES="cli.js"

inherit node-module

DESCRIPTION="Install prebuilt electron binaries for the command-line using npm"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

RDEPEND="${RDEPEND}
         dev-nodejs/types-node:7.0.18"
S="${WORKDIR}/electron-userland-electron-prebuilt-b3b83ac"

DOCS=( CONTRIBUTING.md README.md issue_template.md electron.d.ts )

src_install()
{
	node-module_src_install
	install_node_module_binary "cli.js" "/usr/local/bin/${PN}-${SLOT}"
	install_node_module_depend "types-node:7.0.18"
}

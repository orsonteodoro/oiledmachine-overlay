# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="array-tools:1.0.6"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="A simple library containing all known terminal ansi escape codes and sequences. Useful for adding colour to your command-line output or building a dynamic text user interface."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( jsdoc2md/README.hbs README.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/cli.js" "/usr/local/bin/ansi-${SLOT}"
}

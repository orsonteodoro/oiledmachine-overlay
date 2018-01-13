# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="resolve-from:2.0.0 minimatch:0.2.0 glob:3.0.0 enhanced-resolve:2.2.2 acorn:3.2.0"
NODE_MODULE_EXTRA_FILES="bin defs plugin emacs"

inherit node-module

DESCRIPTION="A JavaScript code analyzer for deep, cross-editor language support"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( CONTRIBUTING.md AUTHORS )

src_install() {
	node-module_src_install
	install_node_module_binary "bin/${PN}" "/usr/local/bin/${PN}-${SLOT}"
	use doc && dodoc -r doc/* index.html
}

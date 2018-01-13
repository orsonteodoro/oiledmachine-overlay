# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.0"
NODE_MODULE_DEPEND="buffer-equal:0.0.0 coveralls:2.11.2 deep-equal:1.0.0 foreground-child:1.2.0 glob:5.0.6 js-yaml:3.3.1 mkdirp:0.5.0 nyc:2.1.0 opener:1.4.1 signal-exit:2.0.0 supports-color:1.3.1 tap-mocha-reporter:0.0.27 tap-parser:1.0.1"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="A Test-Anything-Protocol library"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS=( AUTHORS README.md )

src_install() {
	node-module_src_install
	install_node_module_binary "bin/run.js" "/usr/local/bin/tap-${SLOT}"
}

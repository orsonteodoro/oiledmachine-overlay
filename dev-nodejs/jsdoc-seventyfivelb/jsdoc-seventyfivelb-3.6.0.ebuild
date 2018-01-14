# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_NAME="jsdoc-75lb"
NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="bluebird:3.4.6 catharsis:0.8.8 escape-string-regexp:1.0.5 espree:3.1.7 js2xmlparser:1.0.0 klaw:1.3.0 marked:0.3.6 mkdirp:0.5.1 requizzle:0.2.1 strip-json-comments:2.0.1 taffydb:2.6.2 underscore:1.8.3"
NODE_MODULE_EXTRA_FILES="templates plugins jsdoc.js"

inherit node-module

DESCRIPTION="An API documentation generator for JavaScript."

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( CHANGES.md CONTRIBUTING.md README.md )

src_install() {
        node-module_src_install
	install_node_module_binary "jsdoc.js" "/usr/local/bin/jsdoc-${SLOT}"
        use examples && dodoc -r conf.json.EXAMPLE
}

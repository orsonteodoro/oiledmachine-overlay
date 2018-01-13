# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="Base64:0.2.0 coffee-script-redux:2.0.0_beta8 esprima:1.1.0 estraverse:1.5.0 escodegen:1.2.0 esmangle:1.0.0 MD5:1.2.0 mktemp:0.3.0 nopt:2.1.2 resolve:0.6.0 buffer-browserify constants-browserify:0.0.1 crypto-browserify events-browserify http-browserify punycode querystring vm-browserify zlib-browserify"
NODE_MODULE_EXTRA_FILES="bin node"

#    "Base64": "0.2.x",
#    "coffee-script-redux": "2.0.0-beta8",
#    "esprima": "1.x.x",
#    "estraverse": "1.5.x",
#    "escodegen": "1.2.x",
#    "esmangle": "~1.0.0",
#    "MD5": "~1.2",
#    "mktemp": "0.3.x",
#    "nopt": "~2.1.2",
#    "resolve": "0.6.x",
#    "buffer-browserify": "*",
#    "constants-browserify": ">= 0.0.1",
#    "crypto-browserify": "*",
#    "events-browserify": "*",
#    "http-browserify": "*",
#    "punycode": "*",
#    "querystring": "*",
#    "vm-browserify": "*",
#    "zlib-browserify": "*"


inherit node-module

DESCRIPTION="CommonJS browser bundler with aliasing, extensibility, and source maps from the minified JS bundle"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGELOG README.md )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/cjsify" "/usr/local/bin/cjsify-${SLOT}"
}

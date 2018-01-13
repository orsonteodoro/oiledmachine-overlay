# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.6"
NODE_MODULE_EXTRA_FILES="bin fixtures"
NODE_MODULE_DEPEND="js-yaml:3.0.1 lcov-parse:0.0.6 log-driver:1.2.4 request:2.40.0"

inherit node-module

DESCRIPTION="Takes json-cov output into stdin and POSTs to coveralls.io"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RESTRICT="test" # Broken
DOCS=( README.md )

src_compile() { :; }

src_install() {
        node-module_src_install
	install_node_module_binary "bin/${PN}.js" "/usr/local/bin/${PN}-${SLOT}"
}


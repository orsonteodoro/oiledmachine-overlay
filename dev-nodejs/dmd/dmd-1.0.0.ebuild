# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="ansi-escape-sequences:1.0.2 array-tools:1.3.0 command-line-args:0.5.1 ddata:0.1.0 file-set:0.2.6 handlebars-array:0.2.0 handlebars-comparison:2.0.0 handlebars-json:1.0.0 handlebars-regexp:1.0.0 handlebars-string:2.0.1 object-tools:1.1.1 stream-handlebars:0.1.1"
NODE_MODULE_EXTRA_FILES="bin helpers partials"

inherit node-module

DESCRIPTION="dmd (document with markdown) is a collection of handlebars templates for generating markdown documentation from jsdoc-parse input data. It is the default template set used by jsdoc-to-markdown."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

src_install() {
        node-module_src_install
        install_node_module_binary "bin/cli.js" "/usr/local/bin/${PN}-${SLOT}"
}

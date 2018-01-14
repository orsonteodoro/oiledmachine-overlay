# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="array-tools:1.0.6 command-line-args:0.5.0 config-master:0.2.0 console-dope:0.3.6 file-set:0.2.0 front-matter-extractor:1.0.0 handlebars:2.0.0-alpha_p4 handlebars-ansi:0.1.0 handlebars-array:0.1.0 handlebars-array:0.1.5 handlebars-comparison:1.1.1 handlebars-fileset:0.1.3 handlebars-fs:0.2.0 handlebars-json:0.1.0 handlebars-path:0.1.0 handlebars-regexp:0.1.1 handlebars-string:1.0.6 home-path:0.1.1 more-fs:0.5.0 object-tools:1.1.1"
#    "config-master": "~0.2",
#array-tools:1.0.0 has deleted dependency and project use 1.0.6 instead
NODE_MODULE_EXTRA_FILES="bin boil3.json boil.json"

inherit node-module

DESCRIPTION="Boilerplate files, packages, apps, websites etc."

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( README.md jsdoc2md/README.hbs )

src_install() {
        node-module_src_install
	install_node_module_binary "bin/cli.js" "/usr/local/bin/boil-${SLOT}"
}


# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="array-tools:1.1.0 handlebars:2.0.0_alpha_p4 handlebars-ansi:0.1.0 nature:0.5.0 object-tools:1.0.2 string-tools:0.1.4 typical:1.0.0"
#object-tools:1.0.0 is broken use 1.0.2 instead
NODE_MODULE_EXTRA_FILES="template"

inherit node-module

DESCRIPTION="Command-line parser, usage text producer"

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md jsdoc2md/README.hbs )

src_install() {
        node-module_src_install
        use examples && dodoc -r example
}


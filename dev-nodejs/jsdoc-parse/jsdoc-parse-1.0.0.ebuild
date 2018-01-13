# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="array-tools:1.5.2 command-line-args:0.5.1 file-set:0.2.1 jsdoc-75lb:3.6.0 more-fs:0.5.0 object-tools:1.2.0"
#    "jsdoc-75lb": "latest",
NODE_MODULE_EXTRA_FILES="bin jsdoc2md"

inherit node-module

DESCRIPTION="Jsdoc-annotated source code in, JSON format documentation out."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( README.md )

src_install() {
        node-module_src_install
        use examples && dodoc -r example
}


# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="array-tools:1.3.0 boil-js:0.2.9 marked:0.3.2 object-tools:1.1.1"
NODE_MODULE_EXTRA_FILES="model.uxf diagram.uxf"

inherit node-module

DESCRIPTION="ddata -- helpers for working with doc-data"

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( README.md jsdoc2md/README.hbs )



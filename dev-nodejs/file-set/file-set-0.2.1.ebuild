# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="array-tools:1.0.4 glob:4.0.2"

inherit node-module

DESCRIPTION="Expands file patterns, returning the matched and unmatched files and directories."

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( jsdoc2md/README.hbs README.md )


# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="ansi-escape-sequences:0.1.0"

inherit node-module

DESCRIPTION="Ansi escape sequence helpers for rendering cli views"

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( jsdoc2md/README.hbs README.md )


# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="object-tools:1.0.0 typical:1.0.0"

inherit node-module

DESCRIPTION="Useful functions for working with arrays"

SRC_URI="https://github.com/75lb/array-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-${PV}"

DOCS=( jsdoc2md/README.hbs README.md )

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="array-tools:1.0.0 typical:1.0.0"

inherit node-module

DESCRIPTION="Useful functions for working with objects"

SRC_URI="https://github.com/75lb/object-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( README.md jsdoc2md/README.hbs )

S="${WORKDIR}/${PN}-${PV}"


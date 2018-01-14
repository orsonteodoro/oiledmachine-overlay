# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="more-fs:0.5.0"

inherit node-module

DESCRIPTION="Handlebars helper mappings for the node.js fs module"

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

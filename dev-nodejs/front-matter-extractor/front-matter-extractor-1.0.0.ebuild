# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="js-yaml:3.0.1"

inherit node-module

DESCRIPTION="Separate front-matter from content"

LICENSE="" #it doesn't say
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

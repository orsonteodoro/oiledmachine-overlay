# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="center-align:0.1.1 right-align:0.1.1 wordwrap:0.0.2"

inherit node-module

DESCRIPTION="Easily create complex multi-column command-line-interfaces"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

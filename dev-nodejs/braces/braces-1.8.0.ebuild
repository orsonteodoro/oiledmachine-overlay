# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="repeat-element:1.1.0 preserve:0.2.0 expand-range:1.8.1"

inherit node-module

DESCRIPTION="Fastest brace expansion for node.js"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

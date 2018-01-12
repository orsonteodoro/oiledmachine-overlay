# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="repeat-element:1.0.0 repeat-string:1.5.0 isobject:0.2.0 is-number:1.1.0 randomatic:1.1.0"

inherit node-module

DESCRIPTION="Fill in a range of numbers or letters"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

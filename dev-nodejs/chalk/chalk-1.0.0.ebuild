# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="ansi-styles:2.0.1
	escape-string-regexp:1.0.2
	has-ansi:1.0.3
	strip-ansi:2.0.1
	supports-color:1.3.0"

inherit node-module

DESCRIPTION="Terminal string styling done right. Much color."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

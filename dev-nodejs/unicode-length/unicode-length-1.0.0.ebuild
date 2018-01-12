# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="build coffeelint.json  gulpfile.coffee"
NODE_MODULE_DEPEND="punycode:1.3.2 chalk:1.0.0 lodash:3.7.0"

inherit node-module

DESCRIPTION="Get the length of unicode strings"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="minimist:1.1.2 deep-extend:0.2.5 strip-json-comments:0.1.0 ini:1.3.0"
NODE_MODULE_EXTRA_FILES="browser.js"

inherit node-module

DESCRIPTION="hardwired configuration loader"

LICENSE="|| ( MIT Apache-2.0 BSD-2 )"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

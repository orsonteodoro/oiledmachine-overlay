# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_EXTRA_FILES="browser.js"
NODE_MODULE_DEPEND="md5-o-matic:0.1.1"

inherit node-module

DESCRIPTION="Create a MD5 hash with hex encoding"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

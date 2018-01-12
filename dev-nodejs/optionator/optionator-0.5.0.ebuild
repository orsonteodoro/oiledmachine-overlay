# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="prelude-ls:1.1.1 deep-is:0.1.2 wordwrap:0.0.2 type-check:0.3.1 levn:0.2.5 fast-levenshtein:1.0.0"
NODE_MODULE_EXTRA_FILES=""

inherit node-module

DESCRIPTION="option parsing and help generation"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

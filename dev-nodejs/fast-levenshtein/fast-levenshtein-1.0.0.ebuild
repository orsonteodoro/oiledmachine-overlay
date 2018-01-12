# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_EXTRA_FILES="levenshtein.min.js"

inherit node-module

DESCRIPTION="Efficient implementation of Levenshtein algorithm with asynchronous callback support"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

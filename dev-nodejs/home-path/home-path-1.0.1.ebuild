# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="jsdoc-to-markdown:1.1.1 tape:4.8.0"
NODE_MODULE_EXTRA_FILES="jsdoc2md"

inherit node-module

DESCRIPTION="Cross-platform home directory retriever"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

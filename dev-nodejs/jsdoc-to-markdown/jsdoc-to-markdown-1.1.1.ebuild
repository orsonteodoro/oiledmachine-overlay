# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="command-line-args:0.5.0 console-dope:0.3.3 dmd:1.0.0 jsdoc-parse:1.0.0"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="Markdown API documentation generator"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

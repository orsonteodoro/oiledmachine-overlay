# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="duplexer:0.0.3"

inherit node-module

DESCRIPTION="Turn a pipeline into a single stream."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

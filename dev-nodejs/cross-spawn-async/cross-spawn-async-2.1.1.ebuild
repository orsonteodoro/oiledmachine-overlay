# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="lru-cache:3.2.0 which:1.2.0"

inherit node-module

DESCRIPTION="Cross platform child_process#spawn"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

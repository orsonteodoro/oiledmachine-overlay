# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="readable-stream:1.0.34 xtend:4.0.1"

inherit node-module

DESCRIPTION="A tiny wrapper around Node streams2 Transform"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

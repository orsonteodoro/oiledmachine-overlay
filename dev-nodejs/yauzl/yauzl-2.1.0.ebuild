# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="fd-slicer:0.2.1 pend:1.1.3"

inherit node-module

DESCRIPTION="yet another unzip library for node"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

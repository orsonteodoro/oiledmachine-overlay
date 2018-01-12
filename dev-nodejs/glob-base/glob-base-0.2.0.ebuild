# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="glob-parent:1.2.0"

inherit node-module

DESCRIPTION="Returns an object with the (non-glob) base path and the actual pattern"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

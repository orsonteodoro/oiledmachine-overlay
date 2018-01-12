# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="glob-base:0.2.0 is-dotfile:1.0.0 is-extglob:1.0.0 is-glob:1.1.3"

inherit node-module

DESCRIPTION="Parse a glob pattern into an object of tokens"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

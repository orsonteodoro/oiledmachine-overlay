# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.0"
NODE_MODULE_DEPEND="prelude-ls:1.1.0"

inherit node-module

DESCRIPTION="type-check allows you to check the types of JavaScript values at runtime with a Haskell like type syntax."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_NAME="object.omit"
NODE_MODULE_DEPEND="for-own:0.1.1 isobject:0.2.0"

inherit node-module

DESCRIPTION="Return a copy of an object excluding the given key, or array of keys"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

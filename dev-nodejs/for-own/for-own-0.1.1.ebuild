# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="for-in:0.1.1"

inherit node-module

DESCRIPTION="Iterate over the own enumerable properties of an object"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

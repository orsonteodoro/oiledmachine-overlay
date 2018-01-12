# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="array-slice:0.2.2"

inherit node-module

DESCRIPTION="Returns an array with only the unique values from the first array"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

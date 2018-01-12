# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_EXTRA_FILES="dist"

inherit node-module

DESCRIPTION="Generates and consumes source maps"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CHANGELOG.md )

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.9.0"
NODE_MODULE_DEPEND="eslint:0.9.2 gulp-util:3.0.1 map-stream:0.1.0 through:2.3.4"
NODE_MODULE_EXTRA_FILES="util.js"

inherit node-module

DESCRIPTION="A gulp plugin for processing files with eslint"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

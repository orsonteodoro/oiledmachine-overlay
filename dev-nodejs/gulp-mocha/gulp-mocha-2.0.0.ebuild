# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="gulp-util:3.0.0 mocha:2.0.1 through:2.3.4"

inherit node-module

DESCRIPTION="Run Mocha tests"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

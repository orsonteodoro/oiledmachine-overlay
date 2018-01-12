# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="esprima-moz semver:4.1.0 bluebird:2.3.11 chai:1.10.0 gulp-mocha:2.0.0 gulp-eslint:0.2.0 gulp:3.8.10 bower-registry-client:0.2.1 commonjs-everywhere:0.9.7"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="ECMAScript code generator"

LICENSE="BSD-2 BSD"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

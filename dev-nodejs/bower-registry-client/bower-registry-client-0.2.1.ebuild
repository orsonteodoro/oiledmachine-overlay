# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8.0"
NODE_MODULE_DEPEND="async:0.2.8 bower-config:0.5.0 graceful-fs:2.0.0 lru-cache:2.3.0 request:2.27.0 request-replay:0.2.0 rimraf:2.2.0 mkdirp:0.3.5"
NODE_MODULE_EXTRA_FILES="Client.js"

inherit node-module

DESCRIPTION="Provides easy interaction with the Bower registry."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

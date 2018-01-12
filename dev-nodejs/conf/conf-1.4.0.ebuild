# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="4.0.0"
NODE_MODULE_EXTRA_FILES="index.js"

NODE_MODULE_DEPEND="dot-prop:4.1.0 env-paths:1.0.0 make-dir:1.0.0 pkg-up:2.0.0 write-file-atomic:2.3.0"

inherit node-module

DESCRIPTION="Simple config handling for your app or module"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

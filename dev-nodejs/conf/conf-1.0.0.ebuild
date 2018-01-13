# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="dot-prop:4.1.0 env-paths:1.0.0 mkdirp:0.5.1 pkg-up:1.0.0"

inherit node-module

DESCRIPTION="Simple config handling for your app or module"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

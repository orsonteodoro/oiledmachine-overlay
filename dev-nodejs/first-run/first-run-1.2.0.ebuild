# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="configstore:2.0.0 read-pkg-up:1.0.1"

inherit node-module

DESCRIPTION="Check if it's the first time the process is run"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="restore-cursor:1.0.0"

inherit node-module

DESCRIPTION="Toggle the CLI cursor"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

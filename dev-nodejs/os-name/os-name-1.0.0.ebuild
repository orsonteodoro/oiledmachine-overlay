# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="minimist:1.1.0 osx-release:1.0.0"
NODE_MODULE_EXTRA_FILES="cli.js"

inherit node-module

DESCRIPTION="Get the name of the current operating system. Example: OS X Mavericks"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )


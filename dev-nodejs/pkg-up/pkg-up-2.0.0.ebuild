# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="find-up:2.1.0"
NODEJS_MIN_VERSION="4.0.0"

inherit node-module

DESCRIPTION="Find the closest package.json file"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="is-relative:0.1.0"

inherit node-module

DESCRIPTION="Return true if a file path is absolute."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

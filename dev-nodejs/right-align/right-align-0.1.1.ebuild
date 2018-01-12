# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="align-text:0.1.0"
NODE_MODULE_EXTRA_FILES=""

inherit node-module

DESCRIPTION="Right-align the text in a string."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_DEPEND="kind-of:1.1.0 longest:1.0.0 repeat-string:1.5.0"
NODE_MODULE_EXTRA_FILES=""

inherit node-module

DESCRIPTION="Align the text in a string."

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

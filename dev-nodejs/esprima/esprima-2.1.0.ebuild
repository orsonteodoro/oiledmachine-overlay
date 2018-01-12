# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.4.0"
NODE_MODULE_EXTRA_FILES="bin"

inherit node-module

DESCRIPTION="ECMAScript parsing infrastructure for multipurpose analysis"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md ChangeLog )

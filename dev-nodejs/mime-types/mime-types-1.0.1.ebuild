# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8"
NODE_MODULE_EXTRA_FILES="component.json"

inherit node-module

DESCRIPTION="The ultimate javascript content-type utility"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md SOURCES.md )

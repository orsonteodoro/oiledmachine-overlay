# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_DEPEND="debug:2.2.0 es6-promise:3.2.1"
NODE_MODULE_EXTRA_FILES="build.js lcov.info"

inherit node-module

DESCRIPTION="Checksum validator"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

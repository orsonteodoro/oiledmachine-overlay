# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.8"
NODE_MODULE_DEPEND="delayed-stream:0.0.5"

inherit node-module

DESCRIPTION="A stream that emits multiple other streams one after another"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( Readme.md )

src_compile() {
	true
}

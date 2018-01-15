# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODE_MODULE_NAME="@types/node"
NODE_MODULE_EXTRA_FILES="index.d.ts"

inherit node-module

SRC_URI="https://registry.npmjs.org/@types/node/-/node-7.0.18.tgz -> ${P}.tgz"
DESCRIPTION=""

LICENSE="TypeScript definitions for Node.js"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/node"

DOCS=( README.md )

src_unpack() {
	unpack ${A}
}
